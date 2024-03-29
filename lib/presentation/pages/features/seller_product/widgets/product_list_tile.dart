import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tocopedia/presentation/helper_variables/format_rupiah.dart';
import 'package:tocopedia/domains/entities/product.dart';
import 'package:tocopedia/presentation/pages/common_widgets/status_card.dart';
import 'package:tocopedia/presentation/pages/features/seller_product/seller_edit_product_page.dart';
import 'package:tocopedia/presentation/pages/features/seller_product/widgets/edit_product_action_buttons.dart';

class ProductListTile extends StatelessWidget {
  final Product product;

  const ProductListTile({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final statusWidget = StatusCard(
        text: "${product.status}",
        color: product.status! == "active" ? Colors.green : Colors.grey);

    return GestureDetector(
      onTap: () => Navigator.of(context)
          .pushNamed(SellerEditProductPage.routeName, arguments: product),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 75,
                  height: 75,
                  clipBehavior: Clip.antiAlias,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(15)),
                  child: CachedNetworkImage(
                    imageUrl: product.images![0],
                    fit: BoxFit.cover,
                    progressIndicatorBuilder: (_, __, downloadProgress) =>
                        Center(
                            child: CircularProgressIndicator(
                                value: downloadProgress.progress)),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(product.name!, style: theme.textTheme.titleMedium),
                      Text(rupiahFormatter.format(product.price!)),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Text(
                            'Stock : ',
                            style: theme.textTheme.bodyMedium!
                                .copyWith(color: Colors.black54),
                          ),
                          Text("${product.stock}"),
                        ],
                      ),
                      const SizedBox(height: 5),
                      statusWidget,
                    ],
                  ),
                )
              ],
            ),
            EditProductActionButtons(product: product),
          ],
        ),
      ),
    );
  }
}
