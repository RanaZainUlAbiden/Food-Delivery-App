import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  final List<Map<String, dynamic>> _orders = const [
    {
      'id': 'ORD-001',
      'date': 'Today, 2:30 PM',
      'items': 'Mighty Meat Pizza, Stone Burger',
      'total': 1898,
      'status': 'Preparing',
      'statusColor': 0xFFFF9800,
    },
    {
      'id': 'ORD-002',
      'date': 'Yesterday, 7:15 PM',
      'items': 'Family Deal, 2x Pepsi',
      'total': 2799,
      'status': 'Delivered',
      'statusColor': 0xFF4CAF50,
    },
    {
      'id': 'ORD-003',
      'date': '2 days ago',
      'items': 'BBQ Chicken Pizza, Garlic Bread',
      'total': 1398,
      'status': 'Delivered',
      'statusColor': 0xFF4CAF50,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Text('My Orders', style: AppTextStyles.h3),
      ),
      body: _orders.isEmpty
          ? _buildEmpty()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _orders.length,
              itemBuilder: (context, index) {
                return _OrderCard(order: _orders[index]);
              },
            ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long_outlined,
              size: 80, color: AppColors.divider),
          const SizedBox(height: 16),
          Text('No orders yet', style: AppTextStyles.h3),
          const SizedBox(height: 8),
          Text(
            'Your order history will appear here',
            style: AppTextStyles.bodyMedium
                .copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final Map<String, dynamic> order;
  const _OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    final isActive = order['status'] != 'Delivered';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order['id'],
                      style: AppTextStyles.bodyMedium
                          .copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 2),
                    Text(order['date'], style: AppTextStyles.caption),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Color(order['statusColor']).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    order['status'],
                    style: AppTextStyles.caption.copyWith(
                      color: Color(order['statusColor']),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: AppColors.divider),

          // Items & Total
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order['items'],
                  style: AppTextStyles.bodyMedium
                      .copyWith(color: AppColors.textSecondary),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${AppConstants.currency} ${order['total']}',
                      style: AppTextStyles.price,
                    ),
                    if (isActive)
                      ElevatedButton(
                        onPressed: () => _showTracking(context),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(0, 36),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                        ),
                        child: const Text('Track Order'),
                      )
                    else
                      OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(0, 36),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          side: const BorderSide(color: AppColors.primary),
                        ),
                        child: Text(
                          'Reorder',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),

          // Active order tracker
          if (isActive) ...[
            const Divider(height: 1, color: AppColors.divider),
            Padding(
              padding: const EdgeInsets.all(14),
              child: _OrderTracker(),
            ),
          ],
        ],
      ),
    );
  }

  void _showTracking(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text('Order Tracking', style: AppTextStyles.h3),
            const SizedBox(height: 20),
            _OrderTracker(),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.access_time, color: AppColors.primary),
                  const SizedBox(width: 10),
                  Text(
                    'Estimated delivery: 25-35 mins',
                    style: AppTextStyles.bodyMedium
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _OrderTracker extends StatelessWidget {
  final List<Map<String, dynamic>> _steps = const [
    {'label': 'Order Placed', 'done': true, 'icon': Icons.check_circle},
    {'label': 'Payment Confirmed', 'done': true, 'icon': Icons.payment},
    {'label': 'Preparing', 'done': true, 'icon': Icons.restaurant},
    {'label': 'Out for Delivery', 'done': false, 'icon': Icons.delivery_dining},
    {'label': 'Delivered', 'done': false, 'icon': Icons.home},
  ];

  const _OrderTracker();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(_steps.length * 2 - 1, (i) {
        if (i.isOdd) {
          final done = _steps[i ~/ 2]['done'] as bool;
          return Expanded(
            child: Container(
              height: 2,
              color: done ? AppColors.primary : AppColors.divider,
            ),
          );
        }
        final step = _steps[i ~/ 2];
        final done = step['done'] as bool;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              step['icon'] as IconData,
              color: done ? AppColors.primary : AppColors.divider,
              size: 22,
            ),
            const SizedBox(height: 4),
            Text(
              step['label'],
              style: AppTextStyles.caption.copyWith(
                color: done ? AppColors.primary : AppColors.textHint,
                fontWeight:
                    done ? FontWeight.w600 : FontWeight.w400,
                fontSize: 9,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        );
      }),
    );
  }
}