from fastapi import APIRouter, status
from app.core.config import settings

router = APIRouter(tags=["Health"])

@router.get("/health/liveness", status_code=status.HTTP_200_OK)
def liveness_check():
    """Confirms the backend process is running."""
    return {"status": "alive", "service": "Truthprenuer API"}

@router.get("/health/readiness", status_code=status.HTTP_200_OK)
def readiness_check():
    """
    Confirms configuration is valid and service is ready for traffic.
    Does not expose sensitive connection strings or database internals.
    """
    configured = bool(settings.SUPABASE_URL and settings.SUPABASE_ANON_KEY)
    ai_configured = bool(settings.GEMINI_API_KEY)
    
    return {
        "status": "ready" if configured else "degraded",
        "service": "Truthprenuer API",
        "version": settings.VERSION,
        "environment": settings.ENVIRONMENT,
        "ai_ready": ai_configured
    }
