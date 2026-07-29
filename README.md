# Naga Bakes — Premium POS & Analytics Dashboard

A modern, high-fidelity, and feature-rich Point of Sale (POS) and Sales Analytics application built with Flutter. Naga Bakes features a clean, premium visual aesthetic coupled with offline-first local persistence and high-performance charts.

---

## 🚀 Key Features

*   **⚡ Modern Billing System**: A streamlined interface to add items, view summary panels, select payment methods, and process transactions quickly.
*   **📊 Live Sales Reports & Spline Analytics**:
    *   Dynamic revenue trend tracking using a custom-painted Bezier spline curve area chart.
    *   Segmented tracking by time range: **Today (hourly)**, **This Month (weekly)**, and **All Time (monthly)**.
    *   Top Selling Items card detailing quantity sold, percentage share, and total revenue with linear progress indicators.
*   **💾 Local-First Persistence**: Driven by **Hive DB** for high-performance offline storage. Works completely offline with instant reads and writes.
*   **📱 Ultra-Promax UI/UX**: Professional glassmorphism card components, custom-glowing indicators, and dynamic scanning reticle overlays on payments.
*   **📄 Dynamic PDF Invoices**: Generates clean, printer-ready PDF receipts featuring structured line items and billing summaries.

---

## 🛠️ Tech Stack & Architecture

This application strictly follows **Clean Architecture** patterns for code separation, testability, and scalability:

*   **State Management**: Riverpod (with Code Generation)
*   **Navigation**: AutoRoute
*   **Database**: Hive & Hive Flutter (Local Key-Value Storage)
*   **Rendering & Painting**: Custom Spline Charts painted via Flutter `CustomPainter`
*   **PDF Engine**: `pdf` & `printing` packages

### Directory Structure
```text
lib/
├── core/                  # Theme constants, router, and utilities
│   ├── constants/         # Asset strings and app constants
│   ├── router/            # AutoRoute configurations
│   ├── theme/             # Color scheme, styling configurations, spacing, and typography
│   └── utils/             # Formatters, helpers, and image utilities
├── features/              # Feature modules
│   ├── billing/           # Checkout flow, invoices, cart, and payment pages
│   ├── products/          # Catalog management, items creation, and edit screens
│   ├── reports/           # Sales analytics, trend spline chart, metrics, and providers
│   └── settings/          # Shop configuration, homepage grid, and user preferences
└── shared_widgets/        # Global reusable UI components
```

---

## ⚡ APK Size & Performance Optimization

To produce a highly optimized build for distribution, the following compilation settings were applied:
1.  **Code & Resource Minification (R8/Proguard)**: Strips unused classes and unused resources from both Flutter and its dependencies.
2.  **Icon Font Tree-Shaking**: Stripped default unused font assets (MaterialIcons reduced by **99.5%** down to **8.9 KB**).
3.  **Dart Obfuscation**: Removed DWARF debugging symbols and obfuscated code blocks to reduce memory/disk footprint.
4.  **ABI Splitting**: Separate architectures were built to target specific devices without native bloat.

### Final Built APKs (Located in `/apk_screenshots`):
*   **`app-armeabi-v7a-release.apk`**: **15.5 MB** *(For older 32-bit Android devices)*
*   **`app-arm64-v8a-release.apk`**: **17.7 MB** *(For modern 64-bit Android devices)*
*   **`app-x86_64-release.apk`**: **19.1 MB** *(For x86_64 simulators and devices)*
*   *Note: Play Store distributions via Android App Bundle (`.aab`) will deliver individual download sizes of **~6–9 MB**.*

---

## ⚙️ Getting Started & Installation

### Prerequisites
*   [Flutter SDK](https://docs.flutter.dev/get-started/install) (version `^3.12.2`)
*   Android Studio / Xcode (for compiling)

### Setup Instructions
1.  Clone the repository:
    ```bash
    git clone https://github.com/nagavino/naga_bakes.git
    cd naga_bakes
    ```
2.  Install dependencies:
    ```bash
    flutter pub get
    ```
3.  Run code generators:
    ```bash
    flutter pub run build_runner build --delete-conflicting-outputs
    ```
4.  Run unit and widget tests:
    ```bash
    flutter test
    ```
5.  Run the app in debug mode:
    ```bash
    flutter run
    ```

---

## 📦 Build Commands

To build the highly optimized split APKs:
```bash
flutter build apk --release --split-per-abi --obfuscate --split-debug-info=build/app/outputs/symbols
```

To build the Android App Bundle for Google Play Store upload:
```bash
flutter build appbundle --release --obfuscate --split-debug-info=build/app/outputs/symbols
```
