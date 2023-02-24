import 'package:tocopedia/domains/entities/category.dart';
import 'package:tocopedia/domains/repositories/category_repository.dart';

class GetAllCategories {
  final CategoryRepository repository;

  GetAllCategories(this.repository);

  Future<List<Category>> execute() {
    return repository.getAllCategories();
  }
}
