import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tocopedia/common/constants.dart';
import 'package:tocopedia/domains/entities/order_item_detail.dart';
import 'package:tocopedia/presentation/pages/features/product/view_product_page.dart';
import 'package:tocopedia/presentation/providers/cart_provider.dart';

class SingleOrderItemDetailCard extends StatelessWidget {
  final OrderItemDetail orderItemDetail;

  const SingleOrderItemDetailCard({Key? key, required this.orderItemDetail})
      : super(key: key);

  Future<void> addToCart(BuildContext context) async {
    ScaffoldMessenger.of(context).clearSnackBars();
    try {
      await Provider.of<CartProvider>(context, listen: false)
          .addToCart(orderItemDetail.product!.id!);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Item successfully added to your cart"),
          behavior: SnackBarBehavior.floating,
        ));
      }
    } on Exception catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.toString()),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(ViewProductPage.routeName,
          arguments: orderItemDetail.product!.id!),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
          ),
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                        imageUrl: orderItemDetail.productImage!,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          orderItemDetail.productName!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleMedium,
                        ),
                        Text(
                          "${orderItemDetail.quantity} x ${rupiahFormatter.format(orderItemDetail.productPrice!)}",
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Divider(
                thickness: 0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Total Price",
                        style: theme.textTheme.bodySmall,
                      ),
                      Text(
                        rupiahFormatter.format(orderItemDetail.quantity! *
                            orderItemDetail.productPrice!),
                        style: theme.textTheme.titleSmall,
                      ),
                    ],
                  ),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        side: BorderSide(color: theme.primaryColor),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        minimumSize: Size.zero,
                        padding: EdgeInsets.all(7)),
                    onPressed: () => addToCart(context),
                    child: Text("Buy Again"),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
