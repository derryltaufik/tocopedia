import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tocopedia/presentation/pages/features/cart/cart_page.dart';
import 'package:tocopedia/presentation/providers/cart_provider.dart';

class CartButton extends StatelessWidget {
  const CartButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Consumer<CartProvider>(builder: (_, cartProvider, __) {
        return Badge.count(
            count: cartProvider.totalItemCount,
            child: const Icon(Icons.shopping_cart_outlined, size: 25));
      }),
      onPressed: () => Navigator.of(context).pushNamed(CartPage.routeName),
    );
  }
}
