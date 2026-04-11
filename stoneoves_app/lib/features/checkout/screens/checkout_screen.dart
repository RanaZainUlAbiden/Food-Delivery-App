import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../cart/providers/cart_provider.dart';
import '../../../services/api_service.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _phone = '';
  String _address = '';
  String _walletNumber = '';
  String _paymentMethod = 'JazzCash';

  bool _isProcessing = false;
  bool _waitingForPayment = false;

  Future<void> _placeOrder() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    final cartItems = ref.read(cartProvider);
    if (cartItems.isEmpty) return;

    setState(() => _isProcessing = true);

    try {
      final orderPayload = {
        'customerName': _name,
        'customerPhone': _phone,
        'address': _address,
        'paymentMethod': _paymentMethod,
        'paymentRef': _walletNumber,
        'items': cartItems.map((c) => {
          'menuItemId': c.menuItemId,
          'quantity': c.quantity
        }).toList(),
      };

      // Call the API (assuming ApiService has post method configured)
      // final response = await apiService.post('/api/orders', orderPayload);
      
      // Simulate API call and Transition to Webhook waiting flow
      await Future.delayed(Duration(seconds: 2));
      
      setState(() {
        _isProcessing = false;
        _waitingForPayment = true;
      });

      // Simulate waiting for Easypaisa/Jazzcash Webhook callback
      await Future.delayed(Duration(seconds: 5));

      // Clear cart when payment verifies
      ref.read(cartProvider.notifier).clearCart();
      
      // Navigate to success
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Order Confirmed visually based on Webhook!'))
      );
      Navigator.of(context).popUntil((route) => route.isFirst);

    } catch (e) {
      setState(() => _isProcessing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to place order'))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_waitingForPayment) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Text('Please check your $_paymentMethod app to confirm payment...'),
              Text('Waiting for secure payment verification.'),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Guest Checkout')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            Text('Delivery Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextFormField(
              decoration: InputDecoration(labelText: 'Name'),
              onSaved: (val) => _name = val ?? '',
              validator: (val) => val!.isEmpty ? 'Required' : null,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Phone Number'),
              onSaved: (val) => _phone = val ?? '',
              validator: (val) => val!.isEmpty ? 'Required' : null,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Full Address'),
              onSaved: (val) => _address = val ?? '',
              validator: (val) => val!.isEmpty ? 'Required' : null,
            ),
            SizedBox(height: 20),
            Text('Payment Method', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            DropdownButtonFormField<String>(
              value: _paymentMethod,
              items: ['JazzCash', 'Easypaisa'].map((method) {
                return DropdownMenuItem(value: method, child: Text(method));
              }).toList(),
              onChanged: (val) => setState(() => _paymentMethod = val!),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: '$_paymentMethod Wallet Number'),
              onSaved: (val) => _walletNumber = val ?? '',
              validator: (val) => val!.isEmpty ? 'Required' : null,
            ),
            SizedBox(height: 40),
            _isProcessing 
              ? Center(child: CircularProgressIndicator())
              : ElevatedButton(
                  onPressed: _placeOrder,
                  child: Text('Place Order & Pay'),
                  style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50)),
                )
          ],
        ),
      ),
    );
  }
}
