import 'package:flutter/material.dart';

void showCustomSnackBar(BuildContext context,
    {required String message, Color? color}) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
      backgroundColor: color,
    ),
  );
}
