import 'package:tocopedia/domains/entities/order.dart';
import 'package:tocopedia/domains/repositories/order_repository.dart';

class GetOrder {
  final OrderRepository repository;

  GetOrder(this.repository);

  Future<Order> execute(String token, String orderId) {
    return repository.getOrder(token, orderId);
  }
}
