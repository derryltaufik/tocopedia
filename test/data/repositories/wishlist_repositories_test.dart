import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:tocopedia/data/data_sources/wishlist_remote_data_source.dart';
import 'package:tocopedia/data/repositories/wishlist_repository_impl.dart';
import 'package:tocopedia/domains/repositories/wishlist_repository.dart';

void main() {
  late WishlistRepository repository;

  setUp(() {
    repository = WishlistRepositoryImpl(
        remoteDataSource: WishlistRemoteDataSourceImpl(client: http.Client()));
  });

  group("Get User wishlist", () {
    test('should return User Model when the response code is 200', () async {
      try {
        final results = await repository.getWishlist(
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2M2Y4NWVhY2FmOWI1YzdiMTEwZGNkNzEiLCJpYXQiOjE2Nzc0MzM3NjB9.MealAy8BzsTwODeoezmAC5d4bqJhIaPt9LGsbJatD3E",
        );
        print(results.toString());
      } catch (e) {
        rethrow;
      }
    });
  });
}
