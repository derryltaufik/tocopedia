import 'package:flutter/material.dart';

class OrderItemActionButton extends StatelessWidget {
  const OrderItemActionButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(1),
            spreadRadius: 2,
            blurRadius: 2,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: FilledButton(
              style: FilledButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.titleMedium),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Text("Review Product"),
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}