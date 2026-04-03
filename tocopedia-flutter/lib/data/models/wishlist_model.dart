import 'dart:convert';

import 'package:tocopedia/data/models/product_model.dart';
import 'package:tocopedia/data/models/user_model.dart';
import 'package:tocopedia/domains/entities/product.dart';
import 'package:tocopedia/domains/entities/wishlist.dart';

class WishlistModel {
  WishlistModel({
    required this.id,
    required this.owner,
    required this.wishlistProducts,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  final String? id;
  final UserModel? owner;
  final List<ProductModel>? wishlistProducts;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  Wishlist toEntity() {
    return Wishlist(
      id: id,
      owner: owner?.toEntity(),
      wishlistProducts: wishlistProducts == null
          ? null
          : List<Product>.from(wishlistProducts!.map((x) => x.toEntity())),
      createdAt: createdAt,
      updatedAt: updatedAt,
      v: v,
    );
  }

  WishlistModel copyWith({
    String? id,
    UserModel? owner,
    List<ProductModel>? wishlistProducts,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
  }) =>
      WishlistModel(
        id: id ?? this.id,
        owner: owner ?? this.owner,
        wishlistProducts: wishlistProducts ?? this.wishlistProducts,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        v: v ?? this.v,
      );

  factory WishlistModel.fromJson(String str) =>
      WishlistModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory WishlistModel.fromMap(Map<String, dynamic> json) => WishlistModel(
        id: json["_id"],
        owner: json["owner"] == null ? null : UserModel.fromMap(json["owner"]),
        wishlistProducts: json["wishlist_products"] == null
            ? []
            : List<ProductModel>.from(
                json["wishlist_products"]!.map((x) => ProductModel.fromMap(x))),
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toMap() => {
        "_id": id,
        "owner": owner?.toMap(),
        "wishlist_products": wishlistProducts == null
            ? []
            : List<dynamic>.from(wishlistProducts!.map((x) => x.toMap())),
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WishlistModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          owner == other.owner &&
          wishlistProducts == other.wishlistProducts &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt &&
          v == other.v);

  @override
  int get hashCode =>
      id.hashCode ^
      owner.hashCode ^
      wishlistProducts.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      v.hashCode;

  @override
  String toString() {
    return 'WishlistModel{ id: $id, owner: $owner, wishlistProducts: $wishlistProducts, createdAt: $createdAt, updatedAt: $updatedAt, v: $v,}';
  }
}
