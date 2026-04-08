import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final List<Map<String, dynamic>> _cartItems = [
    {'name': 'Mighty Meat Pizza', 'price': 1299, 'qty': 1},
    {'name': 'Stone Burger', 'price': 599, 'qty': 2},
    {'name': 'Garlic Bread', 'price': 299, 'qty': 1},
  ];

  int get _subtotal =>
      _cartItems.fold(0, (sum, item) => sum + (item['price'] * item['qty']) as int);

  int get _deliveryFee => _subtotal >= AppConstants.freeDeliveryAbove ? 0 : AppConstants.deliveryFee.toInt();

  int get _total => _subtotal + _deliveryFee;

  void _increment(int index) => setState(() => _cartItems[index]['qty']++);

  void _decrement(int index) {
    setState(() {
      if (_cartItems[index]['qty'] > 1) {
        _cartItems[index]['qty']--;
      } else {
        _cartItems.removeAt(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Text('My Cart', style: AppTextStyles.h3),
        actions: [
          if (_cartItems.isNotEmpty)
            TextButton(
              onPressed: () => setState(() => _cartItems.clear()),
              child: Text(
                'Clear',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
        ],
      ),
      body: _cartItems.isEmpty ? _buildEmpty() : _buildCart(),
      bottomNavigationBar: _cartItems.isEmpty ? null : _buildCheckoutBar(),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined,
              size: 80, color: AppColors.divider),
          const SizedBox(height: 16),
          Text('Your cart is empty', style: AppTextStyles.h3),
          const SizedBox(height: 8),
          Text(
            'Add some delicious items!',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCart() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Cart Items
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.divider),
          ),
          child: Column(
            children: List.generate(_cartItems.length, (index) {
              final item = _cartItems[index];
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        // Image placeholder
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.fastfood,
                              color: AppColors.divider),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['name'],
                                style: AppTextStyles.bodyMedium.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${AppConstants.currency} ${item['price']}',
                                style: AppTextStyles.price,
                              ),
                            ],
                          ),
                        ),
                        // Qty Controls
                        Row(
                          children: [
                            _qtyButton(
                              icon: Icons.remove,
                              onTap: () => _decrement(index),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                '${item['qty']}',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            _qtyButton(
                              icon: Icons.add,
                              onTap: () => _increment(index),
                              filled: true,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (index < _cartItems.length - 1)
                    const Divider(height: 1, color: AppColors.divider),
                ],
              );
            }),
          ),
        ),

        const SizedBox(height: 16),

        // Delivery Address
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.divider),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Delivery Address', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Enter your full address',
                  hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textHint),
                  prefixIcon: const Icon(Icons.location_on_outlined, color: AppColors.primary),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Order Summary
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.divider),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Order Summary',
                  style: AppTextStyles.bodyMedium
                      .copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              _summaryRow('Subtotal', '${AppConstants.currency} $_subtotal'),
              const SizedBox(height: 8),
              _summaryRow(
                'Delivery Fee',
                _deliveryFee == 0 ? 'FREE' : '${AppConstants.currency} $_deliveryFee',
                valueColor: _deliveryFee == 0 ? AppColors.success : null,
              ),
              if (_subtotal < AppConstants.freeDeliveryAbove) ...[
                const SizedBox(height: 6),
                Text(
                  'Add Rs. ${(AppConstants.freeDeliveryAbove - _subtotal).toInt()} more for free delivery!',
                  style: AppTextStyles.caption.copyWith(color: AppColors.primary),
                ),
              ],
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Divider(color: AppColors.divider),
              ),
              _summaryRow(
                'Total',
                '${AppConstants.currency} $_total',
                isBold: true,
              ),
            ],
          ),
        ),

        const SizedBox(height: 100),
      ],
    );
  }

  Widget _qtyButton({
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

  Widget _summaryRow(String label, String value,
      {bool isBold = false, Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
        Text(
          value,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w600,
            color: valueColor ?? (isBold ? AppColors.textPrimary : AppColors.textPrimary),
          ),
        ),
      ],
    );
  }

  Widget _buildCheckoutBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: ElevatedButton(
        onPressed: () => _showPaymentSheet(context),
        child: Text('Proceed to Pay — ${AppConstants.currency} $_total'),
      ),
    );
  }

  void _showPaymentSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _PaymentSheet(total: _total),
    );
  }
}

class _PaymentSheet extends StatefulWidget {
  final int total;
  const _PaymentSheet({required this.total});

  @override
  State<_PaymentSheet> createState() => _PaymentSheetState();
}

class _PaymentSheetState extends State<_PaymentSheet> {
  int _selected = 0;
  final _phoneController = TextEditingController();

  final List<Map<String, dynamic>> _methods = [
    {'name': 'JazzCash', 'icon': Icons.phone_android},
    {'name': 'EasyPaisa', 'icon': Icons.phone_android},
    {'name': 'Card', 'icon': Icons.credit_card},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),

            Text('Choose Payment Method', style: AppTextStyles.h3),
            const SizedBox(height: 16),

            // Payment Methods
            Row(
              children: List.generate(_methods.length, (i) {
                final selected = _selected == i;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selected = i),
                    child: Container(
                      margin: EdgeInsets.only(right: i < 2 ? 8 : 0),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: selected
                            ? AppColors.primary.withOpacity(0.1)
                            : AppColors.background,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: selected
                              ? AppColors.primary
                              : AppColors.divider,
                          width: selected ? 2 : 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            _methods[i]['icon'],
                            color: selected
                                ? AppColors.primary
                                : AppColors.textSecondary,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _methods[i]['name'],
                            style: AppTextStyles.caption.copyWith(
                              color: selected
                                  ? AppColors.primary
                                  : AppColors.textSecondary,
                              fontWeight: selected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),

            const SizedBox(height: 16),

            // Phone number
            Text('Your Phone Number',
                style: AppTextStyles.bodyMedium
                    .copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: '03XX-XXXXXXX',
                hintStyle: AppTextStyles.bodyMedium
                    .copyWith(color: AppColors.textHint),
                prefixIcon: const Icon(Icons.phone_outlined,
                    color: AppColors.primary),
              ),
            ),

            const SizedBox(height: 20),

            // Pay Button
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _showConfirmation(context);
              },
              child: Text(
                  'Pay ${AppConstants.currency} ${widget.total} Now'),
            ),

            const SizedBox(height: 8),

            Center(
              child: Text(
                '🔒  Your payment is 100% secure',
                style: AppTextStyles.caption,
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _showConfirmation(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle,
                  color: AppColors.success, size: 40),
            ),
            const SizedBox(height: 16),
            Text('Order Confirmed!', style: AppTextStyles.h3),
            const SizedBox(height: 8),
            Text(
              'Your payment was successful. Your order is being prepared!',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Track My Order'),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}