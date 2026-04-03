import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:tocopedia/data/data_sources/order_remote_data_source.dart';

void main() {
  late OrderRemoteDataSourceImpl dataSource;

  setUp(() {
    dataSource = OrderRemoteDataSourceImpl(client: http.Client());
  });

  group("Get Order", () {
    test('shergregreg', () async {
      try {
        final result = await dataSource.getOrder(
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2M2YwODI4YWU2NmI0Y2MzOGY2MTdiYmMiLCJpYXQiOjE2NzY3MDY0NDJ9.F_plMkhTpZ65Ge-f38FR4w3kpHubDzZttLXt4toViu0",
          "63f08b4e0b4f7671896c542c",
        );
        print(result.toString());
      } on SocketException catch (e) {
        print(e);
      } on Exception catch (e) {
        print(e);
      }
    });
  });
  group("Get User Orders", () {
    test('shergreggdfgreg', () async {
      try {
        final result = await dataSource.getUserOrders(
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2M2YwODI4YWU2NmI0Y2MzOGY2MTdiYmMiLCJpYXQiOjE2NzY3MDY0NDJ9.F_plMkhTpZ65Ge-f38FR4w3kpHubDzZttLXt4toViu0",
        );
        print(result);
      } on SocketException catch (e) {
        print(e);
      } on Exception catch (e) {
        print(e);
      }
    });
  });
  group("Checkout", () {
    test('gergetrh', () async {
      try {
        final result = await dataSource.checkout(
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2M2YwODI4YWU2NmI0Y2MzOGY2MTdiYmMiLCJpYXQiOjE2NzY3MDY0NDJ9.F_plMkhTpZ65Ge-f38FR4w3kpHubDzZttLXt4toViu0",
          "63f08325458724b198567aec",
        );
        print(result.toString());
      } on SocketException catch (e) {
        print(e);
      } on Exception catch (e) {
        print(e);
      }
    });
  });

  group("Pay Order", () {
    test('gergerhrh', () async {
      try {
        final result = await dataSource.payOrder(
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2M2YwODI4YWU2NmI0Y2MzOGY2MTdiYmMiLCJpYXQiOjE2NzY3MDY0NDJ9.F_plMkhTpZ65Ge-f38FR4w3kpHubDzZttLXt4toViu0",
          "63f0ea1316a77b2e22ceec0b",
        );
        print(result.toString());
      } on SocketException catch (e) {
        print(e);
      } on Exception catch (e) {
        print(e);
      }
    });
  });

  group("Cancel Order", () {
    test('gerergregerhrh', () async {
      try {
        final result = await dataSource.cancelOrder(
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2M2YwODI4YWU2NmI0Y2MzOGY2MTdiYmMiLCJpYXQiOjE2NzY3MDY0NDJ9.F_plMkhTpZ65Ge-f38FR4w3kpHubDzZttLXt4toViu0",
          "63f0ec1116a77b2e22ceec5d",
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
