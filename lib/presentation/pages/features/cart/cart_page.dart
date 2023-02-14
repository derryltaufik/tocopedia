import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tocopedia/presentation/providers/cart_provider.dart';
import 'package:tocopedia/presentation/providers/provider_state.dart';

class CartPage extends StatefulWidget {
  static const String routeName = "/cart";

  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<CartProvider>(context, listen: false).getCart();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cart")),
      body: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          Container(
            height: double.infinity,
            child: Consumer<CartProvider>(
              builder: (context, cartProvider, child) {
                if (cartProvider.getCartState == ProviderState.empty ||
                    cartProvider.getCartState == ProviderState.loading) {
                  return Center(child: CircularProgressIndicator());
                } else if (cartProvider.getCartState == ProviderState.error) {
                  return Center(child: Text(cartProvider.message));
                }
                final cartItems = cartProvider.cart!.cartItems;
                return ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final cartItem = cartItems[index];
                    return ListTile(
                      title: Text(cartItem.productId),
                    );
                  },
                );
              },
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: FilledButton(child: Text("Checkout"), onPressed: () {}),
          ),
        ],
      ),
    );
  }
}
