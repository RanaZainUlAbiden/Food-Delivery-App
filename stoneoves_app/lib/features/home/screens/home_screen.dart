import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../services/providers.dart';
import '../widgets/category_pill.dart';
import '../widgets/featured_item_card.dart';
import '../widgets/hero_video_player.dart';

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

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            snap: true,
            backgroundColor: AppColors.surface,
            elevation: 0,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Delivering to', style: AppTextStyles.caption),
                Row(
                  children: [
                    const Icon(Icons.location_on,
                        color: AppColors.primary, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      'Lahore, Pakistan',
                      style: AppTextStyles.bodyMedium
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                    const Icon(Icons.keyboard_arrow_down,
                        size: 18, color: AppColors.textSecondary),
                  ],
                ),
              ],
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.notifications_outlined,
                    color: AppColors.textPrimary),
              ),
            ],
          ),

          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),

                // Search Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.divider),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 12),
                        const Icon(Icons.search,
                            color: AppColors.textHint, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Search for pizzas, burgers...',
                          style: AppTextStyles.bodyMedium
                              .copyWith(color: AppColors.textHint),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                const HeroVideoPlayer(),
                const SizedBox(height: 24),

                // Categories
                const Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: Text('Categories', style: AppTextStyles.h3),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 40,
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

                const SizedBox(height: 24),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('Popular Items', style: AppTextStyles.h3),
                ),
                const SizedBox(height: 12),

                // Menu Items
                menuAsync.when(
                  loading: () => const Padding(
                    padding: EdgeInsets.all(40),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  error: (e, _) => const Padding(
                    padding: EdgeInsets.all(40),
                    child: Center(
                      child: Text('Error loading items',
                          style: AppTextStyles.bodyMedium),
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
                        childAspectRatio: 0.78,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
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