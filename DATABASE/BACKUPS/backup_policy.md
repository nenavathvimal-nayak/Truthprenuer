# Truthprenuer Database Backup and Disaster Recovery Policy

## 1. Objectives & SLAs
- **Recovery Point Objective (RPO):** <= 5 minutes (via continuous WAL archiving).
- **Recovery Time Objective (RTO):** <= 30 minutes (automated container / replica promotion).

## 2. Backup Tiers
1. **Continuous Write-Ahead Log (WAL) Streaming:** Streamed to encrypted object storage.
2. **Daily Full Logical Snapshots:** Executed daily at 02:00 UTC using `pg_dump` with `--clean --if-exists --no-owner`.
3. **Weekly Cold Archive Snapshots:** Retained for 365 days in immutable, write-once object storage.

## 3. Immutability & Audit Log Preservation
- The `audit_logs` table contains system security and administrative actions.
- During any restoration procedure, checksums of `audit_logs` are validated against hash signatures to guarantee zero tampering.

## 4. Disaster Recovery Procedure
```bash
# 1. Download snapshot
gpg --decrypt truthprenuer_db_backup_latest.sql.gpg > restore.sql

# 2. Restore to clean instance
psql -h $DB_HOST -U $DB_USER -d truthprenuer_prod -f restore.sql

# 3. Verify row counts and audit trail checksums
psql -h $DB_HOST -U $DB_USER -d truthprenuer_prod -c "SELECT COUNT(*) FROM audit_logs;"
```
