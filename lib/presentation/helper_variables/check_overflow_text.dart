import 'package:flutter/material.dart';

//https://stackoverflow.com/a/65408733
bool isTextOverflow(String text, TextStyle style,
    {double minWidth = 0,
    double maxWidth = double.infinity,
    int maxLines = 2}) {
  final TextPainter textPainter = TextPainter(
    text: TextSpan(text: text, style: style),
    maxLines: maxLines,
    textDirection: TextDirection.ltr,
  )..layout(minWidth: minWidth, maxWidth: maxWidth);
  return textPainter.didExceedMaxLines;
}
