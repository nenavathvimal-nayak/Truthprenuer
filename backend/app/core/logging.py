import logging
import json
import time
import uuid
from typing import Any, Dict, Optional

SENSITIVE_KEYS = {
    "password", "token", "authorization", "api_key", "secret",
    "access_token", "refresh_token", "jwt", "session"
}

def sanitize_data(data: Any) -> Any:
    """Recursively sanitize sensitive fields from dictionaries and lists."""
    if isinstance(data, dict):
        sanitized = {}
        for k, v in data.items():
            if str(k).lower() in SENSITIVE_KEYS or any(s in str(k).lower() for s in SENSITIVE_KEYS):
                sanitized[k] = "[REDACTED]"
            else:
                sanitized[k] = sanitize_data(v)
        return sanitized
    elif isinstance(data, list):
        return [sanitize_data(item) for item in data]
    return data

class StructuredJsonFormatter(logging.Formatter):
    """Outputs log records formatted as single-line JSON objects."""
    def format(self, record: logging.LogRecord) -> str:
        log_obj = {
            "timestamp": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime(record.created)),
            "level": record.levelname,
            "logger": record.name,
            "message": record.getMessage(),
        }
        
        # Attach extra structured fields if present
        if hasattr(record, "request_id"):
            log_obj["request_id"] = record.request_id
        if hasattr(record, "extra_fields"):
            log_obj.update(sanitize_data(record.extra_fields))
            
        if record.exc_info:
            log_obj["exception"] = self.formatException(record.exc_info)
            
        return json.dumps(log_obj)

def get_logger(name: str = "truthprenuer") -> logging.Logger:
    logger = logging.getLogger(name)
    if not logger.handlers:
        handler = logging.StreamHandler()
        handler.setFormatter(StructuredJsonFormatter())
        logger.addHandler(handler)
        logger.setLevel(logging.INFO)
    return logger

app_logger = get_logger("truthprenuer.app")
audit_logger = get_logger("truthprenuer.audit")
security_logger = get_logger("truthprenuer.security")

def log_audit_event(
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
):
    """Emit a structured audit log entry compliant with Section 9 & 44."""
    event = {
        "event_id": str(uuid.uuid4()),
        "actor_id": actor_id,
        "actor_role": actor_role,
        "action": action,
        "target_type": target_type,
        "target_id": target_id,
        "result": result,
        "ip_address": ip_address,
        "user_agent": user_agent,
        "reason": reason,
        "details": details or {}
    }
    record = logging.LogRecord(
        name="truthprenuer.audit",
        level=logging.INFO,
        pathname="",
        lineno=0,
        msg=f"AUDIT: {action} on {target_type}:{target_id or 'none'} by {actor_id} [{result}]",
        args=(),
        exc_info=None
    )
    record.request_id = request_id or str(uuid.uuid4())
    record.extra_fields = event
    audit_logger.handle(record)
