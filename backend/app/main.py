from fastapi import FastAPI, Depends, HTTPException, status
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
import os
from supabase import create_client, Client
import google.generativeai as genai

app = FastAPI(
    title="Truthprenuer API",
    description="Backend services for Truthprenuer platform",
    version="1.0.0"
)

# CORS configuration
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Restrict in production
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Initialize clients (Lazy initialization for local dev without env vars)
def get_supabase() -> Client:
    url = os.environ.get("SUPABASE_URL", "http://localhost:54321")
    key = os.environ.get("SUPABASE_SERVICE_ROLE_KEY", "dummy")
    return create_client(url, key)

@app.get("/health")
def health_check():
    return {"status": "ok", "service": "Truthprenuer API"}

class ValidationPrompt(BaseModel):
    problem: str
    solution: str
    industry: str
    target_audience: str

@app.post("/api/v1/ai/validate")
async def generate_ai_validation(prompt: ValidationPrompt):
    """
    Secure endpoint for AI Validation. 
    The client calls this, and this server securely holds the Gemini API key.
    """
    gemini_key = os.environ.get("GEMINI_API_KEY")
    if not gemini_key:
        raise HTTPException(status_code=500, detail="AI service not configured")
        
    try:
        genai.configure(api_key=gemini_key)
        model = genai.GenerativeModel('gemini-1.5-flash')
        
        system_prompt = f"""
        You are an expert startup evaluator and venture capitalist.
        Analyze this startup idea:
        Problem: {prompt.problem}
        Solution: {prompt.solution}
        Industry: {prompt.industry}
        Target Audience: {prompt.target_audience}
        
        Provide a brutal, honest assessment of viability, market risks, and critical assumptions.
        """
        
        response = model.generate_content(system_prompt)
        
        return {
            "status": "success",
            "model": "gemini-1.5-flash",
            "analysis": response.text
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
