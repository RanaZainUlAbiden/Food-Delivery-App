import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../models/menu_item_model.dart';
import '../../../services/providers.dart';
import '../../../core/constants/app_images.dart';
class MenuItemCard extends ConsumerWidget {
  final MenuItemModel item;

  const MenuItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);
    final cartItem =
        cartItems.where((i) => i.menuItem.id == item.id).firstOrNull;
    final inCart = cartItem != null;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          // Image
          Container(
  width: 90,
  height: 90,
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(12),
    image: DecorationImage(
      image: AssetImage(AppImages.getImage(item.name)),
      fit: BoxFit.cover,
    ),
  ),
),

          const SizedBox(width: 12),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (item.tag != null && item.tag!.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(bottom: 4),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      item.tag!,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                Text(
                  item.name,
                  style: AppTextStyles.bodyMedium
                      .copyWith(fontWeight: FontWeight.w600),
                ),

                const SizedBox(height: 4),

                Text(
                  item.description ?? '',
                  style: AppTextStyles.caption,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 8),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${AppConstants.currency} ${item.price.toInt()}',
                      style: AppTextStyles.price,
                    ),

                    // Cart Controls
                    inCart
                        ? Row(
                            children: [
                              _cartBtn(
                                icon: Icons.remove,
                                onTap: () => ref
                                    .read(cartProvider.notifier)
                                    .decrementItem(item.id),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10),
                                child: Text(
                                  '${cartItem.quantity}',
                                  style: AppTextStyles.bodyMedium.copyWith(
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                              _cartBtn(
                                icon: Icons.add,
                                onTap: () => ref
                                    .read(cartProvider.notifier)
                                    .addItem(item),
                                filled: true,
                              ),
                            ],
                          )
                        : GestureDetector(
                            onTap: () => ref
                                .read(cartProvider.notifier)
                                .addItem(item),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Add',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
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

  Widget _cartBtn({
    required IconData icon,
    required VoidCallback onTap,
    bool filled = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: filled ? AppColors.primary : AppColors.background,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: filled ? AppColors.primary : AppColors.divider,
          ),
        ),
        child: Icon(
          icon,
          size: 16,
          color: filled ? Colors.white : AppColors.textPrimary,
        ),
      ),
    );
  }
}