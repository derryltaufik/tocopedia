import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tocopedia/common/constants.dart';
import 'package:tocopedia/domains/entities/order.dart';
import 'package:tocopedia/presentation/pages/features/order/view_order_page.dart';

class SingleOrderCard extends StatelessWidget {
  final Order order;

  const SingleOrderCard({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () => Navigator.of(context)
          .pushNamed(ViewOrderPage.routeName, arguments: order.id),
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
                            .format(order.createdAt!.toLocal()),
                        style: theme.textTheme.bodySmall!
                            .copyWith(color: Colors.black54),
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Pay Before",
                        style: theme.textTheme.bodySmall!
                            .copyWith(color: Colors.black54),
                      ),
                      Row(
                        children: [
                          Icon(Icons.schedule,
                              size: 15, color: theme.primaryColor),
                          SizedBox(width: 5),
                          Text(
                            DateFormat("d MMM, HH:mm").format(order.createdAt!
                                .add(const Duration(days: 1))
                                .toLocal()),
                            style: theme.textTheme.titleSmall!
                                .copyWith(color: theme.primaryColor),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
              Divider(),
              SizedBox(height: 10),
              Row(
                children: [
                  FlutterLogo(),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Tocopedia Pay",
                        style: theme.textTheme.titleMedium,
                      ),
                      Text(
                        order.id!
                            .substring(order.id!.length - 16)
                            .toUpperCase(),
                        style: theme.textTheme.bodyMedium!
                            .copyWith(color: Colors.black54),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Total Payment",
                    style: theme.textTheme.bodySmall,
                  ),
                  Text(
                    rupiahFormatter.format(order.totalPrice),
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
