import 'package:flutter_test/flutter_test.dart';
import 'package:tocopedia/data/data_sources/address_remote_data_source.dart';
import 'package:http/http.dart' as http;
import 'package:tocopedia/data/repositories/address_repository_impl.dart';
import 'package:tocopedia/domains/repositories/address_repository.dart';

void main() {
  late AddressRepository repository;

  setUp(() {
    repository = AddressRepositoryImpl(
        remoteDataSource: AddressRemoteDataSourceImpl(client: http.Client()));
  });

  group("Get User Addresses", () {
    test('should return User Model when the response code is 200', () async {
      try {
        final results = await repository.getUserAddresses(
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2M2Y4NWVhY2FmOWI1YzdiMTEwZGNkNzEiLCJpYXQiOjE2NzcyMjE1NDh9.2MnBayyf6DxuLE7FIySdmXp6D5RDMqOdpl-z2P6y9po",
        );
        print(results[0].toString());
      } catch (e) {
        rethrow;
      }
    });
  });
}
