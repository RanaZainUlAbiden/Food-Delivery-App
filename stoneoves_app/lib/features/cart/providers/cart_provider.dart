import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Represents an item in the local cart
class CartItem {
  final int menuItemId;
  final String name;
  final double price;
  final int quantity;

  CartItem({
    required this.menuItemId,
    required this.name,
    required this.price,
    required this.quantity,
  });

  Map<String, dynamic> toMap() {
    return {
      'menuItemId': menuItemId,
      'name': name,
      'price': price,
      'quantity': quantity,
    };
  }

  factory CartItem.fromMap(Map<dynamic, dynamic> map) {
    return CartItem(
      menuItemId: map['menuItemId'] as int,
      name: map['name'] as String,
      price: map['price'] as double,
      quantity: map['quantity'] as int,
    );
  }
}

class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]) {
    _loadCart();
  }

  Future<void> _loadCart() async {
    final box = await Hive.openBox('cartBox');
    final List<dynamic> rawCart = box.get('items', defaultValue: []);
    state = rawCart.map((item) => CartItem.fromMap(item as Map)).toList();
  }

  Future<void> _saveCart() async {
    final box = await Hive.openBox('cartBox');
    final serialized = state.map((item) => item.toMap()).toList();
    await box.put('items', serialized);
  }

  void addItem(CartItem item) {
    final existingIndex = state.indexWhere((i) => i.menuItemId == item.menuItemId);
    if (existingIndex >= 0) {
      final existing = state[existingIndex];
      final updated = CartItem(
        menuItemId: existing.menuItemId,
        name: existing.name,
        price: existing.price,
        quantity: existing.quantity + item.quantity,
      );
      state = [
        ...state.sublist(0, existingIndex),
        updated,
        ...state.sublist(existingIndex + 1),
      ];
    } else {
      state = [...state, item];
    }
    _saveCart();
  }

  void clearCart() {
    state = [];
    _saveCart();
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>((ref) {
  return CartNotifier();
});
