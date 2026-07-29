import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../products/domain/entities/product_entity.dart';
import '../../domain/entities/cart_item_entity.dart';

final cartProvider = StateNotifierProvider<CartNotifier, List<CartItemEntity>>((ref) {
  return CartNotifier();
});

class CartNotifier extends StateNotifier<List<CartItemEntity>> {
  CartNotifier() : super([]);

  void addProduct(ProductEntity product) {
    final index = state.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      final current = state[index];
      final updated = current.copyWith(quantity: current.quantity + 1);
      state = [
        for (int i = 0; i < state.length; i++)
          if (i == index) updated else state[i]
      ];
    } else {
      state = [...state, CartItemEntity(product: product, quantity: 1)];
    }
  }

  void removeProduct(ProductEntity product) {
    final index = state.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      final current = state[index];
      if (current.quantity > 1) {
        final updated = current.copyWith(quantity: current.quantity - 1);
        state = [
          for (int i = 0; i < state.length; i++)
            if (i == index) updated else state[i]
        ];
      } else {
        state = state.where((item) => item.product.id != product.id).toList();
      }
    }
  }

  void clearCart() {
    state = [];
  }

  int getQuantity(String productId) {
    final index = state.indexWhere((item) => item.product.id == productId);
    return index >= 0 ? state[index].quantity : 0;
  }
}

final billingTotalProvider = Provider<double>((ref) {
  final cart = ref.watch(cartProvider);
  return cart.fold(0.0, (total, item) => total + item.subtotal);
});
