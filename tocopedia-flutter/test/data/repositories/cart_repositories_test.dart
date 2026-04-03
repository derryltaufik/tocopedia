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
    test('should dfsdfsd0', () async {
      try {
        final result = await repository.getCart(
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2M2YyMjcwYjM0MjE1MDdhNTlmZjgyZDMiLCJpYXQiOjE2NzY4MTQwOTJ9.9bPeBjcKnIisAeZw-S7FJnglx2c19vgZHddCF1W1OS0",
        );
        print(result.cartItems[0].cartItemDetails![0]);
      } catch (e) {
        rethrow;
      }
    });
  });
}
