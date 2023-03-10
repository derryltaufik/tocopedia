import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tocopedia/presentation/helper_variables/format_rupiah.dart';
import 'package:tocopedia/domains/entities/order_item_detail.dart';
import 'package:tocopedia/presentation/helper_variables/future_function_handler.dart';
import 'package:tocopedia/presentation/pages/features/product/view_product_page.dart';
import 'package:tocopedia/presentation/providers/cart_provider.dart';
import 'package:tocopedia/presentation/providers/local_settings_provider.dart';

class SingleOrderItemDetailCard extends StatelessWidget {
  final OrderItemDetail orderItemDetail;

  const SingleOrderItemDetailCard({Key? key, required this.orderItemDetail})
      : super(key: key);

  Future<void> addToCart(BuildContext context) async {
    await handleFutureFunction(
      context,
      loadingMessage: "adding item to cart...",
      successMessage: "Item successfully added to your cart",
      function: Provider.of<CartProvider>(context, listen: false)
          .addToCart(orderItemDetail.product!.id!),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isBuyerMode =
        Provider.of<LocalSettingsProvider>(context, listen: false).appMode ==
            AppMode.buyer;
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
                  const SizedBox(width: 10),
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
              const Divider(
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
                  if (isBuyerMode)
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          side: BorderSide(color: theme.primaryColor),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          minimumSize: Size.zero,
                          padding: const EdgeInsets.all(7)),
                      onPressed: () => addToCart(context),
                      child: const Text("Buy Again"),
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
