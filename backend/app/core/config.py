import os
from typing import List
from pydantic_settings import BaseSettings
from pydantic import Field

class Settings(BaseSettings):
    PROJECT_NAME: str = "Truthprenuer API"
    VERSION: str = "1.0.0"
    ENVIRONMENT: str = Field(default="development", env="ENVIRONMENT")
    
    # Security & CORS
    ALLOWED_ORIGINS: List[str] = [
        "https://truthprenuer.pages.dev",  # User application (Online / Cloud / Internet)
        "http://localhost:60135",  # Admin panel (Strictly Localhost:60135)
        "http://127.0.0.1:60135",  # Admin panel (Strictly Localhost:60135)
        "http://localhost:5173",  # Local dev fallback
        "http://127.0.0.1:5173",
        "http://localhost:3000",  # Web app dev
        "http://localhost:8080",  # Flutter client dev
        "http://127.0.0.1:3000",
        "http://127.0.0.1:8080",
    ]

    @property
    def safe_allowed_origins(self) -> List[str]:
        """
        High Security Origin Filter:
        Allows authenticated online production user applications (HTTPS)
        and strictly loopback localhost addresses for administrative operations.
        Never permits public external HTTP origins or wildcards.
        """
        loopback_hosts = ("http://localhost:", "http://127.0.0.1:")
        if self.ENVIRONMENT.lower() == "production":
            return [
                o for o in self.ALLOWED_ORIGINS 
                if o.startswith("https://") or any(o.startswith(lh) for lh in loopback_hosts)
            ]
        return self.ALLOWED_ORIGINS

    # Supabase credentials (server-side only)
    SUPABASE_URL: str = Field(
        default="https://ledjnqvcyzqledcibjpd.supabase.co",
        env="SUPABASE_URL"
    )
    SUPABASE_ANON_KEY: str = Field(
        default="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxlZGpucXZjeXpxbGVkY2lianBkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3OTExMDIyNjUsImV4cCI6MjEwNjY3ODI2NX0.42aIIeQexSnm-dRnUE7vICv882jwl5tw70wyL3OSbhw",
        env="SUPABASE_ANON_KEY"
    )
    SUPABASE_SERVICE_ROLE_KEY: str = Field(default="", env="SUPABASE_SERVICE_ROLE_KEY")
    SUPABASE_JWT_SECRET: str = Field(default="", env="SUPABASE_JWT_SECRET")
    
    # AI service
    GEMINI_API_KEY: str = Field(default="", env="GEMINI_API_KEY")
    
    # Rate Limiting
    RATE_LIMIT_PER_MINUTE: int = 60
    AI_RATE_LIMIT_PER_MINUTE: int = 10
    
    class Config:
        env_file = ".env"
        extra = "ignore"

settings = Settings()
