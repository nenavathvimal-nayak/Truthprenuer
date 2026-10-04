import time
import uuid
from typing import List, Optional, Dict, Any
from pydantic import BaseModel, Field

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
    Provides fail-safe in-memory caching and integrates with database tables.
    """
    def __init__(self):
        self._reports: Dict[str, ModerationReport] = {}
        self._suspended_users: Dict[str, Dict[str, Any]] = {}
        
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

    def list_reports(self, status: Optional[str] = None, limit: int = 50, offset: int = 0) -> List[ModerationReport]:
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
            return None
            
        report.status = "resolved" if action != "dismiss" else "dismissed"
        report.action_taken = action
        report.moderator_id = moderator_id
        report.updated_at = time.time()
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
        return record

    def restore_user(self, user_id: str, admin_id: str, reason: str) -> bool:
        if user_id in self._suspended_users:
            del self._suspended_users[user_id]
            return True
        return False

    def is_user_suspended(self, user_id: str) -> bool:
        record = self._suspended_users.get(user_id)
        if not record:
            return False
        expires = record.get("expires_at")
        if expires and time.time() > expires:
            del self._suspended_users[user_id]
            return False
        return True

moderation_service = ModerationService()
