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

class CartItem {
  CartItem({
    required this.productId,
    required this.quantity,
    required this.id,
  });

  final String productId;
  final int quantity;
  final String id;
}
