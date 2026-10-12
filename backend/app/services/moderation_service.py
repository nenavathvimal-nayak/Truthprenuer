import time
import uuid
from typing import List, Optional, Dict, Any
from pydantic import BaseModel, Field
from app.core.config import settings
from app.core.logging import app_logger

class ModerationReport(BaseModel):
    id: str
    target_type: str  # "post", "comment", "user", "validation"
    target_id: str
    reporter_id: str
    reason: str
    details: Optional[str] = None
    status: str = "pending"  # "pending", "resolved", "dismissed"
    action_taken: Optional[str] = None
    moderator_id: Optional[str] = None
    created_at: float
    updated_at: float

class ModerationService:
    """
    Manages reports and content moderation actions.
    Persists to Supabase database (reports, profiles) with fallback in-memory caching.
    """
    def __init__(self):
        self._reports: Dict[str, ModerationReport] = {}
        self._suspended_users: Dict[str, Dict[str, Any]] = {}
        self._supabase_client = None
        
        # Seed initial sample data for moderation queue verification
        sample_id = str(uuid.uuid4())
        self._reports[sample_id] = ModerationReport(
            id=sample_id,
            target_type="post",
            target_id="post_sample_99",
            reporter_id="user_flag_01",
            reason="Suspected spam / deceptive promotion",
            details="Repeated identical messages posted across multiple validations.",
            status="pending",
            created_at=time.time() - 3600,
            updated_at=time.time() - 3600
        )

    def _get_client(self):
        if self._supabase_client is not None:
            return self._supabase_client
        if not settings.SUPABASE_URL:
            return None
        key = settings.SUPABASE_SERVICE_ROLE_KEY or settings.SUPABASE_ANON_KEY
        if not key:
            return None
        try:
            from supabase import create_client
            self._supabase_client = create_client(settings.SUPABASE_URL, key)
            return self._supabase_client
        except Exception as exc:
            app_logger.warning(f"Could not initialize Supabase client for moderation service: {exc}")
            return None

    def list_reports(self, status: Optional[str] = None, limit: int = 50, offset: int = 0) -> List[ModerationReport]:
        client = self._get_client()
        if client:
            try:
                q = client.table("reports").select("*").order("created_at", desc=True)
                if status:
                    q = q.eq("status", status)
                res = q.range(offset, offset + limit - 1).execute()
                if res.data and len(res.data) > 0:
                    db_reports = []
                    for row in res.data:
                        created_ts = time.time()
                        if row.get("created_at"):
                            try:
                                from datetime import datetime
                                dt = datetime.fromisoformat(row["created_at"].replace("Z", "+00:00"))
                                created_ts = dt.timestamp()
                            except Exception:
                                pass
                        db_reports.append(ModerationReport(
                            id=str(row.get("id")),
                            target_type=row.get("target_type") or "validation",
                            target_id=str(row.get("target_id") or ""),
                            reporter_id=str(row.get("reporter_id") or "anonymous"),
                            reason=row.get("reason") or "Flagged content",
                            details=row.get("explanation"),
                            status=row.get("status") or "pending",
                            action_taken=None,
                            moderator_id=None,
                            created_at=created_ts,
                            updated_at=created_ts
                        ))
                    if db_reports:
                        return db_reports
            except Exception as e:
                app_logger.info(f"Database reports query unavailable, falling back to local queue: {e}")

        items = list(self._reports.values())
        if status:
            items = [r for r in items if r.status == status]
        items.sort(key=lambda x: x.created_at, reverse=True)
        return items[offset : offset + limit]

    def get_report(self, report_id: str) -> Optional[ModerationReport]:
        return self._reports.get(report_id)

    def action_report(
        self,
        report_id: str,
        moderator_id: str,
        action: str,
        reason: str
    ) -> Optional[ModerationReport]:
        report = self._reports.get(report_id)
        if not report:
            report = ModerationReport(
                id=report_id,
                target_type="content",
                target_id=report_id,
                reporter_id="system",
                reason=reason,
                status="pending",
                created_at=time.time(),
                updated_at=time.time()
            )
            self._reports[report_id] = report
            
        report.status = "resolved" if action != "dismiss" else "dismissed"
        report.action_taken = action
        report.moderator_id = moderator_id
        report.updated_at = time.time()

        client = self._get_client()
        if client:
            try:
                uuid.UUID(str(report_id))
                client.table("reports").update({
                    "status": "resolved" if action != "dismiss" else "dismissed"
                }).eq("id", report_id).execute()
            except Exception as e:
                app_logger.warning(f"Failed to persist report action to database: {e}")

        return report

    def suspend_user(self, user_id: str, admin_id: str, reason: str, duration_days: Optional[int] = None) -> Dict[str, Any]:
        record = {
            "user_id": user_id,
            "suspended_by": admin_id,
            "reason": reason,
            "duration_days": duration_days,
            "suspended_at": time.time(),
            "expires_at": time.time() + (duration_days * 86400) if duration_days else None
        }
        self._suspended_users[user_id] = record

        client = self._get_client()
        if client:
            try:
                uuid.UUID(str(user_id))
                from datetime import datetime, timezone
                now_iso = datetime.now(timezone.utc).isoformat()
                client.table("profiles").update({
                    "is_suspended": True,
                    "suspended_at": now_iso,
                    "suspension_reason": reason
                }).eq("id", user_id).execute()
            except Exception as e:
                app_logger.warning(f"Failed to persist user suspension to profiles table: {e}")

        return record

    def restore_user(self, user_id: str, admin_id: str, reason: str) -> bool:
        was_in_memory = user_id in self._suspended_users
        if was_in_memory:
            del self._suspended_users[user_id]

        client = self._get_client()
        if client:
            try:
                uuid.UUID(str(user_id))
                client.table("profiles").update({
                    "is_suspended": False,
                    "suspended_at": None,
                    "suspension_reason": None
                }).eq("id", user_id).execute()
                return True
            except Exception as e:
                app_logger.warning(f"Failed to persist user restoration to profiles table: {e}")

        return was_in_memory

    def is_user_suspended(self, user_id: str) -> bool:
        record = self._suspended_users.get(user_id)
        if record:
            expires = record.get("expires_at")
            if expires and time.time() > expires:
                del self._suspended_users[user_id]
                return False
            return True

        client = self._get_client()
        if client:
            try:
                uuid.UUID(str(user_id))
                res = client.table("profiles").select("is_suspended").eq("id", user_id).limit(1).execute()
                if res.data and len(res.data) > 0:
                    return bool(res.data[0].get("is_suspended", False))
            except Exception:
                pass

        return False

moderation_service = ModerationService()
