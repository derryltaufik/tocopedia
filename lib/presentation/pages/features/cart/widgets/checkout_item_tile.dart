import 'package:flutter/material.dart';
import 'package:tocopedia/presentation/helper_variables/format_rupiah.dart';
import 'package:tocopedia/domains/entities/cart_item.dart';
import 'package:tocopedia/presentation/pages/features/cart/widgets/checkout_item_detail_tile.dart';

class CheckoutItemTile extends StatelessWidget {
  final CartItem cartItem;

  const CheckoutItemTile({Key? key, required this.cartItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final subtotal = cartItem.cartItemDetails!
        .map<int>((e) => e.quantity! * e.product!.price!)
        .reduce((value, element) => value + element);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${cartItem.seller!.name!} Store",
          style: theme.textTheme.titleMedium,
        ),
        SizedBox(height: 10),
        ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          separatorBuilder: (context, index) => Divider(
            thickness: 0,
            height: 20,
          ),
          itemCount: cartItem.cartItemDetails!.length,
          itemBuilder: (context, index) {
            final cartItemDetail = cartItem.cartItemDetails![index];
            return CheckoutItemDetailTile(cartItemDetail: cartItemDetail);
          },
        ),
        Divider(thickness: 0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Subtotal", style: theme.textTheme.bodyLarge),
            Text(
              rupiahFormatter.format(subtotal),
              style: theme.textTheme.titleMedium,
            ),
          ],
        )
      ],
    );
  }
}
