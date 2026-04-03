import 'dart:convert';

import 'package:tocopedia/data/models/cart_item_detail_model.dart';
import 'package:tocopedia/data/models/user_model.dart';
import 'package:tocopedia/domains/entities/cart_item.dart';
import 'package:tocopedia/domains/entities/cart_item_detail.dart';

class CartItemModel {
  CartItemModel({
    this.seller,
    this.id,
    this.cartItemDetails,
  });

  final UserModel? seller;
  final String? id;
  final List<CartItemDetailModel>? cartItemDetails;

  CartItem toEntity() {
    return CartItem(
        id: id,
        seller: seller?.toEntity(),
        cartItemDetails: cartItemDetails == null
            ? null
            : List<CartItemDetail>.from(
                cartItemDetails!.map((e) => e.toEntity())));
  }

  CartItemModel copyWith({
    UserModel? seller,
    String? id,
    List<CartItemDetailModel>? cartItemDetails,
  }) =>
      CartItemModel(
        seller: seller ?? this.seller,
        id: id ?? this.id,
        cartItemDetails: cartItemDetails ?? this.cartItemDetails,
      );

  factory CartItemModel.fromJson(String str) =>
      CartItemModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CartItemModel.fromMap(Map<String, dynamic> json) => CartItemModel(
        seller:
            json["seller"] == null ? null : UserModel.fromMap(json["seller"]),
        id: json["_id"],
        cartItemDetails: json["cart_item_details"] == null
            ? []
            : List<CartItemDetailModel>.from(json["cart_item_details"]!
                .map((x) => CartItemDetailModel.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "seller": seller,
        "_id": id,
        "cart_item_details": cartItemDetails == null
            ? []
            : List<dynamic>.from(cartItemDetails!.map((x) => x.toMap())),
      };
}
