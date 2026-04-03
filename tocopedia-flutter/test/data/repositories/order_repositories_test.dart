import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:tocopedia/data/data_sources/order_remote_data_source.dart';
import 'package:tocopedia/data/repositories/order_repository_impl.dart';

void main() {
  late OrderRepositoryImpl repository;

  setUp(() {
    repository = OrderRepositoryImpl(
        remoteDataSource: OrderRemoteDataSourceImpl(client: http.Client()));
  });

  group("Get Order", () {
    test('should return User Model when the response code is 200', () async {
      try {
        final result = await repository.getOrder(
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2M2YwODI4YWU2NmI0Y2MzOGY2MTdiYmMiLCJpYXQiOjE2NzY3MDY0NDJ9.F_plMkhTpZ65Ge-f38FR4w3kpHubDzZttLXt4toViu0",
          "63f0ea1316a77b2e22ceec0b",
        );
        print(result.address!.receiverName!);
      } catch (e) {
        rethrow;
      }
    });
  });
}
