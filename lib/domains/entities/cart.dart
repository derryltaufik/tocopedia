import 'package:tocopedia/domains/entities/cart_item.dart';

class Cart {
  Cart({
    required this.id,
    required this.ownerId,
    required this.cartItems,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  final String id;
  final String ownerId;
  final List<CartItem> cartItems;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;
}
