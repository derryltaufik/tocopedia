import 'package:tocopedia/domains/entities/category.dart';
import 'package:tocopedia/domains/entities/product.dart';

abstract class ProductRepository {
  // Future<Product> createProduct();
  //
  // Future<Product> updateProduct();
  //
  // Future<Product> deleteProduct(String productId);

  Future<Product> getProduct(String id);

  Future<List<Product>> searchProduct(
      {String? query,
      Category? category,
      int? minimumPrice,
      int? maximumPrice,
      String? sortBy,
      String? sortOrder});

  Future<List<Product>> getPopularProducts();
}
