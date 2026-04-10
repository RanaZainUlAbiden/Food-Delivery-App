import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../models/menu_item_model.dart';
import '../../../services/providers.dart';

class FeaturedItemCard extends ConsumerWidget {
  final MenuItemModel item;

  const FeaturedItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);
    final cartItem = cartItems.where((i) => i.menuItem.id == item.id).firstOrNull;
    final inCart = cartItem != null;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: AppColors.background,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  child: const Icon(Icons.fastfood,
                      size: 60, color: AppColors.divider),
                ),
                if (item.tag != null && item.tag!.isNotEmpty)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        item.tag!,
                        style: AppTextStyles.caption.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: AppTextStyles.bodyMedium
                      .copyWith(fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${AppConstants.currency} ${item.price.toInt()}',
                      style: AppTextStyles.price,
                    ),
                    inCart
                        ? Row(
                            children: [
                              _actionBtn(
                                icon: Icons.remove,
                                onTap: () => ref
                                    .read(cartProvider.notifier)
                                    .decrementItem(item.id),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6),
                                child: Text('${cartItem.quantity}',
                                    style: AppTextStyles.bodyMedium.copyWith(
                                        fontWeight: FontWeight.w700)),
                              ),
                              _actionBtn(
                                icon: Icons.add,
                                onTap: () => ref
                                    .read(cartProvider.notifier)
                                    .addItem(item),
                                filled: true,
                              ),
                            ],
                          )
                        : _actionBtn(
                            icon: Icons.add,
                            onTap: () =>
                                ref.read(cartProvider.notifier).addItem(item),
                            filled: true,
                          ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionBtn(
      {required IconData icon,
      required VoidCallback onTap,
      bool filled = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: filled ? AppColors.primary : AppColors.background,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
              color: filled ? AppColors.primary : AppColors.divider),
        ),
        child: Icon(icon,
            color: filled ? Colors.white : AppColors.textPrimary, size: 16),
      ),
    );
  }
}