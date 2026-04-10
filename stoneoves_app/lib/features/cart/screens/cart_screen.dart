import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../services/providers.dart';
import '../../../services/api_service.dart';
import '../../../core/constants/app_images.dart';
class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  final _addressController = TextEditingController();

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartItems = ref.watch(cartProvider);
    final cartNotifier = ref.read(cartProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const Text('My Cart', style: AppTextStyles.h3),
        actions: [
          if (cartItems.isNotEmpty)
            TextButton(
              onPressed: () => cartNotifier.clearCart(),
              child: Text('Clear',
                  style: AppTextStyles.bodyMedium
                      .copyWith(color: AppColors.primary)),
            ),
        ],
      ),
      body: cartItems.isEmpty ? _buildEmpty() : _buildCart(context, ref),
      bottomNavigationBar:
          cartItems.isEmpty ? null : _buildCheckoutBar(context, ref),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.shopping_cart_outlined,
              size: 80, color: AppColors.divider),
          const SizedBox(height: 16),
          const Text('Your cart is empty', style: AppTextStyles.h3),
          const SizedBox(height: 8),
          Text('Add some delicious items!',
              style: AppTextStyles.bodyMedium
                  .copyWith(color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildCart(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);
    final cartNotifier = ref.read(cartProvider.notifier);
    final subtotal = cartNotifier.subtotal;
    final deliveryFee = cartNotifier.deliveryFee;
    final total = cartNotifier.total;

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
            children: List.generate(cartItems.length, (index) {
              final item = cartItems[index];
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Container(
  width: 56,
  height: 56,
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(10),
    image: DecorationImage(
      image: AssetImage(AppImages.getImage(item.menuItem.name)),
      fit: BoxFit.cover,
    ),
  ),
),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.menuItem.name,
                                  style: AppTextStyles.bodyMedium.copyWith(
                                      fontWeight: FontWeight.w600)),
                              const SizedBox(height: 4),
                              Text(
                                '${AppConstants.currency} ${item.menuItem.price.toInt()}',
                                style: AppTextStyles.price,
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            _qtyButton(
                              icon: Icons.remove,
                              onTap: () => cartNotifier
                                  .decrementItem(item.menuItem.id),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: Text('${item.quantity}',
                                  style: AppTextStyles.bodyMedium.copyWith(
                                      fontWeight: FontWeight.w700)),
                            ),
                            _qtyButton(
                              icon: Icons.add,
                              onTap: () =>
                                  cartNotifier.addItem(item.menuItem),
                              filled: true,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (index < cartItems.length - 1)
                    const Divider(height: 1, color: AppColors.divider),
                ],
              );
            }),
          ),
        ),

        const SizedBox(height: 16),

        // Address
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
              Text('Delivery Address',
                  style: AppTextStyles.bodyMedium
                      .copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              TextField(
                controller: _addressController,
                decoration: InputDecoration(
                  hintText: 'Enter your full address',
                  hintStyle: AppTextStyles.bodyMedium
                      .copyWith(color: AppColors.textHint),
                  prefixIcon: const Icon(Icons.location_on_outlined,
                      color: AppColors.primary),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Summary
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
              _summaryRow('Subtotal',
                  '${AppConstants.currency} ${subtotal.toInt()}'),
              const SizedBox(height: 8),
              _summaryRow(
                'Delivery Fee',
                deliveryFee == 0
                    ? 'FREE'
                    : '${AppConstants.currency} ${deliveryFee.toInt()}',
                valueColor:
                    deliveryFee == 0 ? AppColors.success : null,
              ),
              if (subtotal < AppConstants.freeDeliveryAbove) ...[
                const SizedBox(height: 6),
                Text(
                  'Add Rs. ${(AppConstants.freeDeliveryAbove - subtotal).toInt()} more for free delivery!',
                  style: AppTextStyles.caption
                      .copyWith(color: AppColors.primary),
                ),
              ],
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Divider(color: AppColors.divider),
              ),
              _summaryRow(
                'Total',
                '${AppConstants.currency} ${total.toInt()}',
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
        child: Icon(icon,
            size: 16,
            color: filled ? Colors.white : AppColors.textPrimary),
      ),
    );
  }

  Widget _summaryRow(String label, String value,
      {bool isBold = false, Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w400,
            )),
        Text(value,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w600,
              color: valueColor ?? AppColors.textPrimary,
            )),
      ],
    );
  }

  Widget _buildCheckoutBar(BuildContext context, WidgetRef ref) {
    final total = ref.read(cartProvider.notifier).total;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: ElevatedButton(
        onPressed: () => _showPaymentSheet(context, ref),
        child: Text(
            'Proceed to Pay — ${AppConstants.currency} ${total.toInt()}'),
      ),
    );
  }

  void _showPaymentSheet(BuildContext context, WidgetRef ref) {
    if (_addressController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your delivery address'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _PaymentSheet(
        total: ref.read(cartProvider.notifier).total,
        address: _addressController.text.trim(),
        ref: ref,
      ),
    );
  }
}

