import time
import uuid
from typing import List, Optional, Dict, Any
from pydantic import BaseModel
from postgrest.types import CountMethod
from app.core.logging import app_logger, log_audit_event
from app.core.config import settings

class AuditLogEntry(BaseModel):
    event_id: str
    actor_id: str
    actor_role: str
    action: str
    target_type: str
    target_id: Optional[str] = None
    result: str = "SUCCESS"
    ip_address: Optional[str] = None
    user_agent: Optional[str] = None
    request_id: Optional[str] = None
    reason: Optional[str] = None
    details: Dict[str, Any] = {}
    timestamp: float

class AuditService:
    """
    Service responsible for recording, indexing, and querying administrative audit trails.
    Maintains an in-memory buffer for resilience and persists to Supabase admin_audit_logs.
    """
    def __init__(self, max_buffer_size: int = 1000):
        self._buffer: List[AuditLogEntry] = []
        self._max_buffer = max_buffer_size
        self._supabase_client = None

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
            app_logger.warning(f"Could not initialize Supabase client for audit trail: {exc}")
            return None

    def record(
        self,
        actor_id: str,
        actor_role: str,
        action: str,
        target_type: str,
        target_id: Optional[str] = None,
        result: str = "SUCCESS",
        ip_address: Optional[str] = None,
        user_agent: Optional[str] = None,
        request_id: Optional[str] = None,
        reason: Optional[str] = None,
        details: Optional[Dict[str, Any]] = None
    ) -> AuditLogEntry:
        entry = AuditLogEntry(
            event_id=str(uuid.uuid4()),
            actor_id=actor_id,
            actor_role=actor_role,
            action=action,
            target_type=target_type,
            target_id=target_id,
            result=result,
            ip_address=ip_address,
            user_agent=user_agent,
            request_id=request_id,
            reason=reason,
            details=details or {},
            timestamp=time.time()
        )
        
        # Store in circular buffer for instant retrieval & offline resilience
        self._buffer.insert(0, entry)
        if len(self._buffer) > self._max_buffer:
            self._buffer.pop()
            
        # Log structured output to security/audit logs
        log_audit_event(
            actor_id=actor_id,
            actor_role=actor_role,
            action=action,
            target_type=target_type,
            target_id=target_id,
            result=result,
            ip_address=ip_address,
            user_agent=user_agent,
            request_id=request_id,
            reason=reason,
            details=details
        )

        # Persist to Supabase database (WORM table: admin_audit_logs)
        client = self._get_client()
        if client:
            try:
                valid_actor_uuid = None
                if actor_id:
                    try:
                        valid_actor_uuid = str(uuid.UUID(str(actor_id)))
                    except (ValueError, AttributeError):
                        pass

                details_payload = dict(details or {})
                if not valid_actor_uuid and actor_id:
                    details_payload["raw_actor_id"] = str(actor_id)

                row_payload = {
                    "event_id": entry.event_id,
                    "actor_id": valid_actor_uuid,
                    "actor_role": actor_role,
                    "action": action,
                    "target_type": target_type,
                    "target_id": str(target_id) if target_id else None,
                    "result": result,
                    "ip_address": ip_address,
                    "user_agent": user_agent,
                    "request_id": request_id,
                    "reason": reason,
                    "details": details_payload,
                }
                client.table("admin_audit_logs").insert(row_payload).execute()
            except Exception as db_exc:
                app_logger.warning(f"Failed to persist audit log entry to database: {db_exc}")
        
        return entry

    def query(
        self,
        limit: int = 50,
        offset: int = 0,
        action: Optional[str] = None,
        actor_id: Optional[str] = None
    ) -> List[AuditLogEntry]:
        client = self._get_client()
        if client:
            try:
                q = client.table("admin_audit_logs").select("*").order("created_at", desc=True)
                if action:
                    q = q.eq("action", action)
                if actor_id:
                    try:
                        actor_uuid = str(uuid.UUID(str(actor_id)))
                        q = q.eq("actor_id", actor_uuid)
                    except (ValueError, AttributeError):
                        q = q.eq("details->>raw_actor_id", str(actor_id))
                
                resp = q.range(offset, offset + limit - 1).execute()
                if resp.data and len(resp.data) > 0:
                    entries = []
                    for row in resp.data:
                        created_at_val = row.get("created_at")
                        ts = time.time()
                        if isinstance(created_at_val, str):
                            try:
                                from datetime import datetime
                                dt = datetime.fromisoformat(created_at_val.replace("Z", "+00:00"))
                                ts = dt.timestamp()
                            except Exception:
                                pass
                        raw_id = (row.get("details") or {}).get("raw_actor_id") if isinstance(row.get("details"), dict) else None
                        actor = str(row.get("actor_id") or raw_id or "system")
                        entries.append(AuditLogEntry(
                            event_id=row.get("event_id") or str(row.get("id")),
                            actor_id=actor,
                            actor_role=row.get("actor_role") or "System",
                            action=row.get("action") or "",
                            target_type=row.get("target_type") or "system",
                            target_id=row.get("target_id"),
                            result=row.get("result") or "SUCCESS",
                            ip_address=row.get("ip_address"),
                            user_agent=row.get("user_agent"),
                            request_id=row.get("request_id"),
                            reason=row.get("reason"),
                            details=row.get("details") or {},
                            timestamp=ts
                        ))
                    return entries
            except Exception as q_exc:
                app_logger.info(f"Database query for audit logs unavailable, falling back to buffer: {q_exc}")

        # Local buffer fallback
        results = self._buffer
        if action:
            results = [e for e in results if e.action == action]
        if actor_id:
            results = [e for e in results if e.actor_id == actor_id]
        return results[offset : offset + limit]

    def count(self) -> int:
        client = self._get_client()
        if client:
            try:
                resp = client.table("admin_audit_logs").select("id", count=CountMethod.exact).execute()
                if resp.count is not None:
                    return resp.count
            except Exception:
                pass
        return len(self._buffer)

audit_service = AuditService()
