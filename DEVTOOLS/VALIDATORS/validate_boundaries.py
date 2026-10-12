#!/usr/bin/env python3
"""Validates architectural boundaries and import restrictions."""
import os
import sys

def check_no_admin_imports_in_client():
    """Verify that lib/ does not import from admin_panel/."""
    lib_dir = "USERS/lib" if os.path.exists("USERS/lib") else "lib"
    violations = []
    if not os.path.exists(lib_dir):
        return violations

    for root, _, files in os.walk(lib_dir):
        for f in files:
            if f.endswith(".dart"):
                path = os.path.join(root, f)
                with open(path, "r", encoding="utf-8", errors="ignore") as fh:
                    for i, line in enumerate(fh, 1):
                        stripped = line.strip()
                        if stripped.startswith("import ") and ("admin_panel" in stripped or "/ADMIN/" in stripped):
                            violations.append(f"{path}:{i} - Forbidden admin package import: {stripped}")
    return violations

if __name__ == "__main__":
    violations = check_no_admin_imports_in_client()
    if violations:
        print("Architectural boundary violations found:")
        for v in violations:
            print(f"  {v}")
        sys.exit(1)
    else:
        print("[OK] Architectural boundary check passed: Zero admin package imports in client code.")
        sys.exit(0)
