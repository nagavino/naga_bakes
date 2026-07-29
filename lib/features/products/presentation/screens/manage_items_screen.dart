import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared_widgets/app_dialog.dart';
import '../../../../shared_widgets/app_empty_state.dart';
import '../../../../shared_widgets/app_error_view.dart';
import '../../../../shared_widgets/app_loading_indicator.dart';
import '../../../../shared_widgets/app_snackbar.dart';
import '../providers/product_list_provider.dart';
import '../widgets/product_card.dart';

final productSearchQueryProvider = StateProvider<String>((ref) => '');

@RoutePage()
class ManageItemsScreen extends ConsumerWidget {
  final bool isEmbedded;
  const ManageItemsScreen({super.key, this.isEmbedded = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final textStyles = context.textStyles;
    
    final state = ref.watch(productListProvider);
    final searchQuery = ref.watch(productSearchQueryProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.manageItems, style: textStyles.headline),
        automaticallyImplyLeading: !isEmbedded,
        leading: isEmbedded
            ? null
            : IconButton(
                icon: const Icon(Icons.arrow_back_rounded, size: 24),
                onPressed: () => context.router.maybePop(),
              ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded, size: 28),
            onPressed: () {
              context.router.push(AddEditItemRoute());
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              onChanged: (val) => ref.read(productSearchQueryProvider.notifier).state = val,
              style: TextStyle(
                color: colors.textPrimary,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText: 'Search items...',
                hintStyle: TextStyle(
                  color: colors.textMuted,
                  fontSize: 15,
                ),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: colors.textSecondary,
                  size: 22,
                ),
                filled: true,
                fillColor: colors.keypadKeyBackground,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          // Grid View area
          Expanded(
            child: state.when(
              loading: () => const AppLoadingIndicator(),
              error: (err, stack) => AppErrorView(
                onRetry: () => ref.read(productListProvider.notifier).loadProducts(),
              ),
              data: (products) {
                final filteredProducts = products.where((product) {
                  return product.name.toLowerCase().contains(searchQuery.toLowerCase());
                }).toList();

                if (filteredProducts.isEmpty) {
                  return AppEmptyState(
                    icon: AppAssets.manageIcon,
                    title: searchQuery.isEmpty
                        ? AppStrings.noProductsAvailable
                        : 'No matching items found',
                    subtitle: searchQuery.isEmpty
                        ? 'Tap the "+" button in the header to add your first product.'
                        : 'Try searching for something else.',
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.62,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: filteredProducts.length,
                  itemBuilder: (context, index) {
                    final product = filteredProducts[index];
                    return ProductCard(
                      product: product,
                      onEdit: () {
                        context.router.push(AddEditItemRoute(product: product));
                      },
                      onDelete: () async {
                        final confirm = await AppDialog.show(
                          context,
                          message: '${AppStrings.confirmDelete}\n"${product.name}"',
                        );
                        if (confirm == true) {
                          final success = await ref
                              .read(productListProvider.notifier)
                              .deleteProduct(product.id);
                          if (context.mounted) {
                            if (success) {
                              AppSnackbar.showSuccess(context, 'Item deleted');
                            } else {
                              AppSnackbar.showError(context, 'Failed to delete item');
                            }
                          }
                        }
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
