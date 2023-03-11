import 'package:flutter/material.dart';
import 'package:tocopedia/presentation/pages/common_widgets/custom_snack_bar.dart';
import 'package:tocopedia/presentation/pages/common_widgets/loading_dialog.dart';

Future<dynamic> handleFutureFunction(
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
    final result = await function;

    if (context.mounted) {
      Navigator.of(context).pop();
      showCustomSnackBar(context, message: successMessage ?? "Success");
    }
    if (onSuccess != null) await onSuccess();
    return result;
  } on Exception catch (e) {
    if (context.mounted) {
      Navigator.of(context).pop();
      showCustomSnackBar(context, message: e.toString(), color: Colors.red);
    }
    if (onException != null) await onException();
  } finally {
    if (onFinished != null) await onFinished();
  }
}
