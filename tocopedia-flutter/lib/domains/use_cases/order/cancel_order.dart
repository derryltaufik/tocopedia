import 'package:tocopedia/domains/entities/order.dart';
import 'package:tocopedia/domains/repositories/order_repository.dart';

class CancelOrder {
  final OrderRepository repository;

  CancelOrder(this.repository);

  Future<Order> execute(String token, String orderId) {
    return repository.cancelOrder(token, orderId);
  }
}
