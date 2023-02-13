import 'package:tocopedia/domains/entities/product.dart';
import 'package:tocopedia/domains/repositories/product_repository.dart';

class GetProduct {
  final ProductRepository repository;

  GetProduct(this.repository);

  Future<Product> execute(String id) {
    return repository.getProduct(id);
  }
}
