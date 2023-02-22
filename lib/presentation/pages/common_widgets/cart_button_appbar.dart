import 'package:flutter/material.dart';
import 'package:tocopedia/presentation/pages/common_widgets/cart_button.dart';

class CartButtonAppBar extends StatelessWidget with PreferredSizeWidget {
  final String title;

  const CartButtonAppBar({Key? key, required this.title}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(title),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: CartButton(),
            ),
          ],
        ),
      ),
    );
  }
}
