import 'package:flutter/material.dart';

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';

  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
}

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
