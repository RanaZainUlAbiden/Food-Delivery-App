import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../widgets/category_pill.dart';
import '../widgets/featured_item_card.dart';
import '../widgets/promo_banner.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedCategory = 0;

  final List<String> _categories = [
    'All',
    'Pizzas',
    'Burgers',
    'Deals',
    'Drinks',
    'Sides',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ── App Bar ──
          SliverAppBar(
            floating: true,
            snap: true,
            backgroundColor: AppColors.surface,
            elevation: 0,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Delivering to',
                  style: AppTextStyles.caption,
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: AppColors.primary,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Lahore, Pakistan',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Icon(
                      Icons.keyboard_arrow_down,
                      size: 18,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.notifications_outlined,
                  color: AppColors.textPrimary,
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
                        const Icon(
                          Icons.search,
                          color: AppColors.textHint,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Search for pizzas, burgers...',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textHint,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Promo Banner
                const PromoBanner(),

                const SizedBox(height: 24),

                // Categories
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text(
                    'Categories',
                    style: AppTextStyles.h3,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      return CategoryPill(
                        label: _categories[index],
                        isSelected: _selectedCategory == index,
                        onTap: () {
                          setState(() {
                            _selectedCategory = index;
                          });
                        },
                      );
                    },
                  ),
                ),

                const SizedBox(height: 24),

                // Featured Items
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Popular Items',
                    style: AppTextStyles.h3,
                  ),
                ),
                const SizedBox(height: 12),

                // Items Grid
                Padding(
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
                    itemCount: dummyItems.length,
                    itemBuilder: (context, index) {
                      return FeaturedItemCard(item: dummyItems[index]);
                    },
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

// Dummy data — baad mein API se aayega
final dummyItems = [
  {
    'name': 'Mighty Meat Pizza',
    'price': 1299,
    'category': 'Pizzas',
    'tag': 'Best Seller',
  },
  {
    'name': 'Stone Burger',
    'price': 599,
    'category': 'Burgers',
    'tag': 'New',
  },
  {
    'name': 'Family Deal',
    'price': 2499,
    'category': 'Deals',
    'tag': 'Deal',
  },
  {
    'name': 'BBQ Chicken Pizza',
    'price': 1099,
    'category': 'Pizzas',
    'tag': '',
  },
  {
    'name': 'Zinger Burger',
    'price': 649,
    'category': 'Burgers',
    'tag': 'Hot',
  },
  {
    'name': 'Garlic Bread',
    'price': 299,
    'category': 'Sides',
    'tag': '',
  },
];