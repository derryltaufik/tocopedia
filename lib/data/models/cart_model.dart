import 'dart:convert';

import 'package:tocopedia/data/models/cart_item_model.dart';
import 'package:tocopedia/domains/entities/cart.dart';
import 'package:tocopedia/domains/entities/cart_item.dart';

class CartModel {
  final String id;
  final List<CartItemModel> cartItemsModel;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  Cart toEntity() {
    return Cart(
        id: id,
        cartItems: List<CartItem>.from(cartItemsModel.map((e) => e.toEntity())),
        v: v,
        createdAt: createdAt,
        updatedAt: updatedAt);
  }

  String toJson() => json.encode(toMap());

  factory CartModel.fromJson(String source) =>
      CartModel.fromMap(json.decode(source));

//<editor-fold desc="Data Methods">
  const CartModel({
    required this.id,
    required this.cartItemsModel,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CartModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          cartItemsModel == other.cartItemsModel &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt &&
          v == other.v);

  @override
  int get hashCode =>
      id.hashCode ^
      cartItemsModel.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      v.hashCode;

  @override
  String toString() {
    return 'CartModel{ id: $id,  cartItemsModel: $cartItemsModel, createdAt: $createdAt, updatedAt: $updatedAt, v: $v,}';
  }

  CartModel copyWith({
    String? id,
    List<CartItemModel>? cartItemsModel,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
  }) {
    return CartModel(
      id: id ?? this.id,
      cartItemsModel: cartItemsModel ?? this.cartItemsModel,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      v: v ?? this.v,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cartItemsModel': cartItemsModel,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'v': v,
    };
  }

  factory CartModel.fromMap(Map<String, dynamic> map) {
    return CartModel(
      id: map['_id'] as String,
      cartItemsModel: List<CartItemModel>.from(
          map['cart_items'].map((x) => CartItemModel.fromMap(x))),
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      v: map['__v'] as int,
    );
  }

//</editor-fold>
}
