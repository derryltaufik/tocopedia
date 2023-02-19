import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tocopedia/common/constants.dart';
import 'package:tocopedia/presentation/pages/features/cart/widgets/cart_item_tile.dart';
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

//https://hesam-kamalan.medium.com/how-to-prevent-the-keyboard-pushes-a-widget-up-on-flutter-873569449927
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Stack(
      children: [
        GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            appBar: AppBar(title: Text("Cart")),
            body: SizedBox(
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
                  if (cartItems.isEmpty) {
                    return Center(child: Text("Your cart is empty!"));
                  }
                  return ListView.separated(
                    separatorBuilder: (context, index) => Divider(thickness: 0),
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final cartItem = cartItems[index];
                      return CartItemTile(
                        cartItem: cartItem,
                        key: Key(cartItem.id),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Material(
            elevation: 20,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(1),
                    spreadRadius: 2,
                    blurRadius: 2,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Consumer<CartProvider>(
                  builder: (context, cartProvider, child) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          rupiahFormatter.format(cartProvider.totalPrice),
                          style: theme.textTheme.titleLarge!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        FilledButton(
                            style: FilledButton.styleFrom(
                                textStyle: theme.textTheme.titleMedium),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 30.0),
                              child: Text(
                                  "Buy (${cartProvider.totalSelectedItemCount})"),
                            ),
                            onPressed: () {}),
                      ],
                    );
                  }),
            ),
          ),
        ),
      ],
    );
  }
}
