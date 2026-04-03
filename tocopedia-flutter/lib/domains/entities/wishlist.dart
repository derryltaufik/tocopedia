import 'package:tocopedia/domains/entities/product.dart';
import 'package:tocopedia/domains/entities/user.dart';

class Wishlist {
  Wishlist({
    required this.id,
    required this.owner,
    required this.wishlistProducts,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  final String? id;
  final User? owner;
  final List<Product>? wishlistProducts;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;
}