import 'dart:convert';

import 'package:amazon_clone_tutorial/models/product.dart';

class Order {
  final String id;
  final List<Product> products;
  final List<int> quantity;
  final String address;
  final String userId;
  final int orderedAt;
  final int status;
  final double orderTotal;

  Order({
    required this.id,
    required this.products,
    required this.quantity,
    required this.address,
    required this.userId,
    required this.orderedAt,
    required this.status,
    required this.orderTotal,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'products': products.map((product) => product.toMap()).toList(),
      'quantity': quantity,
      'address': address,
      'userId': userId,
      'orderedAt': orderedAt,
      'status': status,
      'orderTotal': orderTotal,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['_id'] ?? '',
      products: List<Product>.from(map['products']
          ?.map((productTuple) => Product.fromMap(productTuple['product']))),
      quantity: List<int>.from(
          map['products']?.map((productTuple) => productTuple['quantity'])),
      address: map['address'] ?? '',
      userId: map['userId'] ?? '',
      orderedAt: map['orderedAt']?.toInt() ?? 0,
      status: map['status']?.toInt() ?? 0,
      orderTotal: map['orderTotal'].toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Order.fromJson(String source) => Order.fromMap(json.decode(source));
}
