import 'package:tocopedia/domains/entities/address.dart';

class Order {
  Order({
    required this.id,
    required this.ownerId,
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

  final String id;
  final String ownerId;
  final List<String> orderItems;
  final String coverImage;
  final int totalPrice;
  final int totalQuantity;
  final Address address;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;
}
