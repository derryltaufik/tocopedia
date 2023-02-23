import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tocopedia/common/constants.dart';
import 'package:tocopedia/domains/entities/order_item.dart';
import 'package:tocopedia/presentation/helper_variables/order_item_status_enum.dart';
import 'package:tocopedia/presentation/pages/features/transaction/view_order_item_page.dart';
import 'package:tocopedia/presentation/pages/features/transaction/widgets/order_status_card.dart';

class SingleOrderItemCard extends StatelessWidget {
  final OrderItem orderItem;

  const SingleOrderItemCard({Key? key, required this.orderItem})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusEnum = Status.fromString(orderItem.status!);
    return GestureDetector(
      onTap: () => Navigator.of(context)
          .pushNamed(ViewOrderItemPage.routeName, arguments: orderItem.id),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Ordered on", style: theme.textTheme.titleSmall),
                      Text(
                        DateFormat("d MMM y")
                            .format(orderItem.createdAt!.toLocal()),
                        style: theme.textTheme.bodySmall!
                            .copyWith(color: Colors.black54),
                      )
                    ],
                  ),
                  OrderStatusCard(
                      text: orderItem.status!, color: statusEnum.color),
                ],
              ),
              Divider(),
              SizedBox(height: 5),
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                        imageUrl: orderItem.products![0].productImage!,
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
                          orderItem.products![0].productName!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleMedium,
                        ),
                        Text(
                          "${orderItem.products![0].quantity!} item(s)",
                          style: theme.textTheme.bodyMedium!
                              .copyWith(color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              if (orderItem.products!.length > 1) ...[
                Text("+ ${orderItem.products!.length - 1} other product(s)"),
                SizedBox(height: 10),
              ],
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Total Expense",
                    style: theme.textTheme.bodySmall,
                  ),
                  Text(
                    rupiahFormatter.format(orderItem.subtotal!),
                    style: theme.textTheme.titleSmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
