import 'dart:convert';

import 'package:tocopedia/data/models/address_model.dart';
import 'package:tocopedia/data/models/order_item_model.dart';
import 'package:tocopedia/data/models/user_model.dart';
import 'package:tocopedia/domains/entities/order.dart';
import 'package:tocopedia/domains/entities/order_item.dart';

class OrderModel {
  OrderModel({
    this.address,
    this.id,
    this.owner,
    this.orderItems,
    this.coverImage,
    this.totalPrice,
    this.totalQuantity,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  final AddressModel? address;
  final String? id;
  final UserModel? owner;
  final List<OrderItemModel>? orderItems;
  final String? coverImage;
  final int? totalPrice;
  final int? totalQuantity;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  Order toEntity() {
    return Order(
      id: id,
      owner: owner?.toEntity(),
      address: address?.toEntity(),
      coverImage: coverImage,
      orderItems: orderItems == null
          ? null
          : List<OrderItem>.from(orderItems!.map((x) => x.toEntity())),
      totalPrice: totalPrice,
      totalQuantity: totalQuantity,
      status: status,
      createdAt: createdAt,
      updatedAt: updatedAt,
      v: v,
    );
  }

  OrderModel copyWith({
    AddressModel? address,
    String? id,
    UserModel? owner,
    List<OrderItemModel>? orderItems,
    String? coverImage,
    int? totalPrice,
    int? totalQuantity,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
  }) =>
      OrderModel(
        address: address ?? this.address,
        id: id ?? this.id,
        owner: owner ?? this.owner,
        orderItems: orderItems ?? this.orderItems,
        coverImage: coverImage ?? this.coverImage,
        totalPrice: totalPrice ?? this.totalPrice,
        totalQuantity: totalQuantity ?? this.totalQuantity,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        v: v ?? this.v,
      );

  factory OrderModel.fromJson(String str) =>
      OrderModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory OrderModel.fromMap(Map<String, dynamic> json) => OrderModel(
        address: json["address"] == null
            ? null
            : AddressModel.fromMap(json["address"]),
        id: json["_id"],
        owner: json["owner"] == null ? null : UserModel.fromMap(json["owner"]),
        orderItems: json["order_items"] == null
            ? []
            : List<OrderItemModel>.from(
                json["order_items"]!.map((x) => OrderItemModel.fromMap(x))),
        coverImage: json["cover_image"],
        totalPrice: json["total_price"],
        totalQuantity: json["total_quantity"],
        status: json["status"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toMap() => {
        "address": address?.toMap(),
        "_id": id,
        "owner": owner?.toMap(),
        "order_items": orderItems == null
            ? []
            : List<dynamic>.from(orderItems!.map((x) => x.toMap())),
        "cover_image": coverImage,
        "total_price": totalPrice,
        "total_quantity": totalQuantity,
        "status": status,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OrderModel &&
          runtimeType == other.runtimeType &&
          address == other.address &&
          id == other.id &&
          owner == other.owner &&
          orderItems == other.orderItems &&
          coverImage == other.coverImage &&
          totalPrice == other.totalPrice &&
          totalQuantity == other.totalQuantity &&
          status == other.status &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt &&
          v == other.v);

  @override
  int get hashCode =>
      address.hashCode ^
      id.hashCode ^
      owner.hashCode ^
      orderItems.hashCode ^
      coverImage.hashCode ^
      totalPrice.hashCode ^
      totalQuantity.hashCode ^
      status.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      v.hashCode;

  @override
  String toString() {
    return 'OrderModel{ address: $address, id: $id, owner: $owner, orderItems: $orderItems, coverImage: $coverImage, totalPrice: $totalPrice, totalQuantity: $totalQuantity, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, v: $v,}';
  }
}
