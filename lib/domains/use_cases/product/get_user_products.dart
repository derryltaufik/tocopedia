import 'package:tocopedia/domains/entities/product.dart';
import 'package:tocopedia/domains/repositories/product_repository.dart';

class GetUserProducts {
  final ProductRepository repository;

  GetUserProducts(this.repository);

  Future<List<Product>> execute(String token) {
    return repository.getUserProducts(token);
  }
}
