import 'package:flutter_test/flutter_test.dart';
import 'package:tocopedia/data/data_sources/cart_remote_data_source.dart';
import 'package:http/http.dart' as http;
import 'package:tocopedia/data/repositories/cart_repository_impl.dart';

void main() {
  late CartRepositoryImpl repository;

  setUp(() {
    repository = CartRepositoryImpl(
        remoteDataSource: CartRemoteDataSourceImpl(client: http.Client()));
  });

  group("Get Cart", () {
    test('should return User Model when the response code is 200', () async {
      try {
        final result = await repository.getCart(
            "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2M2VlNDcyNTE4MDQxZjQ5NmIwYjA3NmEiLCJpYXQiOjE2NzY1NjAxNjV9.XUx8gQaHroW9XSfbjtQixtEBdtSc96Mvc5PIh3BBg8k");

        print(result.cartItems[0].quantity);
      } catch (e) {
        rethrow;
      }
    });
  });
}
