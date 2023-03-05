import 'dart:io';

import 'package:tocopedia/domains/entities/product.dart';
import 'package:tocopedia/domains/repositories/product_repository.dart';

class UpdateProduct {
  final ProductRepository repository;

  UpdateProduct(this.repository);
  Future<Product> execute(
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
  }) {
    return repository.updateProduct(
      token,
      productId,
      name: name,
      price: price,
      newImages: newImages,
      oldImages: oldImages,
      description: description,
      categoryId: categoryId,
      stock: stock,
      sku: sku,
    );
  }
}
