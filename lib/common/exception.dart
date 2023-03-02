import 'dart:async';

class ServerException implements Exception {
  final String message;

  ServerException(this.message);

  @override
  String toString() {
    return message;
  }
}

class ServerTimeoutException implements TimeoutException {
  final Duration? duration;

  ServerTimeoutException(this.duration);

  @override
  final String message = "Tocopedia Server error. Please try again later.";

  @override
  String toString() {
    return message;
  }
}
