import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:tocopedia/data/data_sources/cart_remote_data_source.dart';
import 'package:http/http.dart' as http;

void main() {
  late CartRemoteDataSourceImpl dataSource;

  setUp(() {
    dataSource = CartRemoteDataSourceImpl(client: http.Client());
  });

  group("Get Cart", () {
    test('get cart', () async {
      try {
        final result = await dataSource.getCart(
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2M2YyMjcwYjM0MjE1MDdhNTlmZjgyZDMiLCJpYXQiOjE2NzY4MTQwOTJ9.9bPeBjcKnIisAeZw-S7FJnglx2c19vgZHddCF1W1OS0",
        );
        print(result.toString());
      } on SocketException catch (e) {
        print(e);
      } on Exception catch (e) {
        print(e);
      }
    });
  });

  group("Add to cart", () {
    test('should return User Model when the response code is 200', () async {
      try {
        final result = await dataSource.addToCart(
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2M2U5MWNiY2NiMzE5OWQyNTQ1NTBiM2IiLCJpYXQiOjE2NzYyMjE2Mjh9.ITiQgXN-72cJl6sSj1KW9c_aCQQ50SB_zDaLvEEMKt0",
          "63e91cbfcb3199d254550b7f",
        );
        print(result.toString());
      } on SocketException catch (e) {
        print(e);
      } on Exception catch (e) {
        print(e);
      }
    });
  });
  group("Remove from cart", () {
    test('should return User Model when the response code is 200', () async {
      try {
        final result = await dataSource.removeFromCart(
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2M2U5MWNiY2NiMzE5OWQyNTQ1NTBiM2IiLCJpYXQiOjE2NzYyMjE2Mjh9.ITiQgXN-72cJl6sSj1KW9c_aCQQ50SB_zDaLvEEMKt0",
          "63e91cbfcb3199d254550b7f",
        );
        print(result.toString());
      } on SocketException catch (e) {
        print(e);
      } on Exception catch (e) {
        print(e);
      }
    });
  });
  group("Update cart", () {
    test('gergregerr', () async {
      try {
        final result = await dataSource.updateCart(
            "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2M2U5MWNiY2NiMzE5OWQyNTQ1NTBiM2IiLCJpYXQiOjE2NzYyMjE2Mjh9.ITiQgXN-72cJl6sSj1KW9c_aCQQ50SB_zDaLvEEMKt0",
            "63e91cbfcb3199d254550b7f",
            100);
        print(result.toString());
      } on SocketException catch (e) {
        print(e);
      } on Exception catch (e) {
        print(e);
      }
    });
  });
  // group("Clear cart", () {
  //   test('egregregregr', () async {
  //     try {
  //       final result = await dataSource.clearCart(
  //         "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2M2U5MWNiY2NiMzE5OWQyNTQ1NTBiM2IiLCJpYXQiOjE2NzYyMjE2Mjh9.ITiQgXN-72cJl6sSj1KW9c_aCQQ50SB_zDaLvEEMKt0",
  //       );
  //       print(result.toString());
  //     } on SocketException catch (e) {
  //       print(e);
  //     } on Exception catch (e) {
  //       print(e);
  //     }
  //   });
  // });
}
