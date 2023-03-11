import 'package:flutter/material.dart';
import 'package:tocopedia/presentation/pages/common_widgets/cart_button.dart';

class CartButtonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final TabBar? bottom;

  const CartButtonAppBar({Key? key, required this.title, this.bottom})
      : super(key: key);

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
              child: const CartButton(),
            ),
          ],
        ),
        bottom: bottom,
        //left align tabbar
        // bottom: PreferredSize(
        //   preferredSize: const Size.fromHeight(kToolbarHeight),
        //   child: Align(
        //     alignment: Alignment.centerLeft,
        //     child: SizedBox(
        //       width: double.infinity,
        //       child: bottom,
        //     ),
        //   ),
        // ),
      ),
    );
  }

  @override
  Size get preferredSize {
    if (bottom == null) return const Size.fromHeight(kToolbarHeight);

    return Size.fromHeight(bottom!.preferredSize.height + kToolbarHeight);
  }
}
