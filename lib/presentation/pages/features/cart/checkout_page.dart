import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tocopedia/common/constants.dart';
import 'package:tocopedia/presentation/pages/features/cart/widgets/checkout_item_tile.dart';
import 'package:tocopedia/presentation/pages/features/home/home_page.dart';
import 'package:tocopedia/presentation/pages/features/order/view_order_page.dart';
import 'package:tocopedia/presentation/providers/cart_provider.dart';
import 'package:tocopedia/presentation/providers/order_provider.dart';
import 'package:tocopedia/presentation/providers/user_provider.dart';

class CheckoutPage extends StatelessWidget {
  static const String routeName = "/checkout";

  const CheckoutPage({Key? key}) : super(key: key);

  Future<void> checkout(BuildContext context) async {
    final address =
        Provider.of<UserProvider>(context, listen: false).user!.defaultAddress!;
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          // The background color
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                // The loading indicator
                CircularProgressIndicator(),
                SizedBox(
                  height: 15,
                ),
                // Some text
                Text('Loading...')
              ],
            ),
          ),
        );
      },
    );
    try {
      final order = await Provider.of<OrderProvider>(context, listen: false)
          .checkOut(address.id!);

      if (context.mounted) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil(HomePage.routeName, (route) => false);
        Navigator.of(context)
            .pushNamed(ViewOrderPage.routeName, arguments: order.id!);
      }
    } on Exception catch (e) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          e.toString(),
        ),
        behavior: SnackBarBehavior.floating,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cart =
        Provider.of<CartProvider>(context, listen: false).getCheckoutCart();
    return Scaffold(
      appBar: AppBar(title: Text("Checkout")),
      body: Column(
        children: [
          Flexible(
            child: ListView.separated(
              padding: EdgeInsets.only(bottom: 10),
              separatorBuilder: (context, index) => Divider(thickness: 5),
              itemCount: cart.cartItems.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Order ${index + 1}",
                          style: theme.textTheme.titleSmall),
                      SizedBox(height: 8),
                      CheckoutItemTile(cartItem: cart.cartItems[index]),
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
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
            child:
                Consumer<CartProvider>(builder: (context, cartProvider, child) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Total Invoice", style: theme.textTheme.titleSmall),
                      Text(
                        rupiahFormatter.format(cartProvider.totalPrice),
                        style: theme.textTheme.titleLarge!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  FilledButton(
                    style: FilledButton.styleFrom(
                        textStyle: theme.textTheme.titleMedium),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Text("Checkout"),
                    ),
                    onPressed: () => checkout(context),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
