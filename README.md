# Truthprenuer — User-Facing Client Applications

[![Truthprenuer CI](https://github.com/Truthprenuer/Truthprenuer/actions/workflows/ci.yml/badge.svg)](https://github.com/Truthprenuer/Truthprenuer/actions/workflows/ci.yml)
[![License: Proprietary](https://img.shields.io/badge/License-Proprietary-blue.svg)](LICENSE)

Truthprenuer is an enterprise startup hypothesis validation, feedback intelligence, and credibility platform. This repository contains the **User-Facing Client Applications** across mobile, web, and desktop.

---

## 1. Architectural Scope

This repository is strictly scoped to client-side consumer applications:

```text
Truthprenuer/
└── USERS/                 # Flutter 3.29 Universal Multi-Platform Client
    ├── lib/               # Application code (Riverpod state, views, models)
    ├── test/              # 64 unit and widget test cases
    ├── pubspec.yaml       # Flutter manifest & dependencies
    ├── web/               # Web build & Cloudflare Pages hosting
    ├── android/           # Android native embedding & Gradle files
    ├── ios/               # iOS native embedding, Xcode workspace & Podfile
    └── macos, linux, win  # Desktop embeddings
```

> **Ownership Notice:**  
> The **Admin Console UI** and **Privileged Admin APIs** are **NOT** contained in this repository.  
> They are exclusively owned, maintained, and operated in **`TRUTHPRENUER-ADMIN`** on loopback (`http://127.0.0.1:60135`).  
> Shared backend services and database schemas are housed in **`TRUTHPRENUER-PLATFORM`**.

---

## 2. Quick Start

### 2.1 Local Flutter Client Development
```bash
# Navigate to the user applications directory
cd USERS

# Install dependencies
flutter pub get

# Launch in Chrome (Web)
flutter run -d chrome --web-port=8080

# Or launch on iOS / Android simulator
flutter run
```

### 2.2 Running Tests
```bash
cd USERS
flutter test --no-pub
```
