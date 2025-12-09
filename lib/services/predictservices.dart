import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PredictService {
  final String apiUrl = 'https://damhgfc-pbl-group7.hf.space/predict';

  Future<Map<String, dynamic>> predictGender(File image) async {
    try {
      final request = http.MultipartRequest('POST', Uri.parse(apiUrl));
      final file = await http.MultipartFile.fromPath('image', image.path);
      request.files.add(file);

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      final result = json.decode(responseBody);

      return result;
    } catch (e) {
      debugPrint('Error during prediction: $e');
      return {'error': 'Failed to predict gender'};
    }
  }
}
