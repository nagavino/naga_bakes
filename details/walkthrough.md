# Walkthrough — Naga Bakes Offline Billing Application

The **Naga Bakes** offline mobile billing app has been successfully built from the ground up using **Flutter 3.44.4**, **Riverpod**, **AutoRoute**, **Hive**, and **Clean Architecture**.

---

## 🚀 Key Highlights & Architecture

### 1. Photo/Icon-First UI & Zero Maintenance
- Designed specifically for non-tech-savvy users: minimum text entry, reliance on vivid product photos, intuitive stepper buttons (`-` / `+`), and custom numeric keypad.
- **100% Offline-First**: Built with local Hive database storage (`products`, `sales`, `settings`). Zero API dependencies, zero backend maintenance, zero logins.
- **Silent Crash Auto-Recovery**: All storage operations automatically handle corruption scenarios by recreating boxes safely without crashing.

### 2. Strict Clean Architecture
```
lib/
├── core/                       # Theme tokens, utilities, responsive builders, failure models
│   ├── constants/             # AppStrings, AppAssets, AppSizes, AppDurations
│   ├── error/                 # Failure & AppException hierarchies
│   ├── providers/             # Global DI Providers
│   ├── responsive/            # ResponsiveBuilder & Breakpoints
│   ├── router/                # AutoRoute AppRouter definition & generated gr.dart
│   ├── theme/                 # AppColors (Light/Dark ThemeExtensions), AppTextStyles, AppTheme
│   └── utils/                 # Result<T>, CurrencyFormatter, DateFormatter, ImageHelper
├── features/
│   ├── products/              # Product Management (Domain, Data, Presentation)
│   ├── billing/               # Billing & PDF Generation (Domain, Data, Presentation)
│   ├── reports/               # Analytics & Aggregation (Domain, Data, Presentation)
│   └── settings/              # Shop Config & Theme Toggle (Domain, Data, Presentation)
└── shared_widgets/            # Reusable UI library (AppButton, AppNumericKeypad, AppCard, etc.)
```

---

## 🛠️ Feature Modules

### 1. Products Management (`/manage-items`, `/add-edit-item`)
- **Initial Seed Data**: Auto-populates 5 popular default products (Filter Tea, Masala Chai, Butter Biscuits, Veg Puff, Chocolate Cake) on first launch.
- **Custom Price Keypad**: Custom `AppNumericKeypad` prevents OS keyboard popups during price input.
- **Local Photo Storage**: Camera/Gallery photo picker with `ImageHelper` local directory persistence.
- **CRUD Operations**: Complete add, edit, and delete functionality with visual dialog confirmation.

### 2. Billing & Invoicing (`/bill-now`, `/payment`, `/invoice`)
- **Stepper Grid**: Dynamic product cards with touch-friendly `- QTY +` controls and instant subtotal recalculations.
- **Sticky Total Bar**: Displays live grand total currency in bold green with Clear Cart and Pay Now buttons.
- **QR Payment Screen**: Prominently displays uploaded UPI payment QR image with total payable amount directly above it.
- **Offline PDF Invoice**: Generates PDF receipts using `pdf` & `printing` packages with shop logo, item breakdown, and grand total. Share or print natively.

### 3. Sales Reports (`/reports`)
- **Time Range Filters**: Interactive tab switcher for **Today**, **This Month**, and **All Time**.
- **Metrics Summary Cards**: Displays total sales revenue (₹), total bills count, and total items sold.
- **Top Sellers Chart**: Visual bar chart displaying top 5 items by revenue.
- **Product Breakdown**: Itemized list with sales quantities and total earnings.

### 4. Shop Settings & Theme (`/settings`)
- **Shop Configuration**: Customizable shop name (defaults to "Naga Bakes"), logo, and payment QR code.
- **Theme Switcher**: Instant toggle between Light Mode and Dark Mode supported by custom `ThemeExtension`.

---

## 🧪 Verification & Test Results

The app includes unit tests for domain use-cases and widget tests for shared components.

```bash
flutter test
```

### Test Suite Execution Output:
```text
00:00 +0: loading C:/naga/flutter6/naga_cakes/test/features/billing/domain/usecases/checkout_sale_test.dart
00:00 +0: checkout_sale_test.dart: should execute checkoutSale on repository successfully
00:00 +1: add_product_test.dart: should call addProduct on repository and return Success
00:01 +2: get_products_test.dart: should return list of products from repository
00:01 +3: app_button_test.dart: AppButton renders label and triggers onPressed callback
00:02 +4: app_numeric_keypad_test.dart: AppNumericKeypad emits key taps correctly
00:03 +5: widget_test.dart: AppCard renders child and responds to tap
00:04 +6: All tests passed!
```

---

## 📁 Key Files Created

- [pubspec.yaml](file:///c:/naga/flutter6/naga_cakes/pubspec.yaml)
- [main.dart](file:///c:/naga/flutter6/naga_cakes/lib/main.dart)
- [app_router.dart](file:///c:/naga/flutter6/naga_cakes/lib/core/router/app_router.dart)
- [app_colors.dart](file:///c:/naga/flutter6/naga_cakes/lib/core/theme/app_colors.dart)
- [home_screen.dart](file:///c:/naga/flutter6/naga_cakes/lib/features/settings/presentation/screens/home_screen.dart)
- [bill_now_screen.dart](file:///c:/naga/flutter6/naga_cakes/lib/features/billing/presentation/screens/bill_now_screen.dart)
- [payment_screen.dart](file:///c:/naga/flutter6/naga_cakes/lib/features/billing/presentation/screens/payment_screen.dart)
- [invoice_screen.dart](file:///c:/naga/flutter6/naga_cakes/lib/features/billing/presentation/screens/invoice_screen.dart)
- [manage_items_screen.dart](file:///c:/naga/flutter6/naga_cakes/lib/features/products/presentation/screens/manage_items_screen.dart)
- [add_edit_item_screen.dart](file:///c:/naga/flutter6/naga_cakes/lib/features/products/presentation/screens/add_edit_item_screen.dart)
- [reports_screen.dart](file:///c:/naga/flutter6/naga_cakes/lib/features/reports/presentation/screens/reports_screen.dart)
- [settings_screen.dart](file:///c:/naga/flutter6/naga_cakes/lib/features/settings/presentation/screens/settings_screen.dart)
