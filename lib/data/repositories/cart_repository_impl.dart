import 'package:tocopedia/data/data_sources/cart_remote_data_source.dart';
import 'package:tocopedia/domains/entities/cart.dart';
import 'package:tocopedia/domains/repositories/cart_repository.dart';

class CartRepositoryImpl implements CartRepository {
  final CartRemoteDataSource remoteDataSource;

  CartRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Cart> getCart(String token) async {
    try {
      final result = await remoteDataSource.getCart(token);
      return result.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Cart> addToCart(String token, String productId) async {
    try {
      final result = await remoteDataSource.addToCart(token, productId);
      return result.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Cart> removeFromCart(String token, String productId) async {
    try {
      final result = await remoteDataSource.removeFromCart(token, productId);
      return result.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Cart> selectCartItem(String token, String productId) async {
    try {
      final result = await remoteDataSource.selectCartItem(token, productId);
      return result.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Cart> unselectCartItem(String token, String productId) async {
    try {
      final result = await remoteDataSource.unSelectCartItem(token, productId);
      return result.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Cart> selectSeller(String token, String sellerId) async {
    try {
      final result = await remoteDataSource.selectSeller(token, sellerId);
      return result.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Cart> unselectSeller(String token, String sellerId) async {
    try {
      final result = await remoteDataSource.unselectSeller(token, sellerId);
      return result.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Cart> updateCart(String token, String productId, int quantity) async {
    try {
      final result =
          await remoteDataSource.updateCart(token, productId, quantity);
      return result.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Cart> clearCart(String token) async {
    try {
      final result = await remoteDataSource.clearCart(token);
      return result.toEntity();
    } catch (e) {
      rethrow;
    }
  }
}
