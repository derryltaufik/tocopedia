import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:tocopedia/data/data_sources/address_remote_data_source.dart';
import 'package:http/http.dart' as http;

void main() {
  late AddressRemoteDataSource dataSource;

  setUp(() {
    dataSource = AddressRemoteDataSourceImpl(client: http.Client());
  });

  group("Add address", () {
    test('rthrtgrtegrt', () async {
      try {
        final result = await dataSource.addAddress(
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2M2Y4NWVhY2FmOWI1YzdiMTEwZGNkNzEiLCJpYXQiOjE2NzcyMjE1NDh9.2MnBayyf6DxuLE7FIySdmXp6D5RDMqOdpl-z2P6y9po",
          completeAddress: 'Jl. Alternatif',
          receiverName: 'Mario Satrio',
          receiverPhone: '08146467878',
        );
        print(result.toString());
      } on SocketException catch (e) {
        print(e);
      } on Exception catch (e) {
        print(e);
      }
    });
  });

  group("Update address", () {
    test('hrthrthtr', () async {
      try {
        final result = await dataSource.updateAddress(
            "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2M2Y4NWVhY2FmOWI1YzdiMTEwZGNkNzEiLCJpYXQiOjE2NzcyMjE1NDh9.2MnBayyf6DxuLE7FIySdmXp6D5RDMqOdpl-z2P6y9po",
            "63fb69eec9c6e15bade9a738",
            completeAddress: 'Jl. Alternatif updated',
            receiverName: 'Mario Satrio updated',
            receiverPhone: '08146467878',
            label: "ini label",
            notes: "belok kiri belok kanan");
        print(result.toString());
      } on SocketException catch (e) {
        print(e);
      } on Exception catch (e) {
        print(e);
      }
    });
  });

  group("get addresses", () {
    test('gegerger', () async {
      try {
        final results = await dataSource.getUserAddresses(
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2M2Y4NWVhY2FmOWI1YzdiMTEwZGNkNzEiLCJpYXQiOjE2NzcyMjE1NDh9.2MnBayyf6DxuLE7FIySdmXp6D5RDMqOdpl-z2P6y9po",
        );
        print(results.toString());
      } on SocketException catch (e) {
        print(e);
      } on Exception catch (e) {
        print(e);
      }
    });
  });

  group("get address", () {
    test('rbrgbrfgreg', () async {
      try {
        final results = await dataSource.getAddress(
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2M2Y4NWVhY2FmOWI1YzdiMTEwZGNkNzEiLCJpYXQiOjE2NzcyMjE1NDh9.2MnBayyf6DxuLE7FIySdmXp6D5RDMqOdpl-z2P6y9po",
          "63f85eaeaf9b5c7b110dcd96",
        );
        print(results.toString());
      } on SocketException catch (e) {
        print(e);
      } on Exception catch (e) {
        print(e);
      }
    });
  });

  group("delete address", () {
    test('hrtrtgtr', () async {
      try {
        final results = await dataSource.deleteAddress(
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2M2Y4NWVhY2FmOWI1YzdiMTEwZGNkNzEiLCJpYXQiOjE2NzcyMjE1NDh9.2MnBayyf6DxuLE7FIySdmXp6D5RDMqOdpl-z2P6y9po",
          "63fb6d53573d73606e81e5f2",
        );
        print(results.toString());
      } on SocketException catch (e) {
        print(e);
      } on Exception catch (e) {
        print(e);
      }
    });
  });
}
