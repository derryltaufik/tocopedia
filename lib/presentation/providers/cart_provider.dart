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

  Cart? cart;

  String _message = "";

  String get message => _message;

  String? get token => _authToken;

  int get totalItemCount {
    if (cart == null) return 0;
    if (cart!.cartItems.isEmpty) return 0;
    int total = 0;
    for (var cartItem in cart!.cartItems) {
      for (var cartItemDetail in cartItem.cartItemDetails!) {
        total += cartItemDetail.quantity!;
      }
    }
    return total;
  }

  int get totalSelectedItemCount {
    if (cart == null) return 0;
    if (cart!.cartItems.isEmpty) return 0;
    int total = 0;
    for (var cartItem in cart!.cartItems) {
      for (var cartItemDetail in cartItem.cartItemDetails!) {
        if (cartItemDetail.selected!) {
          total += cartItemDetail.quantity!;
        }
      }
    }
    return total;
  }

  int get totalPrice {
    if (cart == null) return 0;
    if (cart!.cartItems.isEmpty) return 0;
    int total = 0;
    for (var cartItem in cart!.cartItems) {
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
      final tempCart = await _addToCart.execute(_authToken!, productId);
      cart = tempCart;
      _updateCartState = ProviderState.loaded;
      notifyListeners();
    } catch (e) {
      _message = e.toString();
      _updateCartState = ProviderState.error;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> selectCartItem(String productId) async {
    try {
      if (!_verifyToken()) throw Exception("You need to login");
      final tempCart = await _selectCartItem.execute(_authToken!, productId);
      cart = tempCart;
      notifyListeners();
    } catch (e) {}
  }

  Future<void> selectSeller(String sellerId) async {
    try {
      if (!_verifyToken()) throw Exception("You need to login");
      final tempCart = await _selectSeller.execute(_authToken!, sellerId);
      cart = tempCart;
      notifyListeners();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> unselectSeller(String sellerId) async {
    try {
      if (!_verifyToken()) throw Exception("You need to login");
      final tempCart = await _unselectSeller.execute(_authToken!, sellerId);
      cart = tempCart;
      notifyListeners();
    } catch (e) {}
  }

  Future<void> unselectCartItem(String productId) async {
    try {
      if (!_verifyToken()) throw Exception("You need to login");
      final tempCart = await _unselectCartItem.execute(_authToken!, productId);
      cart = tempCart;
      notifyListeners();
    } catch (e) {}
  }

  Future<void> removeFromCart(String productId) async {
    try {
      if (!_verifyToken()) throw Exception("You need to login");
      // _updateCartState = ProviderState.loading;
      // notifyListeners();
      final tempCart = await _removeFromCart.execute(_authToken!, productId);
      cart = tempCart;
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

      final tempCart =
          await _updateCart.execute(_authToken!, productId, quantity);
      cart = tempCart;

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
      final tempCart = await _getCart.execute(_authToken!);
      cart = tempCart;
      _getCartState = ProviderState.loaded;
      notifyListeners();
    } catch (e) {
      _message = e.toString();
      _getCartState = ProviderState.error;
      notifyListeners();
    }
  }

  Cart getCheckoutCart() {
    final tempCart = cart!.copyWith(); //cloning cart
    for (var cartItem in tempCart.cartItems) {
      cartItem.cartItemDetails!
          .removeWhere((element) => element.selected == false);
    }
    tempCart.cartItems
        .removeWhere((element) => element.cartItemDetails!.isEmpty);
    return tempCart;
  }

  Future<void> init() async {
    try {
      if (_verifyToken()) {
        cart = await _getCart.execute(_authToken!);
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
