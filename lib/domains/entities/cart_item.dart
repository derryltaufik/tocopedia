import 'package:tocopedia/domains/entities/product.dart';

class CartItem {
  CartItem({
    required this.product,
    required this.quantity,
    required this.id,
    required this.selected,
  });

  final Product product;
  final int quantity;
  final String id;
  final bool selected;
}
