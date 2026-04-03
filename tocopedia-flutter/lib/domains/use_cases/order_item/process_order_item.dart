import 'package:tocopedia/domains/entities/order_item.dart';
import 'package:tocopedia/domains/repositories/order_item_repository.dart';

class ProcessOrderItem {
  final OrderItemRepository repository;

  ProcessOrderItem(this.repository);

  Future<OrderItem> execute(String token, String orderItemId) {
    return repository.processOrderItem(token, orderItemId);
  }
}
