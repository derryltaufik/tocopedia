import 'dart:io';

import 'package:tocopedia/domains/entities/category.dart';
import 'package:tocopedia/domains/entities/product.dart';

abstract class ProductRepository {
  Future<Product> getProduct(String id);

  Future<List<Product>> searchProduct(
      {String? query,
      Category? category,
      int? minimumPrice,
      int? maximumPrice,
      String? sortBy,
      String? sortOrder});

  Future<Product> addProduct(
    String token, {
    required String name,
    required List<File> images,
    required int price,
    required int stock,
    String? sku,
    required String description,
    required String categoryId,
  });

  Future<Product> updateProduct(
    String token,
    String productId, {
    String? name,
    List<File>? newImages,
    List<String>? oldImages,
    int? price,
    int? stock,
    String? sku,
    String? description,
    String? categoryId,
    bool? active,
  });

  Future<List<Product>> getPopularProducts();

  Future<List<Product>> getUserProducts(String token);

  Future<Product> deleteProduct(String token, String productId);
}
