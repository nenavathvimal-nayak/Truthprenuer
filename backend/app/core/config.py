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
        "https://truthprenuer.pages.dev",
        "https://admin-truthprenuer.pages.dev",
        "http://localhost:5173",  # Admin panel (Vite dev)
        "http://localhost:3000",  # Public Web dev
        "http://localhost:8080",  # Flutter web dev
        "http://127.0.0.1:5173",
        "http://127.0.0.1:3000",
        "http://127.0.0.1:8080",
    ]

    @property
    def safe_allowed_origins(self) -> List[str]:
        """
        High Security Origin Filter:
        In production, completely disallow insecure localhost/HTTP origins.
        """
        if self.ENVIRONMENT.lower() == "production":
            return [o for o in self.ALLOWED_ORIGINS if o.startswith("https://")]
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
