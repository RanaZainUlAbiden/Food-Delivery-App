import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/theme/app_theme.dart';
import '../../../services/providers.dart';
import '../widgets/category_pill.dart';
import '../widgets/featured_item_card.dart';
import '../widgets/promo_banner.dart';
import '../../../models/menu_item_model.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  int _selectedCategory = 0;
  final ScrollController _scrollController = ScrollController();
  
  // Cart Bubble Animation
  late final AnimationController _cartAnimationController;
  late final Animation<double> _cartScaleAnimation;

  @override
  void initState() {
    super.initState();
    
    // Cart Bubble Animation Controller
    _cartAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _cartScaleAnimation = CurvedAnimation(
      parent: _cartAnimationController,
      curve: Curves.elasticOut,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _cartAnimationController.dispose();
    super.dispose();
  }

  void _onCategoryTap(int index) {
    HapticFeedback.selectionClick();
    setState(() => _selectedCategory = index);
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoriesProvider);
    final categories = categoriesAsync.value ?? ['All'];
    final selectedCategoryName =
        _selectedCategory == 0 ? null : categories[_selectedCategory];
    final menuAsync = ref.watch(menuProvider(selectedCategoryName));
    final cartCount = ref.watch(cartItemCountProvider);

    // Animate cart bubble when count changes
    if (cartCount > 0) {
      _cartAnimationController.forward();
    } else {
      _cartAnimationController.reverse();
    }

    return Scaffold(
      backgroundColor: AppColors.background,

      // ──────────────────────────────────────────────────────────
      // 🛒 CART BUBBLE - Bottom Right Corner with Badge
      // ──────────────────────────────────────────────────────────
      floatingActionButton: cartCount > 0
          ? ScaleTransition(
              scale: _cartScaleAnimation,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Cart Button
                  Container(
                    width: 60,
                    height: 60,
                    margin: const EdgeInsets.only(bottom: 16, right: 8),
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      shape: BoxShape.circle,
                      boxShadow: AppShadows.floatingButtonShadow,
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          HapticFeedback.mediumImpact();
                          context.go('/cart');
                        },
                        borderRadius: BorderRadius.circular(30),
                        child: const Icon(
                          Icons.shopping_cart_outlined,
                          color: Colors.white,
                          size: 26,
                        ),
                      ),
                    ),
                  ),
                  
                  // 🔴 Badge with Item Count
                  Positioned(
                    right: 0,
                    top: -4,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: AppColors.error,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 20,
                          minHeight: 20,
                        ),
                        child: Center(
                          child: Text(
                            cartCount > 99 ? '99+' : '$cartCount',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : null,

      body: RefreshIndicator(
        onRefresh: () async {
          HapticFeedback.mediumImpact();
          ref.refresh(categoriesProvider);
          ref.refresh(menuProvider(selectedCategoryName));
        },
        color: AppColors.primary,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // ──────────────────────────────────────────────────────────
            // 🍕 APP BAR - With Search Icon
            // ──────────────────────────────────────────────────────────
            SliverAppBar(
              floating: true,
              snap: true,
              backgroundColor: AppColors.primary,
              elevation: 0,
              toolbarHeight: 70,
              title: Row(
                children: [
                  // Logo
                  Hero(
                    tag: 'app_logo',
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
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
                // 🔍 SEARCH ICON
                Container(
                  margin: const EdgeInsets.only(right: 16),
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: IconButton(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      context.go('/search');
                    },
                    icon: const Icon(
                      Icons.search,
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
                  const SizedBox(height: 16),

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

                  AnimationLimiter(
                    child: SizedBox(
                      height: 42,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          return AnimationConfiguration.staggeredList(
                            position: index,
                            duration: AppAnimationDurations.medium,
                            child: SlideAnimation(
                              horizontalOffset: 50.0,
                              child: FadeInAnimation(
                                child: CategoryPill(
                                  label: categories[index],
                                  isSelected: _selectedCategory == index,
                                  onTap: () => _onCategoryTap(index),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ── Popular Items Title ──
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
                  const SizedBox(height: 12),

                  // ── Menu Items Grid ──
                  menuAsync.when(
                    loading: () => _buildShimmerLoading(),
                    error: (e, _) => _buildErrorState(e.toString(),
                        () => ref.refresh(menuProvider(selectedCategoryName))),
                    data: (items) {
                      if (items.isEmpty) {
                        return _buildEmptyState();
                      }

                      return _buildAnimatedGrid(items);
                    },
                  ),

                  // Extra space so cart bubble doesn't block content
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Shimmer Loading ───
  Widget _buildShimmerLoading() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.68,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: 6,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: AppShadows.cardShadow,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.shimmerBase,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 16,
                        width: double.infinity,
                        color: AppColors.shimmerBase,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 12,
                        width: 100,
                        color: AppColors.shimmerBase,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 18,
                        width: 60,
                        color: AppColors.shimmerBase,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ─── Animated Grid ───
  Widget _buildAnimatedGrid(List<MenuItemModel> items) {
    return AnimationLimiter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.68,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            return AnimationConfiguration.staggeredGrid(
              position: index,
              duration: AppAnimationDurations.medium,
              columnCount: 2,
              child: ScaleAnimation(
                scale: 0.5,
                child: FadeInAnimation(
                  child: FeaturedItemCard(item: items[index]),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ─── Error State ───
  Widget _buildErrorState(String error, VoidCallback onRetry) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Center(
        child: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.errorLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.wifi_off,
                size: 40,
                color: AppColors.error,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Could not load items',
              style: AppTextStyles.h3.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please check your connection',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                minimumSize: const Size(140, 44),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Empty State ───
  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Center(
        child: Column(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.background,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.restaurant_menu,
                size: 50,
                color: AppColors.divider,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'No items available',
              style: AppTextStyles.h3.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Check back later for new items',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}