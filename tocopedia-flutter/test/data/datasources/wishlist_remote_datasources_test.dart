import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:tocopedia/data/data_sources/wishlist_remote_data_source.dart';

void main() {
  late WishlistRemoteDataSource dataSource;

  setUp(() {
    dataSource = WishlistRemoteDataSourceImpl(client: http.Client());
  });

  group("Add Wishlist", () {
    test('rthrtgrtegrt', () async {
      try {
        final result = await dataSource.addWishlist(
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2M2Y4NWVhY2FmOWI1YzdiMTEwZGNkNzEiLCJpYXQiOjE2Nzc0MzM3NjB9.MealAy8BzsTwODeoezmAC5d4bqJhIaPt9LGsbJatD3E",
          "63f85eb0af9b5c7b110dcdbf",
        );
        print(result.toString());
      } on SocketException catch (e) {
        print(e);
      } on Exception catch (e) {
        print(e);
      }
    });
  });

  group("Delete Wishlist", () {
    test('rthrtgrtegrt', () async {
      try {
        final result = await dataSource.deleteWishlist(
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2M2Y4NWVhY2FmOWI1YzdiMTEwZGNkNzEiLCJpYXQiOjE2Nzc0MzM3NjB9.MealAy8BzsTwODeoezmAC5d4bqJhIaPt9LGsbJatD3E",
          "63f85eb0af9b5c7b110dcdbf",
        );
        print(result.toString());
      } on SocketException catch (e) {
        print(e);
      } on Exception catch (e) {
        print(e);
      }
    });
  });
  group("Get Wishlist", () {
    test('rthrtgergtrtgrt', () async {
      try {
        final result = await dataSource.getWishlist(
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2M2Y4NWVhY2FmOWI1YzdiMTEwZGNkNzEiLCJpYXQiOjE2Nzc0MzM3NjB9.MealAy8BzsTwODeoezmAC5d4bqJhIaPt9LGsbJatD3E",
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
