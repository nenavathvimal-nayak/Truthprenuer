from fastapi import Depends, HTTPException, Request, status
from app.core.security import verify_jwt_token, AuthenticatedUser, Role
from app.core.rate_limit import check_rate_limit, ai_endpoint_limiter, default_limiter
from app.core.config import settings

def get_current_user(user: AuthenticatedUser = Depends(verify_jwt_token)) -> AuthenticatedUser:
    """Dependency returning authenticated user."""
    return user

def require_admin(user: AuthenticatedUser = Depends(get_current_user)) -> AuthenticatedUser:
    """Strict server-side RBAC: requires Admin, Super_Admin, or Security role."""
    if not user.is_admin:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Access denied: privileged administrative credentials required"
        )
    return user

def require_moderator(user: AuthenticatedUser = Depends(get_current_user)) -> AuthenticatedUser:
    """Strict server-side RBAC: requires Moderator or higher role."""
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
