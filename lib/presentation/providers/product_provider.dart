import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tocopedia/domains/entities/category.dart';
import 'package:tocopedia/domains/entities/product.dart';
import 'package:tocopedia/domains/use_cases/product/add_product.dart';
import 'package:tocopedia/domains/use_cases/product/delete_product.dart';
import 'package:tocopedia/domains/use_cases/product/get_popular_products.dart';
import 'package:tocopedia/domains/use_cases/product/get_product.dart';
import 'package:tocopedia/domains/use_cases/product/get_user_products.dart';
import 'package:tocopedia/domains/use_cases/product/search_product.dart';
import 'package:tocopedia/domains/use_cases/product/update_product.dart';
import 'package:tocopedia/presentation/helper_variables/provider_state.dart';
import 'package:tocopedia/presentation/helper_variables/search_arguments.dart';

class ProductProvider with ChangeNotifier {
  final AddProduct _addProduct;
  final UpdateProduct _updateProduct;
  final DeleteProduct _deleteProduct;
  final GetProduct _getProduct;
  final SearchProduct _searchProduct;
  final GetUserProducts _getUserProducts;
  final GetPopularProducts _getPopularProducts;
  final String? _authToken;

  Product? _product;

  Product? get product => _product;

  List<Product>? _searchedProduct;
  List<Product>? _popularProducts;
  List<Product>? _userProducts;

  List<Product>? get popularProducts => [...?_popularProducts];

  List<Product>? get searchedProduct => [...?_searchedProduct];

  List<Product>? get userProducts => [...?_userProducts];

  String _message = "";

  String get message => _message;

  ProductProvider(
      {required AddProduct addProduct,
      required UpdateProduct updateProduct,
      required DeleteProduct deleteProduct,
      required GetProduct getProduct,
      required SearchProduct searchProduct,
      required GetUserProducts getUserProducts,
      required GetPopularProducts getPopularProducts,
      required String? authToken})
      : _addProduct = addProduct,
        _updateProduct = updateProduct,
        _deleteProduct = deleteProduct,
        _searchProduct = searchProduct,
        _getPopularProducts = getPopularProducts,
        _getUserProducts = getUserProducts,
        _getProduct = getProduct,
        _authToken = authToken;

  ProviderState _searchProductState = ProviderState.empty;

  ProviderState get searchProductState => _searchProductState;

  ProviderState _getPopularProductsState = ProviderState.empty;

  ProviderState get getPopularProductsState => _getPopularProductsState;

  ProviderState _getUserProductsState = ProviderState.empty;

  ProviderState get getUserProductsState => _getUserProductsState;

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

  Future<void> getUserProducts() async {
    try {
      if (!_verifyToken()) throw Exception("You need to login");

      _getUserProductsState = ProviderState.loading;
      notifyListeners();

      final products = await _getUserProducts.execute(_authToken!);
      _userProducts = products;
      _getUserProductsState = ProviderState.loaded;
      notifyListeners();
    } catch (e) {
      _message = e.toString();
      _getUserProductsState = ProviderState.error;
      notifyListeners();
    }
  }

  Future<Product?> getProduct(String id) async {
    try {
      _getProductState = ProviderState.loading;
      notifyListeners();

      final product = await _getProduct.execute(id);
      _product = product;
      _getProductState = ProviderState.loaded;
      notifyListeners();
      return product;
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
        sku: sku,
        images: images,
        price: price,
        name: name,
      );
      getUserProducts();
      return product;
    } catch (e) {
      rethrow;
    }
  }

  Future<Product> updateProduct(
    String productId, {
    String? name,
    List<String>? oldImages,
    List<File>? newImages,
    int? price,
    int? stock,
    String? sku,
    String? description,
    String? categoryId,
    bool? active,
  }) async {
    try {
      if (!_verifyToken()) throw Exception("You need to login");

      final product = await _updateProduct.execute(
        _authToken!,
        productId,
        stock: stock,
        sku: sku,
        categoryId: categoryId,
        description: description,
        oldImages: oldImages,
        newImages: newImages,
        price: price,
        name: name,
        active: active,
      );
      getUserProducts();
      return product;
    } catch (e) {
      rethrow;
    }
  }

  Future<Product?> deleteProduct(String productId) async {
    try {
      if (!_verifyToken()) throw Exception("You need to login");

      final product = await _deleteProduct.execute(_authToken!, productId);
      getUserProducts();
      return product;
    } catch (e) {
      rethrow;
    }
  }

  bool _verifyToken() {
    return (_authToken != null && _authToken!.isNotEmpty);
  }
}
