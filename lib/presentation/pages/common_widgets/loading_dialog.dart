import 'package:flutter/material.dart';

void showLoadingDialog(BuildContext context, {String? message}) {
  showDialog(
    context: context,
    builder: (context) =>
        message == null ? const LoadingDialog() : LoadingDialog(message: message),
  );
}

class LoadingDialog extends StatelessWidget {
  final String? message;

  const LoadingDialog({
    super.key,
    this.message = "Loading...",
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(
              height: 15,
            ),
            Text(message ?? "Loading..."),
          ],
        ),
      ),
    );
  }
}
