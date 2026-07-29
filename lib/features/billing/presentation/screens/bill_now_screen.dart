import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/responsive/context_responsive_ext.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared_widgets/app_dialog.dart';
import '../../../../shared_widgets/app_empty_state.dart';
import '../../../../shared_widgets/app_error_view.dart';
import '../../../../shared_widgets/app_loading_indicator.dart';
import '../../../products/presentation/providers/product_list_provider.dart';
import '../providers/cart_provider.dart';
import '../widgets/cart_total_bar.dart';
import '../widgets/product_stepper_card.dart';

@RoutePage()
class BillNowScreen extends ConsumerWidget {
  const BillNowScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textStyles = AppTextStyles.of(context);
    final productsState = ref.watch(productListProvider);
    final cart = ref.watch(cartProvider);
    final totalAmount = ref.watch(billingTotalProvider);
    final cartNotifier = ref.read(cartProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.billNow, style: textStyles.headline),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, size: AppSizes.iconMd),
          onPressed: () => context.router.maybePop(),
        ),
      ),
      body: productsState.when(
        loading: () => const AppLoadingIndicator(),
        error: (err, stack) => AppErrorView(
          onRetry: () => ref.read(productListProvider.notifier).loadProducts(),
        ),
        data: (products) {
          if (products.isEmpty) {
            return const AppEmptyState(
              icon: AppAssets.billIcon,
              title: AppStrings.noProductsAvailable,
            );
          }

          return Column(
            children: [
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: context.gridColumns,
                    childAspectRatio: 0.78,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    final qty = cartNotifier.getQuantity(product.id);
                    return ProductStepperCard(
                      product: product,
                      quantity: qty,
                      onAdd: () => cartNotifier.addProduct(product),
                      onRemove: () => cartNotifier.removeProduct(product),
                    );
                  },
                ),
              ),
              CartTotalBar(
                totalAmount: totalAmount,
                onClear: () async {
                  final confirm = await AppDialog.show(
                    context,
                    message: 'Clear all items from cart?',
                    icon: AppAssets.deleteIcon,
                  );
                  if (confirm == true) {
                    cartNotifier.clearCart();
                  }
                },
                onPayNow: () {
                  if (cart.isNotEmpty) {
                    context.router.push(const PaymentRoute());
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
