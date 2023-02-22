import 'package:tocopedia/domains/entities/order_item.dart';
import 'package:tocopedia/domains/repositories/order_item_repository.dart';

class CancelOrderItem {
  final OrderItemRepository repository;

  CancelOrderItem(this.repository);

  Future<OrderItem> execute(String token, String orderItemId) {
    return repository.cancelOrderItem(token, orderItemId);
  }
}
