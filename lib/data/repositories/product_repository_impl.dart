import 'dart:io';

import 'package:tocopedia/data/data_sources/product_remote_data_source.dart';
import 'package:tocopedia/data/models/category_model.dart';
import 'package:tocopedia/domains/entities/category.dart';
import 'package:tocopedia/domains/entities/product.dart';
import 'package:tocopedia/domains/repositories/product_repository.dart';
import 'package:tocopedia/data/data_sources/remote_storage_service.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  final RemoteStorageService remoteStorageService;

  ProductRepositoryImpl(
      {required this.remoteDataSource, required this.remoteStorageService});

  @override
  Future<Product> getProduct(String id) async {
    try {
      final result = await remoteDataSource.getProduct(id);
      return result.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Product>> searchProduct(
      {String? query,
      Category? category,
      int? minimumPrice,
      int? maximumPrice,
      String? sortBy,
      String? sortOrder}) async {
    try {
      final results = await remoteDataSource.searchProduct(
        query: query,
        category: category != null ? CategoryModel.fromEntity(category) : null,
        maximumPrice: maximumPrice,
        minimumPrice: minimumPrice,
        sortBy: sortBy,
        sortOrder: sortOrder,
      );

      return List<Product>.from(results.map((e) => e.toEntity()));
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Product>> getPopularProducts() async {
    try {
      final results = await remoteDataSource.getPopularProducts();

      return List<Product>.from(results.map((e) => e.toEntity()));
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Product> addProduct(String token,
      {required String name,
      required List<File> images,
      required int price,
      required int stock,
      String? sku,
      required String description,
      required String categoryId}) async {
    try {
      List<String> imageUrls = [];

      for (int i = 0; i < images.length; i++) {
        final imageUrl = await remoteStorageService.uploadImage(images[i]);

        imageUrls.add(imageUrl);
      }

      final result = await remoteDataSource.addProduct(token,
          name: name,
          images: imageUrls,
          price: price,
          stock: stock,
          description: description,
          categoryId: categoryId);

      return result.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Product>> getUserProducts(String token) async {
    try {
      final results = await remoteDataSource.getUserProducts(token);

      return List<Product>.from(results.map((e) => e.toEntity()));
    } catch (e) {
      rethrow;
    }
  }
}
