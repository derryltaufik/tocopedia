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

  Future<List<ProductModel>> getPopularProducts();

  Future<List<ProductModel>> getUserProducts(String token);

  Future<ProductModel> addProduct(
    String token, {
    required String name,
    required List<String> images,
    required int price,
    required int stock,
    String? sku,
    required String description,
    required String categoryId,
  });

  Future<ProductModel> updateProduct(
    String token,
    String productId, {
    String? name,
    List<String>? images,
    int? price,
    int? stock,
    String? sku,
    String? description,
    String? categoryId,
    bool? active,
  });

  Future<ProductModel> deleteProduct(String token, String productId);
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
    final queryParams = ({
      "q": query,
      "category": category?.id,
      "min-price": minimumPrice,
      "max-price": maximumPrice,
      "sort-by": sortBy,
      "sort-order": sortOrder
    }..removeWhere((key, value) => value == null || value.toString().isEmpty))
        .map((key, value) => MapEntry(key, value.toString()));

    final url = Uri.parse(BASE_URL).replace(
      path: '/products/search',
      queryParameters: queryParams,
    );

    final response = await client.get(url, headers: defaultHeader);

    final responseBody = json.decode(response.body);

    if (response.statusCode ~/ 100 == 2) {
      return List<ProductModel>.from(
          responseBody["data"]["results"].map((x) => ProductModel.fromMap(x)));
    }

    throw ServerException(responseBody["error"].toString());
  }

  @override
  Future<List<ProductModel>> getPopularProducts() async {
    final url = Uri.parse(BASE_URL).replace(
      path: '/products/popular',
    );

    final response = await client.get(url, headers: defaultHeader);

    final responseBody = json.decode(response.body);
    if (response.statusCode ~/ 100 == 2) {
      return List<ProductModel>.from(
          responseBody["data"]["results"].map((x) => ProductModel.fromMap(x)));
    }

    throw ServerException(responseBody["error"].toString());
  }

  @override
  Future<ProductModel> addProduct(String token,
      {required String name,
      required List<String> images,
      required int price,
      required int stock,
      String? sku,
      required String description,
      required String categoryId}) async {
    final body = ({
      "name": name,
      "category": categoryId,
      "images": images,
      "price": price,
      "stock": stock,
      "SKU": sku,
      "description": description
    }..removeWhere((key, value) => value == null || value.toString().isEmpty));

    final url = Uri.parse(BASE_URL).replace(path: '/products');

    final response = await client.post(
      url,
      headers: defaultHeader
        ..addEntries({"Authorization": "Bearer $token"}.entries),
      body: json.encode(body),
    );

    final responseBody = json.decode(response.body);

    if (response.statusCode ~/ 100 == 2) {
      return ProductModel.fromMap(responseBody["data"]["product"]);
    }

    throw ServerException(responseBody["error"].toString());
  }

  @override
  Future<List<ProductModel>> getUserProducts(String token) async {
    final url = Uri.parse(BASE_URL).replace(path: '/products/seller');

    final response = await client.get(
      url,
      headers: defaultHeader
        ..addEntries({"Authorization": "Bearer $token"}.entries),
    );

    final responseBody = json.decode(response.body);

    if (response.statusCode ~/ 100 == 2) {
      return List<ProductModel>.from(
          responseBody["data"]["results"].map((x) => ProductModel.fromMap(x)));
    }

    throw ServerException(responseBody["error"].toString());
  }

  @override
  Future<ProductModel> updateProduct(
    String token,
    String productId, {
    String? name,
    List<String>? images,
    int? price,
    int? stock,
    String? sku,
    String? description,
    String? categoryId,
    bool? active,
  }) async {
    final String? status = active == null
        ? null
        : active == true
            ? "active"
            : "inactive";

    final body = ({
      "name": name,
      "category": categoryId,
      "images": images,
      "price": price,
      "stock": stock,
      "SKU": sku,
      "description": description,
      "status": status,
    }..removeWhere((key, value) => value == null || value.toString().isEmpty));

    final url = Uri.parse(BASE_URL).replace(path: '/products/$productId');

    final response = await client.patch(
      url,
      headers: defaultHeader
        ..addEntries({"Authorization": "Bearer $token"}.entries),
      body: json.encode(body),
    );

    final responseBody = json.decode(response.body);

    if (response.statusCode ~/ 100 == 2) {
      return ProductModel.fromMap(responseBody["data"]["product"]);
    }

    throw ServerException(responseBody["error"].toString());
  }

  @override
  Future<ProductModel> deleteProduct(String token, String productId) async {
    final url = Uri.parse(BASE_URL).replace(path: '/products/$productId');

    final response = await client.delete(
      url,
      headers: defaultHeader
        ..addEntries({"Authorization": "Bearer $token"}.entries),
    );

    final responseBody = json.decode(response.body);

    if (response.statusCode ~/ 100 == 2) {
      return ProductModel.fromMap(responseBody["data"]["product"]);
    }

    throw ServerException(responseBody["error"].toString());
  }
}
