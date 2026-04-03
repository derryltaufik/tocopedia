import 'package:tocopedia/data/data_sources/category_remote_data_source.dart';
import 'package:tocopedia/domains/entities/category.dart';
import 'package:tocopedia/domains/repositories/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDataSource remoteDataSource;

  CategoryRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Category>> getAllCategories() async {
    try {
      final results = await remoteDataSource.getAllCategories();

      return List<Category>.from(results.map((e) => e.toEntity()));
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Category> getCategory(String categoryId) async {
    try {
      final result = await remoteDataSource.getCategory(categoryId);
      return result.toEntity();
    } catch (e) {
      rethrow;
    }
  }
}
