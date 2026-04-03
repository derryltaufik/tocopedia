import 'dart:convert';

import 'package:tocopedia/data/models/product_model.dart';
import 'package:tocopedia/domains/entities/order_item_detail.dart';

class OrderItemDetailModel {
  OrderItemDetailModel({
    this.product,
    this.productName,
    this.productPrice,
    this.productImage,
    this.quantity,
    this.id,
  });

  final ProductModel? product;
  final String? productName;
  final int? productPrice;
  final String? productImage;
  final int? quantity;
  final String? id;

  OrderItemDetail toEntity() {
    return OrderItemDetail(
      id: id,
      quantity: quantity,
      product: product?.toEntity(),
      productImage: productImage,
      productName: productName,
      productPrice: productPrice,
    );
  }

  @override
  String toString() {
    return 'OrderItemDetailModel{ product: $product, productName: $productName, productPrice: $productPrice, productImage: $productImage, quantity: $quantity, id: $id,}';
  }

  OrderItemDetailModel copyWith({
    ProductModel? product,
    String? productName,
    int? productPrice,
    String? productImage,
    int? quantity,
    String? id,
  }) =>
      OrderItemDetailModel(
        product: product ?? this.product,
        productName: productName ?? this.productName,
        productPrice: productPrice ?? this.productPrice,
        productImage: productImage ?? this.productImage,
        quantity: quantity ?? this.quantity,
        id: id ?? this.id,
      );

  factory OrderItemDetailModel.fromJson(String str) =>
      OrderItemDetailModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory OrderItemDetailModel.fromMap(Map<String, dynamic> json) =>
      OrderItemDetailModel(
        product: json["product"] == null
            ? null
            : ProductModel.fromMap(json["product"]),
        productName: json["product_name"],
        productPrice: json["product_price"],
        productImage: json["product_image"],
        quantity: json["quantity"],
        id: json["_id"],
      );

  Map<String, dynamic> toMap() => {
        "product": product?.toMap(),
        "product_name": productName,
        "product_price": productPrice,
        "product_image": productImage,
        "quantity": quantity,
        "_id": id,
      };
}
