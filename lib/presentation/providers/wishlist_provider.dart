import 'package:flutter/material.dart';
import 'package:tocopedia/domains/entities/wishlist.dart';
import 'package:tocopedia/domains/use_cases/wishlist/add_wishlist.dart';
import 'package:tocopedia/domains/use_cases/wishlist/get_wishlist.dart';
import 'package:tocopedia/domains/use_cases/wishlist/remove_wishlist.dart';
import 'package:tocopedia/presentation/helper_variables/provider_state.dart';

class WishlistProvider with ChangeNotifier {
  final AddWishlist _addWishlist;
  final GetWishlist _getWishlist;
  final DeleteWishlist _deleteWishlist;
  final String? _authToken;

  String _message = "";

  String get message => _message;

  Wishlist? _wishlist;

  Wishlist? get wishlist => _wishlist;

  ProviderState _getWishlistState = ProviderState.empty;

  ProviderState get getWishlistState => _getWishlistState;

  WishlistProvider(
      {required AddWishlist addWishlist,
      required GetWishlist getWishlist,
      required DeleteWishlist deleteWishlist,
      required String? authToken})
      : _addWishlist = addWishlist,
        _getWishlist = getWishlist,
        _deleteWishlist = deleteWishlist,
        _authToken = authToken;

  Future<void> getWishlist() async {
    try {
      if (!_verifyToken()) throw Exception("You need to login");

      _getWishlistState = ProviderState.loading;
      notifyListeners();

      final wishlist = await _getWishlist.execute(_authToken!);
      _wishlist = wishlist;
      _getWishlistState = ProviderState.loaded;
      notifyListeners();
    } catch (e) {
      _message = e.toString();
      _getWishlistState = ProviderState.error;
      notifyListeners();
      rethrow;
    }
  }

  bool _verifyToken() {
    return (_authToken != null && _authToken!.isNotEmpty);
  }
}
