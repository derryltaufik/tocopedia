import 'package:tocopedia/domains/entities/wishlist.dart';
import 'package:tocopedia/domains/repositories/wishlist_repository.dart';

class GetWishlist {
  final WishlistRepository repository;

  GetWishlist(this.repository);

  Future<Wishlist> execute(String token) {
    return repository.getWishlist(token);
  }
}
