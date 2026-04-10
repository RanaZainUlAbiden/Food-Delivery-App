class OrderModel {
  final int id;
  final String orderNumber;
  final String customerPhone;
  final String? customerName;
  final String address;
  final double totalAmount;
  final double deliveryFee;
  final String status;
  final String paymentMethod;
  final String paymentStatus;
  final DateTime createdAt;
  final List<OrderItemModel> items;

  OrderModel({
    required this.id,
    required this.orderNumber,
    required this.customerPhone,
    this.customerName,
    required this.address,
    required this.totalAmount,
    required this.deliveryFee,
    required this.status,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.createdAt,
    required this.items,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      orderNumber: json['orderNumber'],
      customerPhone: json['customerPhone'],
      customerName: json['customerName'],
      address: json['address'],
      totalAmount: (json['totalAmount'] as num).toDouble(),
      deliveryFee: (json['deliveryFee'] as num).toDouble(),
      status: json['status'],
      paymentMethod: json['paymentMethod'],
      paymentStatus: json['paymentStatus'],
      createdAt: DateTime.parse(json['createdAt']),
      items: (json['items'] as List)
          .map((i) => OrderItemModel.fromJson(i))
          .toList(),
    );
  }
}

class OrderItemModel {
  final int id;
  final int quantity;
  final double price;
  final String menuItemName;

  OrderItemModel({
    required this.id,
    required this.quantity,
    required this.price,
    required this.menuItemName,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['id'],
      quantity: json['quantity'],
      price: (json['price'] as num).toDouble(),
      menuItemName: json['menuItem']['name'],
    );
  }
}