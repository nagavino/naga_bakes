# Implementation Plan - Naga Bakes Offline Billing App

Build a complete, production-ready, offline-first mobile billing application for **Naga Bakes** tailored for a non-literate, non-tech-savvy shop owner. The app relies on vibrant, icon/photo-first visuals, large touch targets (≥64dp), zero backend dependencies, and silent crash recovery.

## User Review Required

> [!IMPORTANT]
> - **Architecture & Package Setup**: The project will utilize pinned packages (`flutter_riverpod`, `auto_route`, `hive_flutter`, `pdf`, `printing`, `share_plus`, `image_picker`, `path_provider`).
> - **No Hardcoding Guarantee**: All colors, fonts, sizes, strings, and spacings will be strictly referenced from `core/theme/` and `core/constants/`.
> - **Offline Local Storage**: Hive boxes (`products`, `sales`, `settings`) will store all data locally with automatic corruption recovery.

## Open Questions

- None. All requirements are clearly specified in the master prompt.

---

## Proposed Changes

### Layer 1: Core Foundation & Design System

#### [MODIFY] [pubspec.yaml](file:///c:/naga/flutter6/naga_cakes/pubspec.yaml)
- Add required dependencies: `flutter_riverpod`, `riverpod_annotation`, `auto_route`, `hive`, `hive_flutter`, `image_picker`, `path_provider`, `pdf`, `printing`, `share_plus`, `intl`, `uuid`.
- Add dev dependencies: `build_runner`, `riverpod_generator`, `auto_route_generator`, `mocktail`.

#### [NEW] `lib/core/`
- **Theme**: `app_colors.dart`, `app_text_styles.dart`, `app_spacing.dart`, `app_radius.dart`, `app_sizes.dart`, `app_shadows.dart`, `app_theme.dart` (Light/Dark themes + `themeModeProvider`).
- **Constants**: `app_strings.dart`, `app_assets.dart`, `app_durations.dart`.
- **Responsive**: `breakpoints.dart`, `responsive_builder.dart` (phone < 600dp, tablet ≥ 600dp).
- **Utils**: `result.dart` (Result/Either error model), `currency_formatter.dart`, `date_formatter.dart`.
- **Error**: `failure.dart`, `app_exception.dart`.
- **Router**: `app_router.dart` (AutoRoute config for Home, BillNow, Payment, Invoice, ManageItems, AddEditItem, Reports, Settings).

---

### Layer 2: Shared Widgets Library (`lib/shared_widgets/`)

#### [NEW] `lib/shared_widgets/`
- `app_button.dart` (Primary, Secondary, Success, Danger action buttons with min 64dp height).
- `app_icon_button.dart` (Large touch-target icon buttons with high contrast).
- `app_card.dart` (Standard container card with subtle elevation and rounded corners).
- `app_dialog.dart` (Iconic confirmation modal dialogs).
- `app_numeric_keypad.dart` (Custom touch-friendly numeric keypad for price input).
- `app_empty_state.dart` (Iconic empty state view).
- `app_error_view.dart` (Friendly icon-first error screen without technical traces).
- `app_loading_indicator.dart` (Custom indicator).
- `app_snackbar.dart` (Visual feedback toasts).

---

### Layer 3: Feature Modules (Clean Architecture)

#### 1. Products Feature (`lib/features/products/`)
- **Domain**: `product_entity.dart`, `product_repository.dart`, use-cases (`get_products.dart`, `add_product.dart`, `edit_product.dart`, `delete_product.dart`, `seed_initial_products.dart`).
- **Data**: `product_model.dart` (Hive adapter / plain map storage), `hive_product_data_source.dart`, `product_repository_impl.dart`.
- **Presentation**: `product_list_provider.dart`, `product_form_provider.dart`, `manage_items_screen.dart`, `add_edit_item_screen.dart`, widgets (`product_card.dart`, `product_photo_picker.dart`, `price_keypad.dart`, `delete_confirm_dialog.dart`).

#### 2. Billing Feature (`lib/features/billing/`)
- **Domain**: `cart_item_entity.dart`, `sale_entity.dart`, `sale_repository.dart`, use-cases (`add_to_cart.dart`, `remove_from_cart.dart`, `clear_cart.dart`, `checkout_sale.dart`, `generate_invoice_pdf.dart`).
- **Data**: `sale_model.dart` (Hive storage), `hive_sale_data_source.dart`, `sale_repository_impl.dart`, `pdf_invoice_service.dart`.
- **Presentation**: `cart_provider.dart`, `billing_total_provider.dart`, `bill_now_screen.dart`, `payment_screen.dart`, `invoice_screen.dart`, widgets (`product_stepper_card.dart`, `cart_total_bar.dart`, `qr_payment_panel.dart`, `invoice_preview_card.dart`).

#### 3. Reports Feature (`lib/features/reports/`)
- **Domain**: `report_entity.dart`, `reports_repository.dart`, use-cases (`get_sales_reports.dart`).
- **Data**: `reports_repository_impl.dart` (aggregates data from sales Hive box).
- **Presentation**: `reports_provider.dart`, `reports_screen.dart`, widgets (`report_summary_card.dart`, `report_range_tabs.dart`, `product_sales_tile.dart`, `sales_visual_chart.dart`).

#### 4. Settings Feature (`lib/features/settings/`)
- **Domain**: `settings_entity.dart`, `settings_repository.dart`, use-cases (`get_settings.dart`, `update_settings.dart`).
- **Data**: `settings_model.dart`, `hive_settings_data_source.dart`, `settings_repository_impl.dart`.
- **Presentation**: `settings_provider.dart`, `settings_screen.dart`, `home_screen.dart`.

---

### Layer 4: Main Entry & Code Generation

#### [MODIFY] `lib/main.dart`
- Initialize Hive & open boxes securely (`products`, `sales`, `settings`) with crash-proof auto-recovery.
- Wrap application in `ProviderScope` and set up `MaterialApp.router` with AutoRoute.
- Trigger initial seed data check on launch.

---

## Verification Plan

### Automated Tests
1. **Domain Unit Tests** (`test/features/...`):
   - `get_products_test.dart`, `add_product_test.dart`, `checkout_sale_test.dart`, `get_sales_reports_test.dart`.
2. **Widget Tests** (`test/shared_widgets/...`):
   - `app_button_test.dart`, `product_stepper_card_test.dart`, `app_numeric_keypad_test.dart`.
3. **Execution Command**:
   ```bash
   flutter test
   ```

### Manual Verification
- Test responsive layouts across phone and tablet dimensions.
- Test full offline billing flow: Add product -> Bill Now -> Pay -> Generate PDF Invoice -> View Reports -> Change Settings/Theme.
