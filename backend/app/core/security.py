import jwt
import time
from typing import Optional, Dict, Any
from enum import Enum
from fastapi import HTTPException, Security, status
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from app.core.config import settings
from app.core.logging import app_logger, security_logger

class Role(str, Enum):
    SUPER_ADMIN = "Super_Admin"
    ADMIN = "Admin"
    MODERATOR = "Moderator"
    SECURITY = "Security"
    SUPPORT = "Support"
    FOUNDER = "Founder"
    INVESTOR = "Investor"
    PROFESSIONAL = "Professional"
    CREATOR = "Creator"

security_bearer = HTTPBearer(auto_error=False)

class AuthenticatedUser:
    def __init__(
        self,
        user_id: str,
        email: Optional[str] = None,
        role: str = "Founder",
        claims: Optional[Dict[str, Any]] = None,
        is_signature_verified: bool = False
    ):
        self.id = user_id
        self.email = email
        self.role = role
        self.claims = claims or {}
        self.is_signature_verified = is_signature_verified

    @property
    def is_admin(self) -> bool:
        # Strict fail-closed: Privileged administrative access requires verified cryptographic signature
        return self.is_signature_verified and self.role in [Role.ADMIN.value, Role.SUPER_ADMIN.value, Role.SECURITY.value]

    @property
    def is_moderator(self) -> bool:
        # Strict fail-closed: Moderator access requires verified cryptographic signature
        return self.is_signature_verified and self.role in [Role.MODERATOR.value, Role.ADMIN.value, Role.SUPER_ADMIN.value, Role.SECURITY.value]

def verify_jwt_token(credentials: Optional[HTTPAuthorizationCredentials] = Security(security_bearer)) -> AuthenticatedUser:
    """
    Validates Supabase / standard JWT Bearer token and returns authenticated user identity.
    Fails closed if token is missing, expired, invalid, or forged.
    Privileged actions (Admin/Moderator) strictly require verified cryptographic signatures.
    """
    if not credentials:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Authentication credentials required",
            headers={"WWW-Authenticate": "Bearer"},
        )
        
    token = credentials.credentials
    secret = settings.SUPABASE_JWT_SECRET
    is_signature_verified = False
    
    try:
        # Cryptographically verify signature with secret
        if secret and secret.strip():
            payload = jwt.decode(
                token,
                secret,
                algorithms=["HS256"],
                options={"verify_exp": True, "verify_aud": False}
            )
            is_signature_verified = True
        else:
            # Strictly fail closed if in production without configured JWT secret
            if settings.ENVIRONMENT.lower() == "production":
                raise HTTPException(
                    status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                    detail="Server security configuration error: SUPABASE_JWT_SECRET required in production"
                )
            # Local development fallback: decode claims but mark as unverified signature.
            # Unsigned/unverified tokens CANNOT authorize any privileged administrative action.
            payload = jwt.decode(
                token,
                options={"verify_signature": False, "verify_exp": True}
            )
            is_signature_verified = False
            security_logger.warning("JWT decoded in development without signature verification: privileged actions disallowed")
            
        user_id = payload.get("sub")
        if not user_id:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Invalid token claims: missing subject"
            )
            
        # Server-authoritative role MUST come from app_metadata (set by Supabase service-role/admin trigger).
        # user_metadata is client-writable upon signup and MUST NEVER be trusted for privileged roles.
        PRIVILEGED_ROLES = {Role.SUPER_ADMIN.value, Role.ADMIN.value, Role.MODERATOR.value, Role.SECURITY.value}
        app_metadata = payload.get("app_metadata") or {}
        user_metadata = payload.get("user_metadata") or {}
        server_role = app_metadata.get("role")
        client_role = user_metadata.get("role")
        
        if server_role:
            # If the signature is NOT verified, NEVER allow privileged roles to be asserted
            if not is_signature_verified and server_role in PRIVILEGED_ROLES:
                security_logger.error(
                    f"Blocked unverified token attempting to assert privileged role '{server_role}' for user {user_id}"
                )
                role = Role.FOUNDER.value
            else:
                role = server_role
        elif client_role and client_role not in PRIVILEGED_ROLES:
            # Safe non-privileged persona (e.g. Founder, Investor, Professional, Creator)
            role = client_role
        else:
            role = Role.FOUNDER.value
        email = payload.get("email")
        
        return AuthenticatedUser(
            user_id=user_id,
            email=email,
            role=role,
            claims=payload,
            is_signature_verified=is_signature_verified
        )
        
    except jwt.ExpiredSignatureError:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Session has expired. Please authenticate again.",
            headers={"WWW-Authenticate": "Bearer"},
        )
    except jwt.InvalidTokenError as e:
        security_logger.warning(f"Invalid token attempt rejected: {str(e)}")
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid authentication token",
            headers={"WWW-Authenticate": "Bearer"},
        )
