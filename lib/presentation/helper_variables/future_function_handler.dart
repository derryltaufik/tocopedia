import 'package:flutter/material.dart';
import 'package:tocopedia/presentation/pages/common_widgets/custom_snack_bar.dart';
import 'package:tocopedia/presentation/pages/common_widgets/loading_dialog.dart';

Future<void> handleFutureFunction(
  BuildContext context, {
  required Future function,
  String? loadingMessage,
  String? successMessage,
  Function()? onSuccess,
  Function()? onException,
  Function()? onFinished,
}) async {
  showLoadingDialog(context, message: loadingMessage);
  try {
    await function;
    if (context.mounted) {
      showCustomSnackBar(context, message: successMessage ?? "Success");
    }
    if (onSuccess != null) await onSuccess();
  } on Exception catch (e) {
    showCustomSnackBar(context, message: e.toString(), color: Colors.red);
    if (onException != null) await onException();
  }
  if (context.mounted) {
    Navigator.of(context).pop();
  }
  if (onFinished != null) await onFinished();
}
