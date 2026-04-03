import 'dart:async';
import 'dart:convert';

import 'package:tocopedia/common/constants.dart';
import 'package:tocopedia/common/exception.dart';
import 'package:tocopedia/common/env_variables.dart';
import 'package:tocopedia/data/models/category_model.dart';
import 'package:http/http.dart' as http;

abstract class CategoryRemoteDataSource {
  Future<List<CategoryModel>> getAllCategories();

  Future<CategoryModel> getCategory(String categoryId);
}

class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  final http.Client client;

  CategoryRemoteDataSourceImpl({required this.client});

  @override
  Future<List<CategoryModel>> getAllCategories() async {
    try {
      final url = Uri.parse(BASE_URL).replace(path: '/categories');

      final response = await client
          .get(
            url,
            headers: defaultHeader,
          )
          .timeout(const Duration(seconds: 5));

      final responseBody = json.decode(response.body);
      if (response.statusCode ~/ 100 == 2) {
        return List<CategoryModel>.from(responseBody["data"]["results"]
            .map((x) => CategoryModel.fromMap(x)));
      }

      throw ServerException(responseBody["error"].toString());
    } on TimeoutException catch (e) {
      throw ServerTimeoutException(e.duration);
    } on Exception {
      rethrow;
    }
  }

  @override
  Future<CategoryModel> getCategory(String categoryId) async {
    try {
      final url = Uri.parse(BASE_URL).replace(path: '/categories/$categoryId');

      final response = await client
          .get(
            url,
            headers: defaultHeader,
          )
          .timeout(const Duration(seconds: 5));

      final responseBody = json.decode(response.body);
      if (response.statusCode ~/ 100 == 2) {
        return CategoryModel.fromMap(responseBody["data"]["category"]);
      }

      throw ServerException(responseBody["error"].toString());
    } on TimeoutException catch (e) {
      throw ServerTimeoutException(e.duration);
    } on Exception {
      rethrow;
    }
  }
}
