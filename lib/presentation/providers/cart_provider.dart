import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tocopedia/domains/entities/cart.dart';
import 'package:tocopedia/domains/entities/cart_item.dart';
import 'package:tocopedia/domains/entities/product.dart';
import 'package:tocopedia/domains/use_cases/cart/add_to_cart.dart';
import 'package:tocopedia/domains/use_cases/cart/clear_cart.dart';
import 'package:tocopedia/domains/use_cases/cart/get_cart.dart';
import 'package:tocopedia/domains/use_cases/cart/remove_from_cart.dart';
import 'package:tocopedia/domains/use_cases/cart/select_cart_item.dart';
import 'package:tocopedia/domains/use_cases/cart/unselect_cart_item.dart';
import 'package:tocopedia/domains/use_cases/cart/update_cart.dart';
import 'package:tocopedia/domains/use_cases/product/get_product.dart';
import 'package:tocopedia/presentation/providers/provider_state.dart';

class CartProvider with ChangeNotifier {
  final GetCart _getCart;
  final AddToCart _addToCart;
  final RemoveFromCart _removeFromCart;
  final UpdateCart _updateCart;
  final ClearCart _clearCart;
  final GetProduct _getProduct;
  final SelectCartItem _selectCartItem;
  final UnselectCartItem _unselectCartItem;
  final String? _authToken;

  Cart? _cart;

  Cart? get cart => _cart;

  String _message = "";

  final Map<String, Product> _productMap = {};

  String get message => _message;

  String? get token => _authToken;

  Map<String, Product> get productMap => _productMap;

  int get totalItemCount {
    if (_cart == null) return 0;
    if (_cart!.cartItems.isEmpty) return 0;
    int total = 0;
    for (var cartItem in _cart!.cartItems) {
      if (cartItem.selected) total += cartItem.quantity;
    }
    return total;
  }

  int get totalPrice {
    if (_cart == null) return 0;
    if (_cart!.cartItems.isEmpty) return 0;
    int total = 0;
    for (var cartItem in _cart!.cartItems) {
      if (!productMap.containsKey(cartItem.productId)) return 0;
      if (cartItem.selected) {
        total += cartItem.quantity * productMap[cartItem.productId]!.price;
      }
    }
    return total;
  }

  CartProvider(
      {required GetCart getCart,
      required AddToCart addToCart,
      required RemoveFromCart removeFromCart,
      required UpdateCart updateCart,
      required ClearCart clearCart,
      required GetProduct getProduct,
      required SelectCartItem selectCartItem,
      required UnselectCartItem unselectCartItem,
      required String? authToken})
      : _getCart = getCart,
        _addToCart = addToCart,
        _removeFromCart = removeFromCart,
        _updateCart = updateCart,
        _clearCart = clearCart,
        _getProduct = getProduct,
        _unselectCartItem = unselectCartItem,
        _selectCartItem = selectCartItem,
        _authToken = authToken;

  ProviderState _getCartState = ProviderState.empty;

  ProviderState get getCartState => _getCartState;

  ProviderState _updateCartState = ProviderState.empty;

  ProviderState get updateCartState => _updateCartState;

  Future<void> addToCart(String productId) async {
    try {
      if (!_verifyToken()) throw Exception("You need to login");
      _updateCartState = ProviderState.loading;
      notifyListeners();
      final cart = await _addToCart.execute(_authToken!, productId);
      _cart = cart;
      _updateCartState = ProviderState.loaded;
      notifyListeners();
    } catch (e) {
      _message = e.toString();
      _updateCartState = ProviderState.error;
      notifyListeners();
    }
  }

  Future<void> selectCartItem(String productId) async {
    try {
      if (!_verifyToken()) throw Exception("You need to login");
      final cart = await _selectCartItem.execute(_authToken!, productId);
      _cart = cart;
      notifyListeners();
    } catch (e) {}
  }

  Future<void> unselectCartItem(String productId) async {
    try {
      if (!_verifyToken()) throw Exception("You need to login");
      final cart = await _unselectCartItem.execute(_authToken!, productId);
      _cart = cart;
      notifyListeners();
    } catch (e) {}
  }

  Future<void> removeFromCart(String productId) async {
    try {
      if (!_verifyToken()) throw Exception("You need to login");
      // _updateCartState = ProviderState.loading;
      // notifyListeners();
      final cart = await _removeFromCart.execute(_authToken!, productId);
      _cart = cart;
      // _updateCartState = ProviderState.loaded;
      notifyListeners();
    } catch (e) {
      _message = e.toString();
      // _updateCartState = ProviderState.error;
      // notifyListeners();
    }
  }

  Future<void> updateCart(String productId, int quantity) async {
    try {
      if (!_verifyToken()) throw Exception("You need to login");
      // _updateCartState = ProviderState.loading;
      // notifyListeners();
      final cart = await _updateCart.execute(_authToken!, productId, quantity);
      _cart = cart;
      // _updateCartState = ProviderState.loaded;
      notifyListeners();
    } catch (e) {
      _message = e.toString();
      // _updateCartState = ProviderState.error;
      // notifyListeners();
    }
  }

  Future<void> getCart() async {
    try {
      if (!_verifyToken()) throw Exception("You need to login");
      _getCartState = ProviderState.loading;
      notifyListeners();
      final cart = await _getCart.execute(_authToken!);
      _cart = cart;
      for (CartItem cartItem in _cart!.cartItems) {
        final product = await _getProduct.execute(cartItem.productId);
        productMap.putIfAbsent(product.id, () => product);
      }
      _getCartState = ProviderState.loaded;
      notifyListeners();
    } catch (e) {
      _message = e.toString();
      _getCartState = ProviderState.error;
      notifyListeners();
    }
  }

  Future<Product> getProduct(CartItem cartItem) async {
    try {
      final product = productMap[cartItem.productId];
      return product!;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> init() async {
    try {
      if (_verifyToken()) {
        _cart = await _getCart.execute(_authToken!);
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    }
  }

  bool _verifyToken() {
    return (_authToken != null && _authToken!.isNotEmpty);
  }
}