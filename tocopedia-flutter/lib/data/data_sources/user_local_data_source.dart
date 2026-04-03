import 'package:shared_preferences/shared_preferences.dart';

abstract class UserLocalDataSource {
  Future<void> saveToken(String token);

  Future<String?> retrieveToken();

  Future<void> deleteToken();
}

class UserLocalDataSourceImpl implements UserLocalDataSource {
  @override
  Future<void> saveToken(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
    } on Exception {
      rethrow;
    }
  }

  @override
  Future<String?> retrieveToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');
      return token;
    } on Exception {
      rethrow;
    }
  }

  @override
  Future<void> deleteToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');
    } on Exception {
      rethrow;
    }
  }
}
