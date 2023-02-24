import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tocopedia/domains/entities/category.dart';
import 'package:tocopedia/domains/use_cases/category/get_all_categories.dart';
import 'package:tocopedia/domains/use_cases/category/get_category.dart';
import 'package:tocopedia/presentation/helper_variables/provider_state.dart';

class CategoryProvider with ChangeNotifier {
  final GetCategory _getCategory;
  final GetAllCategories _getAllCategories;

  Category? _category;

  Category? get category => _category;

  List<Category>? _allCategories;

  List<Category>? get allCategories => [...?_allCategories];

  String _message = "";

  String get message => _message;

  ProviderState _getAllCategoriesState = ProviderState.empty;

  ProviderState get getAllCategoriesState => _getAllCategoriesState;

  ProviderState _getCategoryState = ProviderState.empty;

  ProviderState get getCategoryState => _getCategoryState;

  CategoryProvider({
    required GetCategory getCategory,
    required GetAllCategories getAllCategories,
  })  : _getCategory = getCategory,
        _getAllCategories = getAllCategories;

  Future<void> getAllCategories() async {
    try {
      _getAllCategoriesState = ProviderState.loading;
      notifyListeners();

      final categories = await _getAllCategories.execute();
      _allCategories = categories;
      _getAllCategoriesState = ProviderState.loaded;
      notifyListeners();
    } catch (e) {
      _message = e.toString();
      _getAllCategoriesState = ProviderState.error;
      notifyListeners();
    }
  }

  Future<void> getProduct(String categoryId) async {
    try {
      _getCategoryState = ProviderState.loading;
      notifyListeners();

      final category = await _getCategory.execute(categoryId);
      _category = category;
      _getCategoryState = ProviderState.loaded;
      notifyListeners();
    } catch (e) {
      _message = e.toString();
      _getCategoryState = ProviderState.error;
      notifyListeners();
    }
  }
}
