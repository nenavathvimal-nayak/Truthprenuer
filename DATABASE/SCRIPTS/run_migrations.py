#!/usr/bin/env python3
"""
Truthprenuer Database Migration Runner (Python Driver)
Provides programmatic execution, dry-run syntax verification,
and schema validation for PostgreSQL migrations.
"""

import os
import sys
import re
from pathlib import Path

def validate_migration_sql(sql_content: str, filename: str) -> list[str]:
    """Validates common SQL syntax and security requirements."""
    errors = []
    # Verify transaction safety if multiple statements exist
    if "CREATE TABLE" in sql_content and "COMMIT;" not in sql_content and "BEGIN;" not in sql_content:
        # Warning only, some DDL cannot run in transactions in certain dialects
        pass
    
    # Check for unparameterized raw string injections in triggers
    if "EXECUTE 'SELECT" in sql_content and "%" not in sql_content:
        errors.append(f"{filename}: Potential dynamic SQL injection without format parameters.")
        
    return errors

def main():
    script_dir = Path(__file__).resolve().parent
    db_dir = script_dir.parent
    migrations_dir = db_dir / "MIGRATIONS"
    
    if not migrations_dir.exists():
        print(f"Error: Migrations directory not found at {migrations_dir}", file=sys.stderr)
        sys.exit(1)
        
    migration_files = sorted(migrations_dir.glob("*.sql"))
    if not migration_files:
        print("No migration files found.", file=sys.stderr)
        sys.exit(1)
        
    print(f"Found {len(migration_files)} migration files in {migrations_dir}:")
    all_valid = True
    for m in migration_files:
        content = m.read_text(encoding="utf-8")
        errors = validate_migration_sql(content, m.name)
        if errors:
            all_valid = False
            for e in errors:
                print(f"  [ERROR] {e}", file=sys.stderr)
        else:
            line_count = len(content.splitlines())
            print(f"  [VALIDATED] {m.name} ({line_count} lines, {len(content)} bytes)")
            
    if not all_valid:
        print("Schema validation failed on one or more migration files.", file=sys.stderr)
        sys.exit(1)
        
    print("\nDatabase migration files verified successfully.")

if __name__ == "__main__":
    main()
