import 'package:tocopedia/data/data_sources/product_remote_data_source.dart';
import 'package:tocopedia/data/models/category_model.dart';
import 'package:tocopedia/domains/entities/category.dart';
import 'package:tocopedia/domains/entities/product.dart';
import 'package:tocopedia/domains/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl({required this.remoteDataSource});

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
}
