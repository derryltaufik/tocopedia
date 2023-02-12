import 'package:tocopedia/domains/entities/category.dart';

class Product {
  Product({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.images,
    required this.price,
    required this.stock,
    this.sku,
    required this.description,
    required this.status,
    required this.category,
    required this.totalSold,
    this.totalRating,
    this.averageRating,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  final String id;
  final String ownerId;
  final String name;
  final List<String> images;
  final int price;
  final int stock;
  final String? sku;
  final String description;
  final String status;
  final Category category;
  final int totalSold;
  final int? totalRating;
  final double? averageRating;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;
}
