import 'package:tocopedia/domains/entities/order_item.dart';
import 'package:tocopedia/domains/repositories/order_item_repository.dart';

class GetSellerOrderItems {
  final OrderItemRepository repository;

  GetSellerOrderItems(this.repository);

  Future<List<OrderItem>> execute(String token) {
    return repository.getSellerOrderItems(token);
  }
}
