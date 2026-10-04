import time
from collections import defaultdict
from typing import Dict, Tuple
from fastapi import HTTPException, Request, status

class SlidingWindowRateLimiter:
    def __init__(self, requests_per_minute: int = 60):
        self.requests_per_minute = requests_per_minute
        self.window_size = 60.0  # seconds
        # key -> list of timestamps
        self.history: Dict[str, list] = defaultdict(list)

    def is_allowed(self, key: str, max_requests: int = None) -> Tuple[bool, int]:
        """
        Check if request is allowed for key.
        Returns (is_allowed, seconds_to_wait).
        """
        limit = max_requests or self.requests_per_minute
        now = time.time()
        cutoff = now - self.window_size
        
        # Clean timestamps older than window
        timestamps = [t for t in self.history[key] if t > cutoff]
        self.history[key] = timestamps
        
        if len(timestamps) >= limit:
            oldest_in_window = timestamps[0]
            retry_after = int(self.window_size - (now - oldest_in_window)) + 1
            return False, max(1, retry_after)
            
        self.history[key].append(now)
        return True, 0

# Global singletons
default_limiter = SlidingWindowRateLimiter(requests_per_minute=60)
ai_endpoint_limiter = SlidingWindowRateLimiter(requests_per_minute=10)
auth_limiter = SlidingWindowRateLimiter(requests_per_minute=15)

def check_rate_limit(request: Request, limiter: SlidingWindowRateLimiter = default_limiter, max_requests: int = None):
    # Extract client IP
    client_ip = request.client.host if request.client else "unknown"
    forwarded_for = request.headers.get("X-Forwarded-For")
    if forwarded_for:
        client_ip = forwarded_for.split(",")[0].strip()
        
    allowed, wait_seconds = limiter.is_allowed(client_ip, max_requests)
    if not allowed:
        raise HTTPException(
            status_code=status.HTTP_429_TOO_MANY_REQUESTS,
            detail="Rate limit exceeded. Please try again later.",
            headers={"Retry-After": str(wait_seconds)}
        )
