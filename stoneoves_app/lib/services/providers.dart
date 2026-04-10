import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/menu_item_model.dart';
import '../models/cart_item_model.dart';
import 'api_service.dart';

// ── Menu Provider ──
final menuProvider = FutureProvider.family<List<MenuItemModel>, String?>(
  (ref, category) async {
    final items = await ApiService.getMenuItems(category: category);
    return items.map((i) => MenuItemModel.fromJson(i)).toList();
  },
);

// ── Categories Provider ──
final categoriesProvider = FutureProvider<List<String>>((ref) async {
  final cats = await ApiService.getCategories();
  return ['All', ...cats.map((c) => c['name'] as String)];
});

// ── Cart Provider ──
class CartNotifier extends StateNotifier<List<CartItemModel>> {
  CartNotifier() : super([]);

  void addItem(MenuItemModel menuItem) {
    final index = state.indexWhere((i) => i.menuItem.id == menuItem.id);
    if (index >= 0) {
      state = [
        for (int i = 0; i < state.length; i++)
          if (i == index)
            CartItemModel(
              menuItem: state[i].menuItem,
              quantity: state[i].quantity + 1,
            )
          else
            state[i]
      ];
    } else {
      state = [...state, CartItemModel(menuItem: menuItem)];
    }
  }

  void removeItem(int menuItemId) {
    state = state.where((i) => i.menuItem.id != menuItemId).toList();
  }

  void incrementItem(int menuItemId) {
    state = [
      for (final item in state)
        if (item.menuItem.id == menuItemId)
          CartItemModel(
            menuItem: item.menuItem,
            quantity: item.quantity + 1,
          )
        else
          item
    ];
  }

  void decrementItem(int menuItemId) {
    final index = state.indexWhere((i) => i.menuItem.id == menuItemId);
    if (index >= 0 && state[index].quantity > 1) {
      state = [
        for (final item in state)
          if (item.menuItem.id == menuItemId)
            CartItemModel(
              menuItem: item.menuItem,
              quantity: item.quantity - 1,
            )
          else
            item
      ];
    } else {
      removeItem(menuItemId);
    }
  }

  void clearCart() => state = [];

  double get subtotal =>
      state.fold(0, (sum, item) => sum + item.totalPrice);

  double get deliveryFee => subtotal >= 1000 ? 0 : 50;

  double get total => subtotal + deliveryFee;

  int get itemCount => state.fold(0, (sum, item) => sum + item.quantity);
}

final cartProvider =
    StateNotifierProvider<CartNotifier, List<CartItemModel>>(
  (ref) => CartNotifier(),
);

// Cart computed values
final cartTotalProvider = Provider<double>((ref) {
  return ref.watch(cartProvider.notifier).total;
});

final cartItemCountProvider = Provider<int>((ref) {
  return ref.watch(cartProvider.notifier).itemCount;
});