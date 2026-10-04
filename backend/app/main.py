from fastapi import FastAPI, Request
from fastapi.middleware.cors import CORSMiddleware
from app.core.config import settings
from app.core.middleware import (
    SecurityHeadersMiddleware,
    RequestContextMiddleware,
    global_exception_handler
)
from app.api.v1 import health, ai, admin

# In production, disable interactive documentation to minimize reconnaissance surface
docs_url = "/docs" if settings.ENVIRONMENT != "production" else None
openapi_url = "/openapi.json" if settings.ENVIRONMENT != "production" else None

app = FastAPI(
    title=settings.PROJECT_NAME,
    description="Truthprenuer Enterprise Startup Launch MVP API",
    version=settings.VERSION,
    docs_url=docs_url,
    redoc_url=None,
    openapi_url=openapi_url
)

# Global fail-closed exception handler
app.add_exception_handler(Exception, global_exception_handler)

# Custom Security Headers Middleware (CSP, HSTS, X-Frame-Options, X-Content-Type-Options)
app.add_middleware(SecurityHeadersMiddleware)

# Request context and audit metrics middleware (X-Request-ID, duration)
app.add_middleware(RequestContextMiddleware)

# Strict CORS policy - never allows wildcard origins with credentials
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.ALLOWED_ORIGINS,
    allow_credentials=True,
    allow_methods=["GET", "POST", "PUT", "DELETE", "OPTIONS", "PATCH"],
    allow_headers=["Authorization", "Content-Type", "X-Request-ID", "Accept"],
    max_age=600,
)

# Mount layered routers
app.include_router(health.router)
app.include_router(ai.router)
app.include_router(admin.router)

@app.get("/", tags=["Root"])
def root_info():
    """
    Public entrypoint providing basic service heartbeat.
    Exposes no internal architecture or database topology.
    """
    return {
        "service": settings.PROJECT_NAME,
        "version": settings.VERSION,
        "status": "operational"
    }
