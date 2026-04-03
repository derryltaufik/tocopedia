import 'package:tocopedia/domains/entities/product.dart';

class OrderItemDetail {
  OrderItemDetail({
    required this.product,
    required this.productName,
    required this.productPrice,
    required this.productImage,
    required this.quantity,
    required this.id,
  });

  final Product? product;
  final String? productName;
  final int? productPrice;
  final String? productImage;
  final int? quantity;
  final String? id;
}
