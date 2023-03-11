import 'dart:io';

import 'package:tocopedia/domains/entities/product.dart';
import 'package:tocopedia/domains/repositories/product_repository.dart';

class AddProduct {
  final ProductRepository repository;

  AddProduct(this.repository);

  Future<Product> execute(
    String token, {
    required String name,
    required List<File> images,
    required int price,
    required int stock,
    String? sku,
    required String description,
    required String categoryId,
  }) {
    return repository.addProduct(
      token,
      name: name,
      price: price,
      images: images,
      description: description,
      categoryId: categoryId,
      stock: stock,
      sku: sku,
    );
  }
}
