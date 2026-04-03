import 'package:tocopedia/domains/entities/cart_item.dart';

class Cart {
  Cart({
    required this.id,
    required this.cartItems,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  final String id;
  final List<CartItem> cartItems;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  Cart copyWith({
    String? id,
    List<CartItem>? cartItems,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
  }) {
    return Cart(
      id: id ?? this.id,
      cartItems: cartItems ?? this.cartItems,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      v: v ?? this.v,
    );
  }
}
