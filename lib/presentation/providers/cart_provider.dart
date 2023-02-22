import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tocopedia/domains/entities/cart.dart';
import 'package:tocopedia/domains/use_cases/cart/add_to_cart.dart';
import 'package:tocopedia/domains/use_cases/cart/clear_cart.dart';
import 'package:tocopedia/domains/use_cases/cart/get_cart.dart';
import 'package:tocopedia/domains/use_cases/cart/remove_from_cart.dart';
import 'package:tocopedia/domains/use_cases/cart/select_cart_item.dart';
import 'package:tocopedia/domains/use_cases/cart/select_seller.dart';
import 'package:tocopedia/domains/use_cases/cart/unselect_cart_item.dart';
import 'package:tocopedia/domains/use_cases/cart/unselect_seller.dart';
import 'package:tocopedia/domains/use_cases/cart/update_cart.dart';
import 'package:tocopedia/domains/use_cases/product/get_product.dart';
import 'package:tocopedia/presentation/helper_variables/provider_state.dart';

class CartProvider with ChangeNotifier {
  final GetCart _getCart;
  final AddToCart _addToCart;
  final RemoveFromCart _removeFromCart;
  final UpdateCart _updateCart;
  final ClearCart _clearCart;
  final GetProduct _getProduct;
  final SelectCartItem _selectCartItem;
  final UnselectCartItem _unselectCartItem;
  final SelectSeller _selectSeller;
  final UnselectSeller _unselectSeller;
  final String? _authToken;

  Cart? _cart;

  Cart? get cart => _cart;

  String _message = "";

  String get message => _message;

  String? get token => _authToken;

  int get totalItemCount {
    if (_cart == null) return 0;
    if (_cart!.cartItems.isEmpty) return 0;
    int total = 0;
    for (var cartItem in _cart!.cartItems) {
      for (var cartItemDetail in cartItem.cartItemDetails!) {
        total += cartItemDetail.quantity!;
      }
    }
    return total;
  }

  int get totalSelectedItemCount {
    if (_cart == null) return 0;
    if (_cart!.cartItems.isEmpty) return 0;
    int total = 0;
    for (var cartItem in _cart!.cartItems) {
      for (var cartItemDetail in cartItem.cartItemDetails!) {
        if (cartItemDetail.selected!) {
          total += cartItemDetail.quantity!;
        }
      }
    }
    return total;
  }

  int get totalPrice {
    if (_cart == null) return 0;
    if (_cart!.cartItems.isEmpty) return 0;
    int total = 0;
    for (var cartItem in _cart!.cartItems) {
      for (var cartItemDetail in cartItem.cartItemDetails!) {
        if (cartItemDetail.selected!) {
          total += cartItemDetail.quantity! * cartItemDetail.product!.price!;
        }
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
      required SelectSeller selectSeller,
      required UnselectSeller unselectSeller,
      required String? authToken})
      : _getCart = getCart,
        _addToCart = addToCart,
        _removeFromCart = removeFromCart,
        _updateCart = updateCart,
        _clearCart = clearCart,
        _getProduct = getProduct,
        _unselectCartItem = unselectCartItem,
        _selectCartItem = selectCartItem,
        _selectSeller = selectSeller,
        _unselectSeller = unselectSeller,
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

  Future<void> selectSeller(String sellerId) async {
    try {
      if (!_verifyToken()) throw Exception("You need to login");
      final cart = await _selectSeller.execute(_authToken!, sellerId);
      _cart = cart;
      notifyListeners();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> unselectSeller(String sellerId) async {
    try {
      if (!_verifyToken()) throw Exception("You need to login");
      final cart = await _unselectSeller.execute(_authToken!, sellerId);
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
      _getCartState = ProviderState.loaded;
      notifyListeners();
    } catch (e) {
      _message = e.toString();
      _getCartState = ProviderState.error;
      notifyListeners();
    }
  }

  Cart getCheckoutCart() {
    final cart = _cart!.copyWith(); //cloning cart
    for (var cartItem in cart.cartItems) {
      cartItem.cartItemDetails!
          .removeWhere((element) => element.selected == false);
    }
    cart.cartItems.removeWhere((element) => element.cartItemDetails!.isEmpty);
    return cart;
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
