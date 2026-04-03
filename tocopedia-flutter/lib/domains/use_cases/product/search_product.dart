import 'package:tocopedia/domains/entities/category.dart';
import 'package:tocopedia/domains/entities/product.dart';
import 'package:tocopedia/domains/repositories/product_repository.dart';

class SearchProduct {
  final ProductRepository repository;

  SearchProduct(this.repository);

  Future<List<Product>> execute(
      {String? query,
      Category? category,
      int? minimumPrice,
      int? maximumPrice,
      String? sortBy,
      String? sortOrder}) {
    return repository.searchProduct(
      query: query,
      category: category,
      maximumPrice: maximumPrice,
      minimumPrice: minimumPrice,
      sortBy: sortBy,
      sortOrder: sortOrder,
    );
  }
}