class _PaymentSheet extends StatefulWidget {
  final double total;
  final String address;
  final WidgetRef ref;

  const _PaymentSheet({
    required this.total,
    required this.address,
    required this.ref,
  });

  @override
  State<_PaymentSheet> createState() => _PaymentSheetState();
}

class _PaymentSheetState extends State<_PaymentSheet> {
  int _selected = 0;
  bool _isLoading = false;
  final _phoneController = TextEditingController();
  final _nameController = TextEditingController();

  final List<Map<String, dynamic>> _methods = [
    {'name': 'JazzCash', 'icon': Icons.phone_android},
    {'name': 'EasyPaisa', 'icon': Icons.phone_android},
    {'name': 'Card', 'icon': Icons.credit_card},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
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
            const Text('Choose Payment Method', style: AppTextStyles.h3),
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
                          Icon(_methods[i]['icon'],
                              color: selected
                                  ? AppColors.primary
                                  : AppColors.textSecondary),
                          const SizedBox(height: 4),
                          Text(_methods[i]['name'],
                              style: AppTextStyles.caption.copyWith(
                                color: selected
                                    ? AppColors.primary
                                    : AppColors.textSecondary,
                                fontWeight: selected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                              )),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),

            const SizedBox(height: 16),

            // Name
            Text('Your Name',
                style: AppTextStyles.bodyMedium
                    .copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'Enter your name',
                hintStyle: AppTextStyles.bodyMedium
                    .copyWith(color: AppColors.textHint),
                prefixIcon: const Icon(Icons.person_outline,
                    color: AppColors.primary),
              ),
            ),

            const SizedBox(height: 12),

            // Phone
            Text('Phone Number',
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
              onPressed: _isLoading ? null : () => _placeOrder(context),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2),
                    )
                  : Text(
                      'Pay ${AppConstants.currency} ${widget.total.toInt()} Now'),
            ),

            const SizedBox(height: 8),
            const Center(
              child: Text('🔒  Your payment is 100% secure',
                  style: AppTextStyles.caption),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Future<void> _placeOrder(BuildContext context) async {
    if (_phoneController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your phone number'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final cartItems = widget.ref.read(cartProvider);
      final orderData = {
        'customerPhone': _phoneController.text.trim(),
        'customerName': _nameController.text.trim(),
        'address': widget.address,
        'paymentMethod': _methods[_selected]['name'],
        'paymentRef': 'PAY-${DateTime.now().millisecondsSinceEpoch}',
        'items': cartItems
            .map((i) => {
                  'menuItemId': i.menuItem.id,
                  'quantity': i.quantity,
                })
            .toList(),
      };

      await ApiService.createOrder(orderData);
      widget.ref.read(cartProvider.notifier).clearCart();

      if (context.mounted) {
        Navigator.pop(context);
        _showConfirmation(context);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Order failed: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _showConfirmation(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
            const Text('Order Confirmed!', style: AppTextStyles.h3),
            const SizedBox(height: 8),
            Text(
              'Your payment was successful. Your order is being prepared!',
              style: AppTextStyles.bodyMedium
                  .copyWith(color: AppColors.textSecondary),
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