import 'package:flutter/material.dart';

enum Status {
  waitingConfirmation("waiting confirmation", Colors.lightGreen),
  processing("processing", Colors.lightGreen),
  sent("sent", Colors.lightGreen),
  arrivedAtDestination("arrived at destination", Colors.lightGreen),
  completed("completed", Colors.green),
  cancelled("cancelled", Colors.red),
  refunded("refunded", Colors.red),
  unpaid("unpaid", Colors.grey);

  const Status(this.description, this.color);

  final String description;
  final Color color;

  static fromString(String status) {
    return Status.values.firstWhere((element) => element.description == status);
  }
}
