// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

/// generated route for
/// [AddEditItemScreen]
class AddEditItemRoute extends PageRouteInfo<AddEditItemRouteArgs> {
  AddEditItemRoute({
    Key? key,
    ProductEntity? product,
    List<PageRouteInfo>? children,
  }) : super(
         AddEditItemRoute.name,
         args: AddEditItemRouteArgs(key: key, product: product),
         initialChildren: children,
       );

  static const String name = 'AddEditItemRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AddEditItemRouteArgs>(
        orElse: () => const AddEditItemRouteArgs(),
      );
      return AddEditItemScreen(key: args.key, product: args.product);
    },
  );
}

class AddEditItemRouteArgs {
  const AddEditItemRouteArgs({this.key, this.product});

  final Key? key;

  final ProductEntity? product;

  @override
  String toString() {
    return 'AddEditItemRouteArgs{key: $key, product: $product}';
  }
}

/// generated route for
/// [BillNowScreen]
class BillNowRoute extends PageRouteInfo<void> {
  const BillNowRoute({List<PageRouteInfo>? children})
    : super(BillNowRoute.name, initialChildren: children);

  static const String name = 'BillNowRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const BillNowScreen();
    },
  );
}

/// generated route for
/// [HomeScreen]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const HomeScreen();
    },
  );
}

/// generated route for
/// [InvoiceScreen]
class InvoiceRoute extends PageRouteInfo<InvoiceRouteArgs> {
  InvoiceRoute({
    Key? key,
    required SaleEntity sale,
    List<PageRouteInfo>? children,
  }) : super(
         InvoiceRoute.name,
         args: InvoiceRouteArgs(key: key, sale: sale),
         initialChildren: children,
       );

  static const String name = 'InvoiceRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<InvoiceRouteArgs>();
      return InvoiceScreen(key: args.key, sale: args.sale);
    },
  );
}

class InvoiceRouteArgs {
  const InvoiceRouteArgs({this.key, required this.sale});

  final Key? key;

  final SaleEntity sale;

  @override
  String toString() {
    return 'InvoiceRouteArgs{key: $key, sale: $sale}';
  }
}

/// generated route for
/// [ManageItemsScreen]
class ManageItemsRoute extends PageRouteInfo<void> {
  const ManageItemsRoute({List<PageRouteInfo>? children})
    : super(ManageItemsRoute.name, initialChildren: children);

  static const String name = 'ManageItemsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ManageItemsScreen();
    },
  );
}

/// generated route for
/// [PaymentScreen]
class PaymentRoute extends PageRouteInfo<void> {
  const PaymentRoute({List<PageRouteInfo>? children})
    : super(PaymentRoute.name, initialChildren: children);

  static const String name = 'PaymentRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const PaymentScreen();
    },
  );
}

/// generated route for
/// [ReportsScreen]
class ReportsRoute extends PageRouteInfo<void> {
  const ReportsRoute({List<PageRouteInfo>? children})
    : super(ReportsRoute.name, initialChildren: children);

  static const String name = 'ReportsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ReportsScreen();
    },
  );
}

/// generated route for
/// [SettingsScreen]
class SettingsRoute extends PageRouteInfo<void> {
  const SettingsRoute({List<PageRouteInfo>? children})
    : super(SettingsRoute.name, initialChildren: children);

  static const String name = 'SettingsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SettingsScreen();
    },
  );
}
