import 'package:flutter/material.dart';
import 'package:tocopedia/domains/entities/cart_item.dart';
import 'package:tocopedia/domains/entities/user.dart';
import 'package:tocopedia/presentation/pages/features/cart/widgets/cart_item_detail_tile.dart';


class CartItemTile extends StatelessWidget {
  final CartItem cartItem;

  const CartItemTile({Key? key, required this.cartItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Checkbox(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3)),
              value: true,
              onChanged: (value) {},
            ),
            Text(
              "${cartItem.seller!.name!}'s Store",
              style: Theme.of(context).textTheme.titleSmall,
            )
          ],
        ),
        SizedBox(height: 10),
        ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          separatorBuilder: (context, index) => Divider(thickness: 0),
          itemCount: cartItem.cartItemDetails!.length,
          itemBuilder: (context, index) {
            final cartItemDetail = cartItem.cartItemDetails![index];
            return CartItemDetailTile(
              cartItemDetail: cartItemDetail,
              key: Key(cartItemDetail.id!),
            );
          },
        )
      ],
    );
  }
}
