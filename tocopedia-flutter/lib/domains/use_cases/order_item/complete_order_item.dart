import 'package:tocopedia/domains/entities/order_item.dart';
import 'package:tocopedia/domains/repositories/order_item_repository.dart';

class CompleteOrderItem {
  final OrderItemRepository repository;

  CompleteOrderItem(this.repository);

  Future<OrderItem> execute(String token, String orderItemId) {
    return repository.completeOrderItem(token, orderItemId);
  }
}
