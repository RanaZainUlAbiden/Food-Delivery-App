import 'package:go_router/go_router.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/menu/screens/menu_screen.dart';
import '../../features/cart/screens/cart_screen.dart';
import '../../features/orders/screens/orders_screen.dart';
import '../../widgets/main_scaffold.dart';
import '../../splash_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    ShellRoute(
      builder: (context, state, child) {
        return MainScaffold(child: child);
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/menu',
          builder: (context, state) => const MenuScreen(),
        ),
        GoRoute(
          path: '/cart',
          builder: (context, state) => const CartScreen(),
        ),
        GoRoute(
          path: '/orders',
          builder: (context, state) => const OrdersScreen(),
        ),
      ],
    ),
  ],
);