import 'package:tocopedia/domains/entities/order_item.dart';
import 'package:tocopedia/domains/repositories/order_item_repository.dart';

class GetBuyerOrderItems {
  final OrderItemRepository repository;

  GetBuyerOrderItems(this.repository);

  Future<List<OrderItem>> execute(String token) {
    return repository.getBuyerOrderItems(token);
  }
}
