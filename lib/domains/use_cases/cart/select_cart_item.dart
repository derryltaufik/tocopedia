import 'package:tocopedia/domains/entities/cart.dart';
import 'package:tocopedia/domains/repositories/cart_repository.dart';

class SelectCartItem {
  final CartRepository repository;

  SelectCartItem(this.repository);

  Future<Cart> execute(String token, String productId) {
    return repository.selectCartItem(token, productId);
  }
}
