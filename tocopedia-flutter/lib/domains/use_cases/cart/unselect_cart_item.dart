import 'package:tocopedia/domains/entities/cart.dart';
import 'package:tocopedia/domains/repositories/cart_repository.dart';

class UnselectCartItem {
  final CartRepository repository;

  UnselectCartItem(this.repository);

  Future<Cart> execute(String token, String productId) {
    return repository.unselectCartItem(token, productId);
  }
}
