import 'package:tocopedia/domains/entities/cart.dart';

abstract class CartRepository {
  Future<Cart> getCart(String token);

  Future<Cart> addToCart(String token, String productId);

  Future<Cart> removeFromCart(String token, String productId);

  Future<Cart> selectCartItem(String token, String productId);

  Future<Cart> unselectCartItem(String token, String productId);

  Future<Cart> selectSeller(String token, String sellerId);

  Future<Cart> unselectSeller(String token, String sellerId);

  Future<Cart> updateCart(String token, String productId, int quantity);

  Future<Cart> clearCart(String token);
}
