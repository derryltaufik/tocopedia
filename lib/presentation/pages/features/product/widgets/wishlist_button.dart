import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tocopedia/presentation/helper_variables/future_function_handler.dart';
import 'package:tocopedia/presentation/helper_variables/provider_state.dart';
import 'package:tocopedia/presentation/providers/wishlist_provider.dart';

class WishlistButton extends StatefulWidget {
  const WishlistButton({Key? key, required this.productId}) : super(key: key);
  final String productId;

  @override
  State<WishlistButton> createState() => _WishlistButtonState();
}

class _WishlistButtonState extends State<WishlistButton> {
  Future<void> deleteWishlist(BuildContext context) async {
    await handleFutureFunction(
      context,
      successMessage: "removed from wishlist",
      function: Provider.of<WishlistProvider>(context, listen: false)
          .deleteWishlist(widget.productId),
    );
  }

  Future<void> addWishlist(BuildContext context) async {
    await handleFutureFunction(
      context,
      successMessage: "added to wishlist",
      function: Provider.of<WishlistProvider>(context, listen: false)
          .addWishlist(widget.productId),
    );
  }

  @override
  void initState() {
    super.initState();
    if (Provider.of<WishlistProvider>(context, listen: false)
            .getWishlistState !=
        ProviderState.loaded) {
      Future.microtask(() =>
          Provider.of<WishlistProvider>(context, listen: false).getWishlist());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WishlistProvider>(
        builder: (context, wishlistProvider, child) {
      final bool isFavorite = wishlistProvider.isFavorite(widget.productId);
      return IconButton(
        onPressed: () =>
            isFavorite ? deleteWishlist(context) : addWishlist(context),
        icon: Icon(isFavorite
            ? Icons.favorite_rounded
            : Icons.favorite_outline_rounded),
        color: Colors.red,
      );
    });
  }
}
