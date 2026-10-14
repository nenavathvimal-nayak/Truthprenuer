"""Truthprenuer Backend API Gateway."""
from app.api.v1 import health, ai, admin

__all__ = ["health", "ai", "admin"]
