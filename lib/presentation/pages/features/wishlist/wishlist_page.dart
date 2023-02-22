import 'package:flutter/material.dart';
import 'package:tocopedia/presentation/pages/common_widgets/cart_button_appbar.dart';

class WishListPage extends StatelessWidget {
  const WishListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CartButtonAppBar(title: "My Wishlist ❤️"),
    );
  }
}
