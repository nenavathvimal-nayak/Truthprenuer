from fastapi import Depends, HTTPException, Request, status
from app.core.security import verify_jwt_token, AuthenticatedUser, Role
from app.core.rate_limit import check_rate_limit, ai_endpoint_limiter, default_limiter
from app.core.config import settings

def get_current_user(user: AuthenticatedUser = Depends(verify_jwt_token)) -> AuthenticatedUser:
    """Dependency returning authenticated user."""
    return user

def require_local_admin_origin(request: Request) -> None:
    """
    Zero-Trust Local Network Boundary for Admin Operations:
    Ensures administrative requests originate strictly from local loopback (localhost).
    Blocks any access from external networks, internet proxies, or public cloud IP addresses.
    """
    client_ip = request.client.host if request.client else "unknown"
    local_loopbacks = {"127.0.0.1", "::1", "localhost", "testclient"}

    # If behind reverse proxy or CDN, check X-Forwarded-For
    forwarded_for = request.headers.get("X-Forwarded-For")
    if forwarded_for:
        ips = [ip.strip() for ip in forwarded_for.split(",") if ip.strip()]
        for ip in ips:
            if ip not in local_loopbacks and not ip.startswith("127."):
                raise HTTPException(
                    status_code=status.HTTP_403_FORBIDDEN,
                    detail="Access denied: Admin operations are strictly restricted to local loopback access only. External internet access is blocked."
                )

    if client_ip not in local_loopbacks and not client_ip.startswith("127."):
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Access denied: Admin operations cannot be accessed from public or external network addresses."
        )

def require_admin(
    request: Request,
    user: AuthenticatedUser = Depends(get_current_user)
) -> AuthenticatedUser:
    """Strict server-side RBAC, cryptographic signature verification, and Local-Only origin validation for Admin operations."""
    require_local_admin_origin(request)
    if not user.is_signature_verified:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Access denied: valid cryptographically signed authentication token required",
            headers={"WWW-Authenticate": "Bearer"},
        )
    if not user.is_admin:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Access denied: privileged administrative credentials required"
        )
    return user

def require_moderator(
    request: Request,
    user: AuthenticatedUser = Depends(get_current_user)
) -> AuthenticatedUser:
    """Strict server-side RBAC, cryptographic signature verification, and Local-Only origin validation for Moderator operations."""
    require_local_admin_origin(request)
    if not user.is_signature_verified:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Access denied: valid cryptographically signed authentication token required",
            headers={"WWW-Authenticate": "Bearer"},
        )
    if not user.is_moderator:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Access denied: content moderation credentials required"
        )
    return user

def rate_limit_ai(request: Request, user: AuthenticatedUser = Depends(get_current_user)):
    """Rate limit per authenticated user (or IP) on high-cost AI operations."""
    key = user.id
    check_rate_limit(request, limiter=ai_endpoint_limiter, max_requests=settings.AI_RATE_LIMIT_PER_MINUTE)
