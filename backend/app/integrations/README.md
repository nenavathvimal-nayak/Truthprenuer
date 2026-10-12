# Truthprenuer Backend — External Service Integrations (`BACKEND/INTEGRATIONS/`)

## 1. Responsibility
Houses SDK clients and adapters for external APIs, ensuring secrets and vendor-specific abstractions remain encapsulated.

## 2. Integrated Services
| Service | Module / Package | Purpose | Boundary Invariant |
| :--- | :--- | :--- | :--- |
| **Supabase** | `supabase-py` / `gotrue` | Authentication, database operations, RLS bypass for admin actions via Service Role key | Service role key strictly server-side; never leaked to client |
| **Google Gemini AI** | `google-generativeai` | Automated hypothesis validation and critique generation | API key strictly isolated on server; input prompt sanitized against injection |
| **Cloudflare** | Edge Web Delivery | Web build deployment for user-facing app | Admin UI completely excluded from public web hosting |
