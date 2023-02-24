import 'package:flutter_test/flutter_test.dart';
import 'package:tocopedia/data/data_sources/category_remote_data_source.dart';
import 'package:http/http.dart' as http;
import 'package:tocopedia/data/repositories/category_repository_impl.dart';
import 'package:tocopedia/domains/repositories/category_repository.dart';

void main() {
  late CategoryRepository repository;

  setUp(() {
    repository = CategoryRepositoryImpl(
        remoteDataSource: CategoryRemoteDataSourceImpl(client: http.Client()));
  });

  group("Get All Categories", () {
    test('should return User Model when the response code is 200', () async {
      try {
        final results = await repository.getAllCategories();
        print(results[0].name!);
      } catch (e) {
        rethrow;
      }
    });
  });
  group("Get Category", () {
    test('ergerkbrefjhrebfjre', () async {
      try {
        final result = await repository.getCategory("63f85eacaf9b5c7b110dcd59");
        print(result.name!);
      } catch (e) {
        rethrow;
      }
    });
  });
}
