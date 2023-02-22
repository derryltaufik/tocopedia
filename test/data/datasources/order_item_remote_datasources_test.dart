import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:tocopedia/data/data_sources/order_item_remote_data_source.dart';

void main() {
  late OrderItemRemoteDataSourceImpl dataSource;

  setUp(() {
    dataSource = OrderItemRemoteDataSourceImpl(client: http.Client());
  });

  // group("Get Order", () {
  //   test('shergregreg', () async {
  //     try {
  //       final result = await dataSource.getOrder(
  //         "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2M2YwODI4YWU2NmI0Y2MzOGY2MTdiYmMiLCJpYXQiOjE2NzY3MDY0NDJ9.F_plMkhTpZ65Ge-f38FR4w3kpHubDzZttLXt4toViu0",
  //         "63f08b4e0b4f7671896c542c",
  //       );
  //       print(result.toString());
  //     } on SocketException catch (e) {
  //       print(e);
  //     } on Exception catch (e) {
  //       print(e);
  //     }
  //   });
  // });
  group("Get Buyer Orders", () {
    test('adfgdfhdffdgd', () async {
      try {
        final result = await dataSource.getBuyerOrderItems(
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

  group("Get Seller Orders", () {
    test('htrhrttrhtr', () async {
      try {
        final result = await dataSource.getSellerOrderItems(
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2M2YyMjcwYzM0MjE1MDdhNTlmZjgyZDkiLCJpYXQiOjE2NzY4MTQwOTJ9.6m9OpDalz23yo5H-WM08cK4qBMMcU-6zU6KfVsyBFZU",
        );
        print(result.toString());
      } on SocketException catch (e) {
        print(e);
      } on Exception catch (e) {
        print(e);
      }
    });
  });

  group("Get Order Item", () {
    test('htrhtrhtr', () async {
      try {
        final result = await dataSource.getOrderItem(
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2M2YyMjcwYjM0MjE1MDdhNTlmZjgyZDMiLCJpYXQiOjE2NzY4MTQwOTJ9.9bPeBjcKnIisAeZw-S7FJnglx2c19vgZHddCF1W1OS0",
          "63f4e6bbb4ff428d1268a595",
        );
        print(result.toString());
      } on SocketException catch (e) {
        print(e);
      } on Exception catch (e) {
        print(e);
      }
    });
  });

  group("Process Order Item", () {
    test('gfdgdfrehrere', () async {
      try {
        final result = await dataSource.processOrderItem(
          // "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2M2YyMjcwYjM0MjE1MDdhNTlmZjgyZDMiLCJpYXQiOjE2NzY4MTQwOTJ9.9bPeBjcKnIisAeZw-S7FJnglx2c19vgZHddCF1W1OS0",
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2M2YyMjcwYzM0MjE1MDdhNTlmZjgyZDkiLCJpYXQiOjE2NzY4MTQwOTJ9.6m9OpDalz23yo5H-WM08cK4qBMMcU-6zU6KfVsyBFZU",
          "63f62ccf69dc8b92161b160e",
        );
        print(result.toString());
      } on SocketException catch (e) {
        print(e);
      } on Exception catch (e) {
        print(e);
      }
    });
  });

  group("Send Order Item", () {
    test('hrhthrthtrrth', () async {
      try {
        final result = await dataSource.sendOrderItem(
          // "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2M2YyMjcwYjM0MjE1MDdhNTlmZjgyZDMiLCJpYXQiOjE2NzY4MTQwOTJ9.9bPeBjcKnIisAeZw-S7FJnglx2c19vgZHddCF1W1OS0",
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2M2YyMjcwYzM0MjE1MDdhNTlmZjgyZDkiLCJpYXQiOjE2NzY4MTQwOTJ9.6m9OpDalz23yo5H-WM08cK4qBMMcU-6zU6KfVsyBFZU",
          "63f62ccf69dc8b92161b160e",
          airwaybill: "JT423432",
        );
        print(result.toString());
      } on SocketException catch (e) {
        print(e);
      } on Exception catch (e) {
        print(e);
      }
    });
  });

  group("Complete Order Item", () {
    test('grergregre', () async {
      try {
        final result = await dataSource.completeOrderItem(
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2M2YyMjcwYjM0MjE1MDdhNTlmZjgyZDMiLCJpYXQiOjE2NzY4MTQwOTJ9.9bPeBjcKnIisAeZw-S7FJnglx2c19vgZHddCF1W1OS0",
          // "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2M2YyMjcwYzM0MjE1MDdhNTlmZjgyZDkiLCJpYXQiOjE2NzY4MTQwOTJ9.6m9OpDalz23yo5H-WM08cK4qBMMcU-6zU6KfVsyBFZU",
          "63f62ccf69dc8b92161b160e",
        );
        print(result.toString());
      } on SocketException catch (e) {
        print(e);
      } on Exception catch (e) {
        print(e);
      }
    });
  });
}
