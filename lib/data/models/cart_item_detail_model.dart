import 'dart:convert';

import 'package:tocopedia/data/models/product_model.dart';
import 'package:tocopedia/domains/entities/cart_item_detail.dart';

class CartItemDetailModel {
  final ProductModel product;
  final int quantity;
  final String id;
  final bool selected;

  CartItemDetail toEntity() {
    return CartItemDetail(
      id: id,
      product: product.toEntity(),
      quantity: quantity,
      selected: selected,
    );
  }

  String toJson() => json.encode(toMap());

  factory CartItemDetailModel.fromJson(String source) =>
      CartItemDetailModel.fromMap(json.decode(source));

//<editor-fold desc="Data Methods">
  const CartItemDetailModel({
    required this.product,
    required this.quantity,
    required this.id,
    required this.selected,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CartItemDetailModel &&
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
    return 'CartItemDetailModel{ product: $product, quantity: $quantity, id: $id, selected: $selected,}';
  }

  CartItemDetailModel copyWith({
    ProductModel? product,
    int? quantity,
    String? id,
    bool? selected,
  }) {
    return CartItemDetailModel(
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

  factory CartItemDetailModel.fromMap(Map<String, dynamic> map) {
    return CartItemDetailModel(
      product: ProductModel.fromMap(map['product']),
      quantity: map['quantity'] as int,
      selected: map['selected'] as bool,
      id: map['_id'] as String,
    );
  }

//</editor-fold>
}
