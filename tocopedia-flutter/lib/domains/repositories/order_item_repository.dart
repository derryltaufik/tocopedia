import 'package:tocopedia/domains/entities/order_item.dart';

abstract class OrderItemRepository {
  Future<List<OrderItem>> getBuyerOrderItems(String token);

  Future<List<OrderItem>> getSellerOrderItems(String token);

  Future<OrderItem> getOrderItem(String token, String orderItemId);

  Future<OrderItem> cancelOrderItem(String token, String orderItemId);

  Future<OrderItem> processOrderItem(String token, String orderItemId);

  Future<OrderItem> sendOrderItem(String token, String orderItemId,
      {required String airwaybill});

  Future<OrderItem> completeOrderItem(String token, String orderItemId);
}
