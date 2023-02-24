import 'package:flutter/material.dart';
import 'package:tocopedia/presentation/pages/common_widgets/cart_button.dart';
import 'package:tocopedia/presentation/pages/common_widgets/product_search_bar.dart';

class HomeAppBar extends StatelessWidget with PreferredSizeWidget {
  final String query;

  const HomeAppBar({Key? key, this.query = ""}) : super(key: key);

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
              child: ProductSearchBar(query: query),
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
