import 'dart:convert';

import 'package:tocopedia/data/models/order_item_detail_model.dart';
import 'package:tocopedia/data/models/order_model.dart';
import 'package:tocopedia/data/models/user_model.dart';
import 'package:tocopedia/domains/entities/order_item.dart';
import 'package:tocopedia/domains/entities/order_item_detail.dart';

class OrderItemModel {
  OrderItemModel({
    this.id,
    this.order,
    this.buyer,
    this.seller,
    this.orderItemDetails,
    this.subtotal,
    this.quantityTotal,
    this.airwaybill,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  final String? id;
  final OrderModel? order;
  final UserModel? buyer;
  final UserModel? seller;
  final List<OrderItemDetailModel>? orderItemDetails;
  final int? subtotal;
  final int? quantityTotal;
  final String? airwaybill;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  @override
  String toString() {
    return 'OrderItemModel{ id: $id, order: $order, buyer: $buyer, seller: $seller, orderItemDetails: $orderItemDetails, subtotal: $subtotal, quantityTotal: $quantityTotal, airwaybill: $airwaybill, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, v: $v,}';
  }

  OrderItem toEntity() {
    return OrderItem(
      id: id,
      order: order?.toEntity(),
      buyer: buyer?.toEntity(),
      seller: seller?.toEntity(),
      orderItemDetails: orderItemDetails == null
          ? null
          : List<OrderItemDetail>.from(
              orderItemDetails!.map((x) => x.toEntity())),
      status: status,
      airwaybill: airwaybill,
      quantityTotal: quantityTotal,
      subtotal: subtotal,
      createdAt: createdAt,
      updatedAt: updatedAt,
      v: v,
    );
  }

  OrderItemModel copyWith({
    String? id,
    OrderModel? order,
    UserModel? buyer,
    UserModel? seller,
    List<OrderItemDetailModel>? orderItemDetails,
    int? subtotal,
    int? quantityTotal,
    String? airwaybill,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
  }) =>
      OrderItemModel(
        id: id ?? this.id,
        order: order ?? this.order,
        buyer: buyer ?? this.buyer,
        seller: seller ?? this.seller,
        orderItemDetails: orderItemDetails ?? this.orderItemDetails,
        subtotal: subtotal ?? this.subtotal,
        quantityTotal: quantityTotal ?? this.quantityTotal,
        airwaybill: airwaybill ?? this.airwaybill,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        v: v ?? this.v,
      );

  factory OrderItemModel.fromJson(String str) =>
      OrderItemModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory OrderItemModel.fromMap(Map<String, dynamic> json) => OrderItemModel(
        id: json["_id"],
        order: json["order"] == null ? null : OrderModel.fromMap(json["order"]),
        buyer: json["buyer"] == null ? null : UserModel.fromMap(json["buyer"]),
        seller:
            json["seller"] == null ? null : UserModel.fromMap(json["seller"]),
        orderItemDetails: json["order_item_details"] == null
            ? []
            : List<OrderItemDetailModel>.from(json["order_item_details"]!
                .map((x) => OrderItemDetailModel.fromMap(x))),
        subtotal: json["subtotal"],
        quantityTotal: json["quantity_total"],
        airwaybill: json["airwaybill"],
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
        "_id": id,
        "order": order?.toMap(),
        "buyer": buyer?.toMap(),
        "seller": seller?.toMap(),
        "order_item_details": orderItemDetails == null
            ? []
            : List<dynamic>.from(orderItemDetails!.map((x) => x.toMap())),
        "subtotal": subtotal,
        "quantity_total": quantityTotal,
        "airwaybill": airwaybill,
        "status": status,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
      };
}
