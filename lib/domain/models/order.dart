import 'identity.dart';

class Order implements Identity {
  @override
  final String id;
  final String productId;
  final String customerName;
  final int quantity;
  final DateTime orderDate;
  final String status;
  final double totalPrice;

  Order({
    required this.id,
    required this.productId,
    required this.customerName,
    required this.quantity,
    required this.orderDate,
    required this.status,
    required this.totalPrice,
  });

  Map<String, dynamic> toMap() => {
    "id": id,
    "productId": productId,
    "customerName": customerName,
    "quantity": quantity,
    "orderDate": orderDate.toIso8601String(),
    "status": status,
    "totalPrice": totalPrice,
  };

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map["id"] as String,
      productId: map["productId"] as String,
      customerName: map["customerName"] as String,
      quantity: map["quantity"] as int,
      orderDate: DateTime.parse(map["orderDate"] as String),
      status: map["status"] as String,
      totalPrice: map["totalPrice"] as double,
    );
  }

  @override
  String toString() => "Заказ #$id - $customerName: ${quantity} шт. - ${totalPrice}₽";
}