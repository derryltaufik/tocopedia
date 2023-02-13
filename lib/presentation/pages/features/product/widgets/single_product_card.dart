import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tocopedia/domains/entities/product.dart';
import 'package:tocopedia/presentation/pages/features/product/view_product_page.dart';

class SingleProductCard extends StatelessWidget {
  const SingleProductCard({Key? key, required this.product}) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.of(context)
            .pushNamed(ViewProductPage.routeName, arguments: product.id),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1 / 1,
              child: Image.network(
                product.images[0],
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name,
                      maxLines: 2, overflow: TextOverflow.ellipsis),
                  SizedBox(height: 3),
                  Text(
                    NumberFormat.currency(
                            decimalDigits: 0, locale: "id_ID", symbol: "Rp")
                        .format(product.price),
                    style: theme.textTheme.titleMedium!
                        .copyWith(fontWeight: FontWeight.w700, fontSize: 17),
                  ),
                  SizedBox(height: 3),
                  IntrinsicHeight(
                    child: Row(
                      children: [
                        if (product.averageRating != null) ...[
                          Icon(
                            Icons.star_rounded,
                            color: theme.primaryColor,
                          ),
                          Text(
                            product.averageRating!.toStringAsFixed(1),
                            style: theme.textTheme.bodyMedium!
                                .copyWith(color: Colors.black54),
                          ),
                          VerticalDivider(
                            indent: 6,
                            endIndent: 6,
                          ),
                        ],
                        if (product.totalSold > 0)
                          Text(
                            "Sold ${NumberFormat.compact().format(product.totalSold)}",
                            style: theme.textTheme.bodyMedium!
                                .copyWith(color: Colors.black54),
                          ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
