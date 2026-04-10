import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../services/providers.dart';
import '../widgets/menu_item_card.dart';

class MenuScreen extends ConsumerStatefulWidget {
  const MenuScreen({super.key});

  @override
  ConsumerState<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends ConsumerState<MenuScreen>
    with TickerProviderStateMixin  {
  late TabController _tabController;
  List<String> _categories = ['All'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 1, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoriesProvider);

    return categoriesAsync.when(
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      ),
      error: (e, _) => Scaffold(
        body: Center(child: Text('Error: $e')),
      ),
      data: (categories) {
        if (_categories.length != categories.length) {
          _categories = categories;
          _tabController.dispose();
          _tabController = TabController(
            length: categories.length,
            vsync: this,
          );
          _tabController.addListener(() => setState(() {}));
        }

        final selectedCategory = _tabController.index == 0
            ? null
            : _categories[_tabController.index];

        final menuAsync = ref.watch(menuProvider(selectedCategory));

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.surface,
            elevation: 0,
            title: const Text('Menu', style: AppTextStyles.h3),
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
          body: menuAsync.when(
            loading: () => const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
            error: (e, _) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline,
                      size: 48, color: AppColors.error),
                  const SizedBox(height: 12),
                  const Text('Failed to load menu',
                      style: AppTextStyles.bodyMedium),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () =>
                        ref.refresh(menuProvider(selectedCategory)),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
            data: (items) => items.isEmpty
                ? const Center(
                    child: Text('No items available',
                        style: AppTextStyles.bodyMedium),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return MenuItemCard(item: items[index]);
                    },
                  ),
          ),
        );
      },
    );
  }
}