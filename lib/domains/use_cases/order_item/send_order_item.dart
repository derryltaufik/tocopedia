import 'package:tocopedia/domains/entities/order_item.dart';
import 'package:tocopedia/domains/repositories/order_item_repository.dart';

class SendOrderItem {
  final OrderItemRepository repository;

  SendOrderItem(this.repository);

  Future<OrderItem> execute(String token, String orderItemId,
      {required String airwaybill}) {
    return repository.sendOrderItem(token, orderItemId,
        airwaybill: airwaybill);
  }
}
