class CartItem {
  CartItem({
    required this.productId,
    required this.quantity,
    required this.id,
    required this.selected,
  });

  final String productId;
  final int quantity;
  final String id;
  final bool selected;
}
