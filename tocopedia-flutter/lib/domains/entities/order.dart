import 'package:tocopedia/domains/entities/address.dart';
import 'package:tocopedia/domains/entities/order_item.dart';
import 'package:tocopedia/domains/entities/user.dart';

class Order {
  Order({
    required this.id,
    required this.owner,
    required this.orderItems,
    required this.coverImage,
    required this.totalPrice,
    required this.totalQuantity,
    required this.address,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  final String? id;
  final User? owner;
  final List<OrderItem>? orderItems;
  final String? coverImage;
  final int? totalPrice;
  final int? totalQuantity;
  final Address? address;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;
}
