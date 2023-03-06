import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:tocopedia/data/data_sources/review_remote_data_source.dart';

void main() {
  late ReviewRemoteDataSource dataSource;

  setUp(() {
    dataSource = ReviewRemoteDataSourceImpl(client: http.Client());
  });

  group("Get Buyer Reviews", () {
    test('should return User Model when the response code is 200', () async {
      try {
        final result = await dataSource.getBuyerReviews(
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2NDA2MDM2MTJmMjc0NDEyZjE2ZmM0NDkiLCJpYXQiOjE2NzgxMTU2ODJ9.8gVUPh6X7CkVSIvyR5vrd3gov0uz0ym36a0YvnTjkig",
        );
        print(result.toString());
      } on SocketException catch (e) {
        print(e);
      } on Exception catch (e) {
        print(e);
      }
    });
  });
  group("Get Product Reviews", () {
    test('product review', () async {
      try {
        final result =
            await dataSource.getProductReviews("640603672f274412f16fc49a");
        print(result.toString());
      } on SocketException catch (e) {
        print(e);
      } on Exception catch (e) {
        print(e);
      }
    });
  });
  group("Get Seller Reviews", () {
    test('seller review', () async {
      try {
        final result =
            await dataSource.getSellerReviews("640603622f274412f16fc44f");
        print(result.toString());
      } on SocketException catch (e) {
        print(e);
      } on Exception catch (e) {
        print(e);
      }
    });
  });
}
