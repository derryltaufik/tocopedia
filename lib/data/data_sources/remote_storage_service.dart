import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:tocopedia/common/env_variables.dart';

abstract class RemoteStorageService {
  Future<String> uploadImage(File imageFile, {String? folderName});
}

class RemoteStorageServiceImpl implements RemoteStorageService {
  @override
  Future<String> uploadImage(File imageFile, {String? folderName}) async {
    try {
      final cloudinary =
          CloudinaryPublic(CLOUDINARY_CLOUD_NAME, CLOUDINARY_UPLOAD_PRESET);

      CloudinaryResponse response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(imageFile.path, folder: folderName),
      );
      return response.secureUrl;
    } catch (e) {
      rethrow;
    }
  }
}
