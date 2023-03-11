import 'package:tocopedia/domains/entities/order.dart';
import 'package:tocopedia/domains/entities/order_item_detail.dart';
import 'package:tocopedia/domains/entities/user.dart';

class OrderItem {
  OrderItem({
    required this.id,
    required this.order,
    required this.buyer,
    required this.seller,
    required this.orderItemDetails,
    required this.subtotal,
    required this.quantityTotal,
    required this.airwaybill,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  final String? id;
  final Order? order;
  final User? buyer;
  final User? seller;
  final List<OrderItemDetail>? orderItemDetails;
  final int? subtotal;
  final int? quantityTotal;
  final String? airwaybill;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;
}
