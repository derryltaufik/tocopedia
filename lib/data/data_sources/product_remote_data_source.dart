import 'dart:convert';

import 'package:tocopedia/common/constants.dart';
import 'package:tocopedia/common/exception.dart';
import 'package:tocopedia/common/secret.dart';
import 'package:tocopedia/data/models/address_model.dart';
import 'package:http/http.dart' as http;
import 'package:tocopedia/data/models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<ProductModel> getProduct(String id);
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
}
