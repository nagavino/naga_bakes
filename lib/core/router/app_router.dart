import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../features/products/domain/entities/product_entity.dart';
import '../../features/products/presentation/screens/add_edit_item_screen.dart';
import '../../features/products/presentation/screens/manage_items_screen.dart';
import '../../features/billing/domain/entities/sale_entity.dart';
import '../../features/billing/presentation/screens/bill_now_screen.dart';
import '../../features/billing/presentation/screens/invoice_screen.dart';
import '../../features/billing/presentation/screens/payment_screen.dart';
import '../../features/reports/presentation/screens/reports_screen.dart';
import '../../features/settings/presentation/screens/home_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: HomeRoute.page, initial: true),
        AutoRoute(page: BillNowRoute.page),
        AutoRoute(page: PaymentRoute.page),
        AutoRoute(page: InvoiceRoute.page),
        AutoRoute(page: ManageItemsRoute.page),
        AutoRoute(page: AddEditItemRoute.page),
        AutoRoute(page: ReportsRoute.page),
        AutoRoute(page: SettingsRoute.page),
      ];
}
