import 'package:flutter/material.dart';
import 'package:tocopedia/presentation/helper_variables/string_extension.dart';

class OrderStatusCard extends StatelessWidget {
  final String text;
  final Color color;

  const OrderStatusCard({Key? key, required this.text, required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: color.withOpacity(0.2),
      ),
      child: Text(
        text.toTitleCase(),
        style: theme.textTheme.bodySmall!
            .copyWith(fontWeight: FontWeight.bold, color: color),
      ),
    );
  }
}
