import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:tocopedia/data/data_sources/remote_storage_service.dart';

void main() {
  late RemoteStorageService dataSource;

  setUp(() {
    dataSource = RemoteStorageServiceImpl();
  });

  group("Upload Image", () {
    test('upload image cloudinary', () async {
      try {
        final result = await dataSource.uploadImage(File(""),folderName:  "test");
        print(result.toString());
      } on SocketException catch (e) {
        print(e);
      } on Exception catch (e) {
        print(e);
      }
    });
  });
}
