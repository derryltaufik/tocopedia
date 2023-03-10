import 'package:flutter/material.dart';
import 'package:tocopedia/presentation/pages/features/order/view_all_orders_page.dart';

class WaitingPaymentCard extends StatelessWidget {
  const WaitingPaymentCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () => Navigator.of(context).pushNamed(ViewAllOrdersPage.routeName),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Theme.of(context).colorScheme.outline,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.payments_outlined, color: theme.primaryColor),
                  const SizedBox(width: 10),
                  Text("Waiting For Payment", style: theme.textTheme.bodyLarge),
                ],
              ),
              const Icon(Icons.arrow_forward_ios_rounded)
            ],
          ),
        ),
      ),
    );
  }
}
