import 'package:tocopedia/data/data_sources/order_item_remote_data_source.dart';
import 'package:tocopedia/domains/entities/order_item.dart';
import 'package:tocopedia/domains/repositories/order_item_repository.dart';

class OrderItemRepositoryImpl implements OrderItemRepository {
  final OrderItemRemoteDataSource remoteDataSource;

  OrderItemRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<OrderItem>> getBuyerOrderItems(String token) async {
    try {
      final result = await remoteDataSource.getBuyerOrderItems(token);
      return List<OrderItem>.from(result.map((e) => e.toEntity()));
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<OrderItem>> getSellerOrderItems(String token) async {
    try {
      final result = await remoteDataSource.getSellerOrderItems(token);
      return List<OrderItem>.from(result.map((e) => e.toEntity()));
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<OrderItem> getOrderItem(String token, String orderItemId) async {
    try {
      final result = await remoteDataSource.getOrderItem(token, orderItemId);
      return result.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<OrderItem> cancelOrderItem(String token, String orderItemId) async {
    try {
      final result = await remoteDataSource.cancelOrderItem(token, orderItemId);
      return result.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<OrderItem> processOrderItem(String token, String orderItemId) async {
    try {
      final result =
          await remoteDataSource.processOrderItem(token, orderItemId);
      return result.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<OrderItem> sendOrderItem(String token, String orderItemId,
      {required String airwaybill}) async {
    try {
      final result = await remoteDataSource.sendOrderItem(token, orderItemId,
          airwaybill: airwaybill);
      return result.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<OrderItem> completeOrderItem(String token, String orderItemId) async {
    try {
      final result =
          await remoteDataSource.completeOrderItem(token, orderItemId);
      return result.toEntity();
    } catch (e) {
      rethrow;
    }
  }
}
