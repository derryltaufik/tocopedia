import 'package:tocopedia/data/data_sources/order_remote_data_source.dart';
import 'package:tocopedia/domains/entities/order.dart';
import 'package:tocopedia/domains/repositories/order_repository.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource remoteDataSource;

  OrderRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Order> getOrder(String token, String orderId) async {
    try {
      final result = await remoteDataSource.getOrder(token, orderId);
      return result.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Order> cancelOrder(String token, String orderId) async {
    try {
      final result = await remoteDataSource.cancelOrder(token, orderId);
      return result.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Order> checkout(String token, String addressId) async {
    try {
      final result = await remoteDataSource.checkout(token, addressId);
      return result.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Order>> getUserOrders(String token) async {
    try {
      final result = await remoteDataSource.getUserOrders(token);
      return List<Order>.from(result.map((e) => e.toEntity()));
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Order> payOrder(String token, String orderId) async {
    try {
      final result = await remoteDataSource.payOrder(token, orderId);
      return result.toEntity();
    } catch (e) {
      rethrow;
    }
  }
}
