import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../core/constants/app_colors.dart';
import '../services/providers.dart';

class MainScaffold extends ConsumerWidget {
  final Widget child;
  const MainScaffold({super.key, required this.child});

  int _selectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location == '/') return 0;
    if (location.startsWith('/menu')) return 1;
    if (location.startsWith('/cart')) return 2;
    if (location.startsWith('/orders')) return 3;
    return 0;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartCount = ref.watch(cartItemCountProvider);

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: AppColors.divider, width: 1),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex(context),
          onTap: (index) {
            switch (index) {
              case 0: context.go('/'); break;
              case 1: context.go('/menu'); break;
              case 2: context.go('/cart'); break;
              case 3: context.go('/orders'); break;
            }
          },
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.restaurant_menu_outlined),
              activeIcon: Icon(Icons.restaurant_menu),
              label: 'Menu',
            ),
            BottomNavigationBarItem(
              icon: Badge(
                isLabelVisible: cartCount > 0,
                label: Text('$cartCount'),
                child: const Icon(Icons.shopping_cart_outlined),
              ),
              activeIcon: Badge(
                isLabelVisible: cartCount > 0,
                label: Text('$cartCount'),
                child: const Icon(Icons.shopping_cart),
              ),
              label: 'Cart',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long_outlined),
              activeIcon: Icon(Icons.receipt_long),
              label: 'Orders',
            ),
          ],
        ),
      ),
    );
  }
}