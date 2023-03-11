import 'package:flutter/material.dart';

enum AppMode {
  buyer,
  seller,
}

class LocalSettingsProvider with ChangeNotifier {
  AppMode _appMode = AppMode.buyer;

  AppMode get appMode => _appMode;

  void switchToBuyerMode() {
    _appMode = AppMode.buyer;
    notifyListeners();
  }

  void switchToSellerMode() {
    _appMode = AppMode.seller;
    notifyListeners();
  }
}
