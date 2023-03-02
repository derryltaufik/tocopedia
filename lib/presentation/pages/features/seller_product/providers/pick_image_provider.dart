import 'dart:io';

import 'package:flutter/foundation.dart';

class PickImageProvider with ChangeNotifier {
  static const int size = 5;
  final List<File> _images = [];

  List<File> get images => [..._images];

  void addImage(File image) {
    try {
      _images.add(image);
      notifyListeners();
    } catch (e) {
      return;
    }
  }

  void removeImage(int index) {
    try {
      _images.removeAt(index);
      notifyListeners();
    } catch (e) {
      return;
    }
  }

  File? getImage(int index) {
    try {
      return _images[index];
    } catch (e) {
      return null;
    }
  }
}
