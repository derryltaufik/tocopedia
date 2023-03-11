import 'dart:io';

import 'package:flutter/foundation.dart';

class PickImageProvider with ChangeNotifier {
  static const int size = 5;

  final List<String> _oldImages;
  final List<String> _deletedImages = [];
  final List<File> _newImages = [];

  PickImageProvider({List<String>? oldImages}) : _oldImages = oldImages ?? [];

  List<String> get oldImages => [..._oldImages];

  List<String> get deletedImages => [..._deletedImages];

  List<File> get newImages => [..._newImages];

  void addImage(File image) {
    try {
      if (_oldImages.length + _newImages.length >= size) return;
      _newImages.add(image);
      notifyListeners();
    } catch (e) {
      return;
    }
  }

  void removeImage(int index) {
    try {
      if (index < _oldImages.length) {
        _oldImages.removeAt(index);
      } else {
        _newImages.removeAt(index - _oldImages.length);
      }
      notifyListeners();
    } catch (e) {
      return;
    }
  }

  dynamic getImage(int index) {
    try {
      if (index < _oldImages.length) {
        return _oldImages[index];
      } else {
        return _newImages[index - _oldImages.length];
      }
    } catch (e) {
      return null;
    }
  }
}
