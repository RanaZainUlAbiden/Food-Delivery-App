import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../services/providers.dart';
import '../widgets/category_pill.dart';
import '../widgets/featured_item_card.dart';
import '../widgets/promo_banner.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedCategory = 0;

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoriesProvider);
    final categories = categoriesAsync.value ?? ['All'];
    final selectedCategoryName =
        _selectedCategory == 0 ? null : categories[_selectedCategory];
    final menuAsync = ref.watch(menuProvider(selectedCategoryName));
    final cartCount = ref.watch(cartItemCountProvider);

    return Scaffold(
      backgroundColor: AppColors.background,

      // ── Floating Cart Button ──
      floatingActionButton: cartCount > 0
          ? FloatingActionButton.extended(
              onPressed: () => context.go('/cart'),
              backgroundColor: AppColors.primary,
              elevation: 4,
              icon: const Icon(Icons.shopping_cart, color: Colors.white),
              label: Text(
                '$cartCount items',
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          : null,

      body: CustomScrollView(
        slivers: [
          // ── App Bar ──
          SliverAppBar(
            floating: true,
            snap: true,
            backgroundColor: AppColors.primary,
            elevation: 0,
            toolbarHeight: 70,
            title: Row(
              children: [
                // Logo
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(4),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      'assets/images/logo.png',
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.restaurant,
                        color: AppColors.primary,
                        size: 24,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'The Stone Oves',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: Colors.white70,
                            size: 12,
                          ),
                          const SizedBox(width: 2),
                          Flexible(
                            child: Text(
                              'Lahore, Pakistan',
                              style: AppTextStyles.caption.copyWith(
                                color: Colors.white70,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              // Notification Bell
              Container(
                margin: const EdgeInsets.only(right: 16),
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.notifications_outlined,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),

          // ── Body ──
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Search Bar ──
                Container(
                  color: AppColors.primary,
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 14),
                        const Icon(Icons.search,
                            color: AppColors.textHint, size: 22),
                        const SizedBox(width: 10),
                        Text(
                          'Search pizzas, burgers...',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textHint,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 4),

                // ── Promo Banner ──
                const PromoBanner(),

                const SizedBox(height: 28),

                // ── Categories ──
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Categories', style: AppTextStyles.h3),
                      Text(
                        'See all',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                SizedBox(
                  height: 42,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      return CategoryPill(
                        label: categories[index],
                        isSelected: _selectedCategory == index,
                        onTap: () =>
                            setState(() => _selectedCategory = index),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 28),

                // ── Popular Items ──
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Popular Items', style: AppTextStyles.h3),
                      Text(
                        'See all',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                menuAsync.when(
                  loading: () => const Padding(
                    padding: EdgeInsets.all(40),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  error: (e, _) => Padding(
                    padding: const EdgeInsets.all(40),
                    child: Center(
                      child: Column(
                        children: [
                          const Icon(Icons.wifi_off,
                              size: 48, color: AppColors.divider),
                          const SizedBox(height: 12),
                          Text('Could not load items',
                              style: AppTextStyles.bodyMedium),
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: () => ref.refresh(
                                menuProvider(selectedCategoryName)),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  data: (items) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.75,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                      ),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        return FeaturedItemCard(item: items[index]);
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
    );
  }
}