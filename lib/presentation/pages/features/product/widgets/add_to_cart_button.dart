import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tocopedia/presentation/pages/features/cart/cart_page.dart';
import 'package:tocopedia/presentation/providers/cart_provider.dart';
import 'package:tocopedia/presentation/providers/provider_state.dart';

class AddToCartButton extends StatelessWidget {
  const AddToCartButton({
    super.key,
    required this.productId,
  });

  final String productId;

  void addToCart(BuildContext context) async {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final theme = Theme.of(context);
    await cartProvider.addToCart(productId);

    if (cartProvider.addCartState == ProviderState.error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(cartProvider.message),
          behavior: SnackBarBehavior.floating,
        ));
      }
    } else if (cartProvider.addCartState == ProviderState.loaded) {
      if (context.mounted) {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return SizedBox(
              height: 150,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      'Product successfully added to cart',
                      style: theme.textTheme.titleMedium,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        OutlinedButton(
                          child: const Text('Ok'),
                          onPressed: () => Navigator.pop(context),
                        ),
                        SizedBox(width: 5),
                        FilledButton(
                          child: const Text('See Cart'),
                          onPressed: () => Navigator.of(context)
                              .pushNamed(CartPage.routeName),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      elevation: 20,
      child: Container(
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 2,
              offset: Offset(0, 2),
            ),
          ],
        ),
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 2),
        child: FilledButton.icon(
          icon: Icon(Icons.add_shopping_cart_rounded),
          label: Text(
            "Add To Cart",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          onPressed: () async => addToCart(context),
        ),
      ),
    );
  }
}
