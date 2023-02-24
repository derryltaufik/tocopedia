import 'package:tocopedia/domains/entities/category.dart';
import 'package:tocopedia/domains/repositories/category_repository.dart';

class GetCategory {
  final CategoryRepository repository;

  GetCategory(this.repository);

  Future<Category> execute(String categoryId) {
    return repository.getCategory(categoryId);
  }
}
