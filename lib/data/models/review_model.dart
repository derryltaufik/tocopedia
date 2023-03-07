import 'dart:convert';

import 'package:tocopedia/data/models/order_item_detail_model.dart';
import 'package:tocopedia/data/models/product_model.dart';
import 'package:tocopedia/data/models/user_model.dart';
import 'package:tocopedia/domains/entities/review.dart';

class ReviewModel {
  ReviewModel({
    this.id,
    this.orderItemDetail,
    this.seller,
    this.buyer,
    this.product,
    this.images,
    this.anonymous,
    this.completed,
    this.totalUpdate,
    this.createdAt,
    this.updatedAt,
    this.productName,
    this.productImage,
    this.review,
    this.v,
    this.rating,
  });

  final String? id;
  final OrderItemDetailModel? orderItemDetail;
  final UserModel? seller;
  final UserModel? buyer;
  final ProductModel? product;
  final List<String>? images;
  final bool? anonymous;
  final bool? completed;
  final int? totalUpdate;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? productName;
  final String? productImage;
  final String? review;
  final int? v;
  final int? rating;

  Review toEntity() {
    return Review(
      id: id,
      product: product?.toEntity(),
      anonymous: anonymous,
      buyer: buyer?.toEntity(),
      completed: completed,
      orderItemDetail: orderItemDetail?.toEntity(),
      productImage: productImage,
      productName: productName,
      rating: rating,
      seller: seller?.toEntity(),
      totalUpdate: totalUpdate,
      review: review,
      images: images,
      createdAt: createdAt,
      updatedAt: updatedAt,
      v: v,
    );
  }

  ReviewModel copyWith({
    String? id,
    OrderItemDetailModel? orderItemDetail,
    UserModel? seller,
    UserModel? buyer,
    ProductModel? product,
    List<String>? images,
    bool? anonymous,
    bool? completed,
    int? totalUpdate,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? productName,
    String? productImage,
    String? review,
    int? v,
    int? rating,
  }) =>
      ReviewModel(
        id: id ?? this.id,
        orderItemDetail: orderItemDetail ?? this.orderItemDetail,
        seller: seller ?? this.seller,
        buyer: buyer ?? this.buyer,
        product: product ?? this.product,
        images: images ?? this.images,
        review: review ?? this.review,
        anonymous: anonymous ?? this.anonymous,
        completed: completed ?? this.completed,
        totalUpdate: totalUpdate ?? this.totalUpdate,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        productName: productName ?? this.productName,
        productImage: productImage ?? this.productImage,
        v: v ?? this.v,
        rating: rating ?? this.rating,
      );

  factory ReviewModel.fromJson(String str) =>
      ReviewModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ReviewModel.fromMap(Map<String, dynamic> json) => ReviewModel(
        id: json["_id"],
        orderItemDetail: json["order_item_detail"] == null
            ? null
            : OrderItemDetailModel.fromMap(json["order_item_detail"]),
        seller:
            json["seller"] == null ? null : UserModel.fromMap(json["seller"]),
        buyer: json["buyer"] == null ? null : UserModel.fromMap(json["buyer"]),
        product: json["product"] == null
            ? null
            : ProductModel.fromMap(json["product"]),
        images: json["images"] == null
            ? null
            : List<String>.from(json["images"]!.map((x) => x)),
        anonymous: json["anonymous"],
        completed: json["completed"],
        totalUpdate: json["total_update"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        review: json["review"],
        productName: json["product_name"],
        productImage: json["product_image"],
        v: json["__v"],
        rating: json["rating"],
      );

  Map<String, dynamic> toMap() => {
        "_id": id,
        "order_item_detail": orderItemDetail?.toMap(),
        "seller": seller?.toMap(),
        "buyer": buyer?.toMap(),
        "product": product?.toMap(),
        "images":
            images == null ? [] : List<dynamic>.from(images!.map((x) => x)),
        "anonymous": anonymous,
        "completed": completed,
        "total_update": totalUpdate,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "review": review,
        "product_name": productName,
        "product_image": productImage,
        "__v": v,
        "rating": rating,
      };

  @override
  String toString() {
    return 'Review{id: $id, orderItemDetail: $orderItemDetail, seller: $seller, buyer: $buyer, product: $product, images: $images, anonymous: $anonymous, completed: $completed, totalUpdate: $totalUpdate, createdAt: $createdAt, updatedAt: $updatedAt, productName: $productName, productImage: $productImage, v: $v, rating: $rating, review: $review}';
  }
}
