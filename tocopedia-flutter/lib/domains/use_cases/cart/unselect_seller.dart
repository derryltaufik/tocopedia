import 'package:tocopedia/domains/entities/cart.dart';
import 'package:tocopedia/domains/repositories/cart_repository.dart';

class UnselectSeller {
  final CartRepository repository;

  UnselectSeller(this.repository);

  Future<Cart> execute(String token, String sellerId) {
    return repository.unselectSeller(token, sellerId);
  }
}
