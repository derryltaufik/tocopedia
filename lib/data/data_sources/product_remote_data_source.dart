import 'dart:convert';

import 'package:tocopedia/common/constants.dart';
import 'package:tocopedia/common/exception.dart';
import 'package:tocopedia/common/env_variables.dart';
import 'package:http/http.dart' as http;
import 'package:tocopedia/data/models/category_model.dart';
import 'package:tocopedia/data/models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<ProductModel> getProduct(String id);

  Future<List<ProductModel>> searchProduct(
      {String? query,
      CategoryModel? category,
      int? minimumPrice,
      int? maximumPrice,
      String? sortBy,
      String? sortOrder});
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final http.Client client;

  ProductRemoteDataSourceImpl({required this.client});

  @override
  Future<ProductModel> getProduct(String id) async {
    final url = Uri.parse(BASE_URL).replace(path: '/products/$id');

    final response = await client.get(url, headers: defaultHeader);

    final responseBody = json.decode(response.body);
    if (response.statusCode ~/ 100 == 2) {
      return ProductModel.fromMap(responseBody["data"]["product"]);
    }

    throw ServerException(responseBody["error"].toString());
  }

  @override
  Future<List<ProductModel>> searchProduct(
      {String? query,
      CategoryModel? category,
      int? minimumPrice,
      int? maximumPrice,
      String? sortBy,
      String? sortOrder}) async {
    final url = Uri.parse(BASE_URL).replace(
      path: '/products/search',
      queryParameters: {
        "q": query,
        "category": category?.id,
        "min-price": minimumPrice,
        "max-price": maximumPrice,
        "sort-by": sortBy,
        "sort-order": sortOrder
      }..removeWhere((key, value) => value == null || value.toString().isEmpty),
    );

    final response = await client.get(url, headers: defaultHeader);

    final responseBody = json.decode(response.body);
    if (response.statusCode ~/ 100 == 2) {
      return List<ProductModel>.from(
          responseBody["data"]["results"].map((x) => ProductModel.fromMap(x)));
    }

    throw ServerException(responseBody["error"].toString());
  }
}
