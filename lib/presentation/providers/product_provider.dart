import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tocopedia/domains/entities/category.dart';
import 'package:tocopedia/domains/entities/product.dart';
import 'package:tocopedia/domains/use_cases/product/get_product.dart';
import 'package:tocopedia/domains/use_cases/product/search_product.dart';
import 'package:tocopedia/presentation/providers/provider_state.dart';

class ProductProvider with ChangeNotifier {
  final GetProduct _getProduct;
  final SearchProduct _searchProduct;
  final String? _authToken;

  Product? _product;

  Product? get product => _product;

  List<Product>? _searchedProduct;

  List<Product>? get searchedProduct => [...?_searchedProduct];

  String _message = "";

  String get message => _message;

  ProductProvider(
      {required GetProduct getProduct,
      required SearchProduct searchProduct,
      required String? authToken})
      : _searchProduct = searchProduct,
        _getProduct = getProduct,
        _authToken = authToken;

  ProviderState _searchProductState = ProviderState.empty;

  ProviderState get searchProductState => _searchProductState;

  ProviderState _getProductState = ProviderState.empty;

  ProviderState get getProductState => _getProductState;

  Future<void> searchProduct(
      {String? query,
      Category? category,
      int? minimumPrice,
      int? maximumPrice,
      String? sortBy,
      String? sortOrder}) async {
    try {
      _searchProductState = ProviderState.loading;
      notifyListeners();

      final products = await _searchProduct.execute(
        query: query,
        category: category,
        maximumPrice: maximumPrice,
        minimumPrice: minimumPrice,
        sortBy: sortBy,
        sortOrder: sortOrder,
      );
      _searchedProduct = products;
      _searchProductState = ProviderState.loaded;
      notifyListeners();
    } catch (e) {
      _message = e.toString();
      _searchProductState = ProviderState.error;
      notifyListeners();
    }
  }

  Future<void> getProduct(String id) async {
    try {
      _getProductState = ProviderState.loading;
      notifyListeners();

      final product = await _getProduct.execute(id);
      _product = product;
      _getProductState = ProviderState.loaded;
      notifyListeners();
    } catch (e) {
      _message = e.toString();
      _getProductState = ProviderState.error;
      notifyListeners();
    }
  }
}
