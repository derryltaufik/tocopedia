import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tocopedia/presentation/helper_variables/future_function_handler.dart';
import 'package:tocopedia/presentation/providers/cart_provider.dart';
import 'package:tocopedia/presentation/providers/wishlist_provider.dart';

class WishlistActionButtons extends StatelessWidget {
  final String productId;

  const WishlistActionButtons({Key? key, required this.productId})
      : super(key: key);

  Future<void> addToCart(BuildContext context) async {
    await handleFutureFunction(
      context,
      loadingMessage: "adding item to cart...",
      successMessage: "Item successfully added to your cart",
      function: Provider.of<CartProvider>(context, listen: false)
          .addToCart(productId),
    );
  }

  Future<void> deleteWishlist(BuildContext context) async {
    await handleFutureFunction(
      context,
      successMessage: "removed from wishlist",
      function: Provider.of<WishlistProvider>(context, listen: false)
          .deleteWishlist(productId),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        OutlinedButton(
          style: OutlinedButton.styleFrom(
              side: BorderSide(color: theme.colorScheme.tertiary),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              padding: const EdgeInsets.all(5)),
          onPressed: () => deleteWishlist(context),
          child: Icon(
            Icons.heart_broken_rounded,
            size: 20,
            color: theme.colorScheme.tertiary,
          ),
        ),
        const SizedBox(width: 5),
        Expanded(
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
                side: BorderSide(color: theme.primaryColor),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                minimumSize: Size.zero,
                padding: const EdgeInsets.all(5)),
            onPressed: () => addToCart(context),
            child: const Text("+ Add to Cart"),
          ),
        ),
      ],
    );
  }
}
