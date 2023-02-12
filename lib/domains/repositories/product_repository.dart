import 'package:tocopedia/domains/entities/product.dart';

abstract class ProductRepository {
  Future<Product> createProduct();

  Future<Product> updateProduct();

  Future<Product> deleteProduct(String productId);

  Future<Product> getProduct(String productId);

  Future<List<Product>> searchProduct();
}
