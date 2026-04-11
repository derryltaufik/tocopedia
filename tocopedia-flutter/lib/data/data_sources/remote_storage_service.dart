import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:tocopedia/common/env_variables.dart';

abstract class RemoteStorageService {
  Future<String> uploadImage(String token, File imageFile);
}

class RemoteStorageServiceImpl implements RemoteStorageService {
  final http.Client client;

  RemoteStorageServiceImpl({required this.client});

  @override
  Future<String> uploadImage(String token, File imageFile) async {
    // Step 1: Get presigned URL from backend
    final extension = _getExtension(imageFile.path);
    final contentType = _getContentType(extension);

    final presignUri = Uri.parse('$baseUrl/upload/presign').replace(
      queryParameters: {
        'contentType': contentType,
        'extension': extension,
      },
    );

    final presignResponse = await client
        .get(presignUri, headers: {'Authorization': 'Bearer $token'}).timeout(
            const Duration(seconds: 10));

    if (presignResponse.statusCode != 200) {
      final body = jsonDecode(presignResponse.body);
      throw Exception(body['error'] ?? 'Failed to get upload URL');
    }

    final presignData = jsonDecode(presignResponse.body)['data'];
    final presignedUrl = presignData['presignedUrl'] as String;
    final publicUrl = presignData['publicUrl'] as String;

    // Step 2: Upload directly to S3 using presigned URL
    final fileBytes = await imageFile.readAsBytes();
    final uploadResponse = await client
        .put(
          Uri.parse(presignedUrl),
          headers: {'Content-Type': contentType},
          body: fileBytes,
        )
        .timeout(const Duration(seconds: 30));

    if (uploadResponse.statusCode != 200) {
      throw Exception('Failed to upload image to storage');
    }

    return publicUrl;
  }

  String _getExtension(String filePath) {
    final lastDot = filePath.lastIndexOf('.');
    if (lastDot == -1) return '.jpg';
    return filePath.substring(lastDot);
  }

  String _getContentType(String extension) {
    switch (extension.toLowerCase()) {
      case '.jpg':
      case '.jpeg':
        return 'image/jpeg';
      case '.png':
        return 'image/png';
      case '.gif':
        return 'image/gif';
      case '.webp':
        return 'image/webp';
      default:
        return 'image/jpeg';
    }
  }
}
