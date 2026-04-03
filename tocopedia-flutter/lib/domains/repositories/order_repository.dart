import 'package:tocopedia/domains/entities/order.dart';

abstract class OrderRepository {
  Future<Order> checkout(String token, String addressId);

  Future<Order> getOrder(String token, String orderId);

  Future<List<Order>> getUserOrders(String token);

  Future<Order> payOrder(String token, String orderId);

  Future<Order> cancelOrder(String token, String orderId);
}
