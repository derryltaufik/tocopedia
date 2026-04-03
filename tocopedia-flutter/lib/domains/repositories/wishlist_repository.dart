import 'package:tocopedia/domains/entities/wishlist.dart';

abstract class WishlistRepository {
  Future<Wishlist> getWishlist(String token);

  Future<Wishlist> addWishlist(String token, String productId);

  Future<Wishlist> deleteWishlist(String token, String productId);
}
