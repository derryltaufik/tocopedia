import 'dart:convert';
import 'dart:ui';
import 'package:http/http.dart';

void responseHandler({
  required Response response,
  required VoidCallback onSuccess,
}) {
  final int status = response.statusCode;
  if (status >= 200 && status < 300) {
    onSuccess();
  } else {
    throw json.decode(response.body)["error"];
  }
}
