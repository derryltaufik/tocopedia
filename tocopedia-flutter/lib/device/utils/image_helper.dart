import 'dart:io';

import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageHelper {
  static Future<File?> getAndCropImage(
      {ImageSource imageSource = ImageSource.gallery}) async {
    var image = await _getImage(imageSource: imageSource);
    if (image != null) {
      image = await _cropImage(imageFile: image);
    }
    return image;
  }

  static Future<File?> _getImage(
      {ImageSource imageSource = ImageSource.gallery}) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: imageSource);
    if (pickedImage != null) {
      final image = File(pickedImage.path.toString());
      // print("${image.lengthSync() / 1024} KB");

      return image;
    }
    return null;
  }

  static Future<File?> _cropImage({required File imageFile}) async {
    var croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      compressFormat: ImageCompressFormat.jpg,
      maxWidth: 900,
      maxHeight: 900,
    );
    if (croppedFile != null) {
      final image = File(croppedFile.path);
      // print("${image.lengthSync() / 1024} KB");
      return image;
    }

    return null;
  }
}
