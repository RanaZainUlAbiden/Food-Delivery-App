import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../widgets/menu_item_card.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> _categories = [
    'All',
    'Pizzas',
    'Burgers',
    'Deals',
    'Drinks',
    'Sides',
  ];

  final List<Map<String, dynamic>> _allItems = [
    {
      'name': 'Mighty Meat Pizza',
      'price': 1299,
      'category': 'Pizzas',
      'tag': 'Best Seller',
      'description': 'Loaded with beef, chicken, and sausage on our signature sauce.',
    },
    {
      'name': 'BBQ Chicken Pizza',
      'price': 1099,
      'category': 'Pizzas',
      'tag': '',
      'description': 'Smoky BBQ sauce with grilled chicken and mozzarella.',
    },
    {
      'name': 'Veggie Delight Pizza',
      'price': 899,
      'category': 'Pizzas',
      'tag': '',
      'description': 'Fresh veggies on tomato sauce with extra cheese.',
    },
    {
      'name': 'Stone Burger',
      'price': 599,
      'category': 'Burgers',
      'tag': 'New',
      'description': 'Juicy beef patty with our special stone sauce.',
    },
    {
      'name': 'Zinger Burger',
      'price': 649,
      'category': 'Burgers',
      'tag': 'Hot',
      'description': 'Crispy spicy chicken with coleslaw and mayo.',
    },
    {
      'name': 'Double Smash',
      'price': 849,
      'category': 'Burgers',
      'tag': '',
      'description': 'Double smash beef patty with cheese and pickles.',
    },
    {
      'name': 'Family Deal',
      'price': 2499,
      'category': 'Deals',
      'tag': 'Best Value',
      'description': '2 Large Pizzas + 4 Drinks + Garlic Bread.',
    },
    {
      'name': 'Student Deal',
      'price': 799,
      'category': 'Deals',
      'tag': 'Deal',
      'description': '1 Pizza Slice + 1 Burger + 1 Drink.',
    },
    {
      'name': 'Pepsi',
      'price': 150,
      'category': 'Drinks',
      'tag': '',
      'description': 'Chilled Pepsi 500ml.',
    },
    {
      'name': '7UP',
      'price': 150,
      'category': 'Drinks',
      'tag': '',
      'description': 'Chilled 7UP 500ml.',
    },
    {
      'name': 'Garlic Bread',
      'price': 299,
      'category': 'Sides',
      'tag': '',
      'description': 'Toasted garlic bread with herb butter.',
    },
    {
      'name': 'Coleslaw',
      'price': 199,
      'category': 'Sides',
      'tag': '',
      'description': 'Fresh creamy coleslaw.',
    },
  ];

  List<Map<String, dynamic>> get _filteredItems {
    if (_categories[_tabController.index] == 'All') return _allItems;
    return _allItems
        .where((item) =>
            item['category'] == _categories[_tabController.index])
        .toList();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: _categories.length,
      vsync: this,
    );
    _tabController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Text('Menu', style: AppTextStyles.h3),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: TabBar(
            controller: _tabController,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            indicatorColor: AppColors.primary,
            indicatorWeight: 3,
            labelStyle: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: AppTextStyles.bodyMedium,
            tabs: _categories.map((c) => Tab(text: c)).toList(),
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 12),
        itemCount: _filteredItems.length,
        itemBuilder: (context, index) {
          return MenuItemCard(item: _filteredItems[index]);
        },
      ),
    );
  }
}