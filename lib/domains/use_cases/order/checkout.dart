import 'package:tocopedia/domains/entities/order.dart';
import 'package:tocopedia/domains/repositories/order_repository.dart';

class Checkout {
  final OrderRepository repository;

  Checkout(this.repository);

  Future<Order> execute(String token, String addressId) {
    return repository.checkout(token, addressId);
  }
}
