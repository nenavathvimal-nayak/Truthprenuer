"""Cryptographic utilities and hash functions for audit integrity."""
import hashlib
import hmac

def hash_payload(data: str) -> str:
    """Compute SHA-256 hash of payload."""
    return hashlib.sha256(data.encode("utf-8")).hexdigest()

def verify_signature(secret_key: str, message: str, signature: str) -> bool:
    """Verify HMAC-SHA256 signature."""
    expected = hmac.new(secret_key.encode("utf-8"), message.encode("utf-8"), hashlib.sha256).hexdigest()
    return hmac.compare_digest(expected, signature)
