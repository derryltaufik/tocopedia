import 'dart:convert';

import 'package:tocopedia/domains/entities/cart_item.dart';

class CartItemModel {
  final String productId;
  final int quantity;
  final String id;

  CartItem toEntity() {
    return CartItem(
      id: id,
      productId: productId,
      quantity: quantity,
    );
  }

  String toJson() => json.encode(toMap());

  factory CartItemModel.fromJson(String source) =>
      CartItemModel.fromMap(json.decode(source));

//<editor-fold desc="Data Methods">
  const CartItemModel({
    required this.productId,
    required this.quantity,
    required this.id,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CartItemModel &&
          runtimeType == other.runtimeType &&
          productId == other.productId &&
          quantity == other.quantity &&
          id == other.id);

  @override
  int get hashCode => productId.hashCode ^ quantity.hashCode ^ id.hashCode;

  @override
  String toString() {
    return 'CartItemModel{ productId: $productId, quantity: $quantity, id: $id,}';
  }

  CartItemModel copyWith({
    String? productId,
    int? quantity,
    String? id,
  }) {
    return CartItemModel(
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'product_id': productId,
      'quantity': quantity,
      '_id': id,
    };
  }

  factory CartItemModel.fromMap(Map<String, dynamic> map) {
    return CartItemModel(
      productId: map['product_id'] as String,
      quantity: map['quantity'] as int,
      id: map['_id'] as String,
    );
  }

//</editor-fold>
}
