class OrderItem {
  OrderItem({
    required this.id,
    required this.orderId,
    required this.buyerId,
    required this.sellerId,
    required this.products,
    required this.subtotal,
    required this.quantityTotal,
    required this.airwaybill,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  final String id;
  final String orderId;
  final String buyerId;
  final String sellerId;
  final List<OrderItemProduct> products;
  final int subtotal;
  final int quantityTotal;
  final String airwaybill;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;
}

class OrderItemProduct {
  OrderItemProduct({
    required this.productId,
    required this.productName,
    required this.productPrice,
    required this.productImage,
    required this.quantity,
    required this.id,
  });

  final String productId;
  final String productName;
  final int productPrice;
  final String productImage;
  final int quantity;
  final String id;
}
