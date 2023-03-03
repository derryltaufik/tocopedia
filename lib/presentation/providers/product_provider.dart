import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tocopedia/domains/entities/category.dart';
import 'package:tocopedia/domains/entities/product.dart';
import 'package:tocopedia/domains/use_cases/product/add_product.dart';
import 'package:tocopedia/domains/use_cases/product/get_popular_products.dart';
import 'package:tocopedia/domains/use_cases/product/get_product.dart';
import 'package:tocopedia/domains/use_cases/product/search_product.dart';
import 'package:tocopedia/presentation/helper_variables/provider_state.dart';
import 'package:tocopedia/presentation/helper_variables/search_arguments.dart';

class ProductProvider with ChangeNotifier {
  final AddProduct _addProduct;
  final GetProduct _getProduct;
  final SearchProduct _searchProduct;
  final GetPopularProducts _getPopularProducts;
  final String? _authToken;

  Product? _product;

  Product? get product => _product;

  List<Product>? _searchedProduct;

  List<Product>? _popularProducts;

  List<Product>? get popularProducts => [...?_popularProducts];

  List<Product>? get searchedProduct => [...?_searchedProduct];

  String _message = "";

  String get message => _message;

  ProductProvider(
      {required AddProduct addProduct,
      required GetProduct getProduct,
      required SearchProduct searchProduct,
      required GetPopularProducts getPopularProducts,
      required String? authToken})
      : _addProduct = addProduct,
        _searchProduct = searchProduct,
        _getPopularProducts = getPopularProducts,
        _getProduct = getProduct,
        _authToken = authToken;

  ProviderState _searchProductState = ProviderState.empty;

  ProviderState get searchProductState => _searchProductState;

  ProviderState _getPopularProductsState = ProviderState.empty;

  ProviderState get getPopularProductsState => _getPopularProductsState;

  ProviderState _getProductState = ProviderState.empty;

  ProviderState get getProductState => _getProductState;

  Future<List<Product>?> searchProduct(SearchArguments searchArguments) async {
    try {
      // _searchProductState = ProviderState.loading;
      // notifyListeners();

      final products = await _searchProduct.execute(
        query: searchArguments.searchQuery,
        sortOrder: searchArguments.sortSelection?.orderBy,
        sortBy: searchArguments.sortSelection?.sortBy,
        minimumPrice: searchArguments.minimumPrice,
        maximumPrice: searchArguments.maximumPrice,
        category: searchArguments.category,
      );
      _searchedProduct = products;
      // _searchProductState = ProviderState.loaded;
      // notifyListeners();
      return _searchedProduct;
    } catch (e) {
      // _message = e.toString();
      // _searchProductState = ProviderState.error;
      // notifyListeners();
      rethrow;
    }
  }

  Set<Category> getSearchedProductCategories() {
    final Set<Category> categoriesSet = <Category>{};
    _searchedProduct
        ?.forEach((product) => categoriesSet.add(product.category!));
    return categoriesSet;
  }

  Future<void> getPopularProducts() async {
    try {
      _getPopularProductsState = ProviderState.loading;
      notifyListeners();

      final products = await _getPopularProducts.execute();
      _popularProducts = products;
      _getPopularProductsState = ProviderState.loaded;
      notifyListeners();
    } catch (e) {
      _message = e.toString();
      _getPopularProductsState = ProviderState.error;
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

  Future<Product> addProduct({
    required String name,
    required List<File> images,
    required int price,
    required int stock,
    String? sku,
    required String description,
    required String categoryId,
  }) async {
    try {
      if (!_verifyToken()) throw Exception("You need to login");

      final product = await _addProduct.execute(
        _authToken!,
        stock: stock,
        categoryId: categoryId,
        description: description,
        images: images,
        price: price,
        name: name,
      );
      return product;
    } catch (e) {
      rethrow;
    }
  }

  bool _verifyToken() {
    return (_authToken != null && _authToken!.isNotEmpty);
  }
}
