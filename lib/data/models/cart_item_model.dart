import 'dart:convert';

import 'package:tocopedia/data/models/product_model.dart';
import 'package:tocopedia/domains/entities/cart_item.dart';

class CartItemModel {
  final ProductModel product;
  final int quantity;
  final String id;
  final bool selected;

  CartItem toEntity() {
    return CartItem(
      id: id,
      product: product.toEntity(),
      quantity: quantity,
      selected: selected,
    );
  }

  String toJson() => json.encode(toMap());

  factory CartItemModel.fromJson(String source) =>
      CartItemModel.fromMap(json.decode(source));

//<editor-fold desc="Data Methods">
  const CartItemModel({
    required this.product,
    required this.quantity,
    required this.id,
    required this.selected,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CartItemModel &&
          runtimeType == other.runtimeType &&
          product == other.product &&
          quantity == other.quantity &&
          id == other.id &&
          selected == other.selected);

  @override
  int get hashCode =>
      product.hashCode ^ quantity.hashCode ^ id.hashCode ^ selected.hashCode;

  @override
  String toString() {
    return 'CartItemModel{ product: $product, quantity: $quantity, id: $id, selected: $selected,}';
  }

  CartItemModel copyWith({
    ProductModel? product,
    int? quantity,
    String? id,
    bool? selected,
  }) {
    return CartItemModel(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      id: id ?? this.id,
      selected: selected ?? this.selected,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'product': product,
      'quantity': quantity,
      'selected': selected,
      '_id': id,
    };
  }

  factory CartItemModel.fromMap(Map<String, dynamic> map) {
    return CartItemModel(
      product: ProductModel.fromMap(map['product']),
      quantity: map['quantity'] as int,
      selected: map['selected'] as bool,
      id: map['_id'] as String,
    );
  }

//</editor-fold>
}
