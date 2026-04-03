import 'package:tocopedia/data/data_sources/wishlist_remote_data_source.dart';
import 'package:tocopedia/domains/entities/wishlist.dart';
import 'package:tocopedia/domains/repositories/wishlist_repository.dart';

class WishlistRepositoryImpl implements WishlistRepository {
  final WishlistRemoteDataSource remoteDataSource;

  WishlistRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Wishlist> addWishlist(String token, String productId) async {
    try {
      final result = await remoteDataSource.addWishlist(token, productId);
      return result.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Wishlist> deleteWishlist(String token, String productId) async {
    try {
      final result = await remoteDataSource.deleteWishlist(token, productId);
      return result.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Wishlist> getWishlist(String token) async {
    try {
      final result = await remoteDataSource.getWishlist(token);
      return result.toEntity();
    } catch (e) {
      rethrow;
    }
  }
}
