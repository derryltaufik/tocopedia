import 'package:tocopedia/domains/entities/cart.dart';
import 'package:tocopedia/domains/repositories/cart_repository.dart';

class SelectSeller {
  final CartRepository repository;

  SelectSeller(this.repository);

  Future<Cart> execute(String token, String sellerId) {
    return repository.selectSeller(token, sellerId);
  }
}
