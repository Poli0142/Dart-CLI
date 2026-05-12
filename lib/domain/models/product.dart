import 'identity.dart';

class Product implements Identity {
  @override
  final String id;
  final String name;
  final double price;
  final int quantity;
  final String categoryId;
  final String description;
  final String size;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    required this.categoryId,
    required this.description,
    required this.size,
  });

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "price": price,
    "quantity": quantity,
    "categoryId": categoryId,
    "description": description,
    "size": size,
  };

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map["id"] as String,
      name: map["name"] as String,
      price: map["price"] as double,
      quantity: map["quantity"] as int,
      categoryId: map["categoryId"] as String,
      description: map["description"] as String,
      size: map["size"] as String,
    );
  }

  @override
  String toString() => "$name - ${price}₽ (${quantity} шт.)";
}