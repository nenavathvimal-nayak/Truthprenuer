"""Supabase Database & Auth connector client."""
import os
from typing import Optional

class SupabaseBackendClient:
    """Server-side connector for Supabase PostgreSQL database."""

    def __init__(self, supabase_url: Optional[str] = None, service_key: Optional[str] = None):
        self.supabase_url = supabase_url or os.getenv("SUPABASE_URL", "")
        self.service_key = service_key or os.getenv("SUPABASE_SERVICE_ROLE_KEY", "")

    def is_configured(self) -> bool:
        return bool(self.supabase_url and self.service_key)
