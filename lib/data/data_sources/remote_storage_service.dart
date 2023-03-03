import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';

abstract class RemoteStorageService {
  Future<String> uploadImage(File imageFile, {String? folderName});
}

class RemoteStorageServiceImpl implements RemoteStorageService {
  @override
  Future<String> uploadImage(File imageFile, {String? folderName}) async {
    const cloudinaryCloudName = String.fromEnvironment('CLOUDINARY_CLOUD_NAME');
    const cloudinaryUploadPreset =
        String.fromEnvironment('CLOUDINARY_UPLOAD_PRESET');
    try {
      final cloudinary =
          CloudinaryPublic(cloudinaryCloudName, cloudinaryUploadPreset);

      CloudinaryResponse response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(imageFile.path, folder: folderName),
      );
      return response.secureUrl;
    } catch (e) {
      rethrow;
    }
  }
}
