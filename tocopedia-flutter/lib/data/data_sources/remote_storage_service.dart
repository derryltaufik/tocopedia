import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:tocopedia/common/env_variables.dart';

abstract class RemoteStorageService {
  Future<String> uploadImage(String token, File imageFile);
}

class RemoteStorageServiceImpl implements RemoteStorageService {
  @override
  Future<String> uploadImage(String token, File imageFile) async {
    final uri = Uri.parse('$BASE_URL/upload');
    final request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..files.add(await http.MultipartFile.fromPath('image', imageFile.path));

    final streamedResponse =
        await request.send().timeout(const Duration(seconds: 30));
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode != 201) {
      final body = jsonDecode(response.body);
      throw Exception(body['error'] ?? 'Failed to upload image');
    }

    final body = jsonDecode(response.body);
    return body['data']['url'];
  }
}
