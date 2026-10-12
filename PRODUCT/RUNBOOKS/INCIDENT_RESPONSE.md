# TRUTHPRENUER — INCIDENT RESPONSE & DISASTER RECOVERY RUNBOOK

## 1. Severity Levels & Response Times

- **SEV-0 (Critical Data or Security Breach):** Immediate (15m response). Unscheduled database loss, leaked service-role keys, unauthorized admin access.
- **SEV-1 (Major Outage):** High (1h response). Public API down, login failure across all users.
- **SEV-2 (Degraded Performance):** Moderate (4h response). AI analysis delayed, partial messaging delay.

---

## 2. Security Incident: Compromised Administrative Workstation

If the workstation running the local Admin Console is lost, infected, or compromised:

### Immediate Remediation:
1. **Invalidate Active Supabase Sessions:**
   In the Supabase cloud dashboard, revoke all user tokens for administrator accounts.
2. **Rotate Database Service Role Key & JWT Secret:**
   - In Supabase Settings -> API, click "Rotate Service Role Key".
   - Update backend production environment variable `SUPABASE_SERVICE_ROLE_KEY` and `SUPABASE_JWT_SECRET`.
   - Redeploy the backend container immediately.
3. **Audit WORM Log for Anomalous Activity:**
   Query `admin_audit_logs` directly in PostgreSQL SQL editor:
   ```sql
   SELECT * FROM admin_audit_logs 
   WHERE created_at >= NOW() - INTERVAL '24 hours' 
   ORDER BY created_at DESC;
   ```
   Inspect for unauthorized `USER_SUSPENDED` or `REPORT_RESOLVED` events.

---

## 3. Database Disaster Recovery

1. **Daily Automated Backups:**
   Supabase automatically retains daily snapshots with Point-in-Time-Recovery (PITR).
2. **Manual Snapshot Restoration:**
   - Navigate to Database -> Backups.
   - Select restoration point prior to the incident timestamp.
   - Run verification query:
     ```sql
     SELECT COUNT(*) FROM profiles;
     SELECT COUNT(*) FROM validations;
     ```
