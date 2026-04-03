import 'package:flutter/material.dart';

enum RatingDecoration {
  veryDissatisfied(1, "Disappointed", Icons.sentiment_very_dissatisfied_rounded,
      "What makes you disappointed?"),
  dissatisfied(2, "Less Satisfied", Icons.sentiment_dissatisfied_rounded,
      "What makes you dislike it?"),
  neutral(
      3, "Just OK", Icons.sentiment_neutral_rounded, "What could be improved?"),
  satisfied(4, "Like It", Icons.sentiment_satisfied_rounded,
      "What do you like about it?"),
  verySatisfied(5, "Absolutely Love It!!!",
      Icons.sentiment_very_satisfied_rounded, "What makes you satisfied?");

  const RatingDecoration(
      this.rating, this.description, this.icon, this.question);

  final String description;
  final int rating;
  final IconData icon;
  final String question;

  static RatingDecoration fromRating(int rating) {
    return RatingDecoration.values
        .firstWhere((element) => element.rating == rating);
  }
}
