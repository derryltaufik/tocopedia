import 'package:tocopedia/domains/entities/order.dart';
import 'package:tocopedia/domains/repositories/order_repository.dart';

class PayOrder {
  final OrderRepository repository;

  PayOrder(this.repository);

  Future<Order> execute(String token, String orderId) {
    return repository.payOrder(token, orderId);
  }
}
