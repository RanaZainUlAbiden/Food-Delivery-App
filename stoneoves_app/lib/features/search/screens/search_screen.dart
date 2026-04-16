import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../services/providers.dart';
import '../../../models/menu_item_model.dart';
import '../../home/widgets/featured_item_card.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Auto-focus on search field when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  List<MenuItemModel> _filterItems(List<MenuItemModel> items) {
    if (_searchQuery.isEmpty) return [];
    return items.where((item) {
      return item.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          (item.description?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final allMenuItems = ref.watch(allMenuItemsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.go('/'),  // ✅ FIXED: Go to Home Screen
        ),
        title: Container(
          height: 44,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextField(
            controller: _searchController,
            focusNode: _focusNode,
            onChanged: (value) {
              setState(() => _searchQuery = value);
            },
            style: AppTextStyles.bodyMedium,
            decoration: InputDecoration(
              hintText: 'Search pizzas, burgers...',
              hintStyle: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textHint,
              ),
              prefixIcon: const Icon(
                Icons.search,
                color: AppColors.textHint,
                size: 20,
              ),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(
                        Icons.clear,
                        color: AppColors.textHint,
                        size: 20,
                      ),
                      onPressed: () {
                        setState(() {
                          _searchController.clear();
                          _searchQuery = '';
                        });
                      },
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            ),
          ),
        ),
      ),
      body: allMenuItems.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (e, _) => Center(
          child: Text('Error: $e', style: AppTextStyles.bodyMedium),
        ),
        data: (items) {
          final filteredItems = _filterItems(items);
          
          if (_searchQuery.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search,
                    size: 64,
                    color: AppColors.divider,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Search for food items',
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.textHint,
                    ),
                  ),
                ],
              ),
            );
          }
          
          if (filteredItems.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search_off,
                    size: 64,
                    color: AppColors.divider,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No results found',
                    style: AppTextStyles.h3,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Try searching with different keywords',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          }
          
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.68,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: filteredItems.length,
            itemBuilder: (context, index) {
              return FeaturedItemCard(item: filteredItems[index]);
            },
          );
        },
      ),
    );
  }
}