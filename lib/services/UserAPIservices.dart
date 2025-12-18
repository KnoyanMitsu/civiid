import 'dart:io';

import 'package:civiid/services/shared.dart';
import 'package:http/http.dart';
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';

final api_http = dotenv.env['API_URL']! + 'user/';

class TestApi {
  Future<bool> testApi() async {
    try {
      final response = await get(Uri.parse(api_http));
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}

class RegisterApi {
  Future<Map<String, dynamic>> registerApi(
    int nik,
    String name,
    String email,
    String password,
    String tempatLahir,
    DateTime birthDate,
    String agama,
    String address,
    int phoneNumber,
    String status,
    File image,
  ) async {
    try {
      var request = MultipartRequest('POST', Uri.parse(api_http + 'register'));
      request.fields['nik'] = nik.toString();
      request.fields['name'] = name;
      request.fields['email'] = email;
      request.fields['password'] = password;
      request.fields['tempat_lahir'] = tempatLahir;
      // Convert DateTime to ISO8601 string or backend expected format (yyyy-MM-dd)
      request.fields['birth_date'] = birthDate.toIso8601String().split('T')[0];
      request.fields['agama'] = agama;
      request.fields['address'] = address;
      request.fields['phone_number'] = phoneNumber.toString();
      request.fields['status'] = status;

      if (await image.exists()) {
        try {
          request.files.add(
            await MultipartFile.fromPath('photo_file', image.path),
          );
        } catch (fileError) {
          return {'error': 'Error reading image file: $fileError'};
        }
      } else {}
      final streamedResponse = await request.send();
      final response = await Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        try {
          final data = jsonDecode(response.body);
          if (data['message'] != null) {
            data['error'] = data['message'];
          }
          return data;
        } catch (e) {
          return {
            'error': 'Failed to register. Status: ${response.statusCode}',
          };
        }
      }
    } catch (e) {
      return {'error': e.toString()};
    }
  }
}

class LoginUserAPI {
  Future<Map<String, dynamic>> loginApi(int nik, String password) async {
    try {
      var request = MultipartRequest('POST', Uri.parse(api_http + 'login'));
      request.fields['nik'] = nik.toString();
      request.fields['password'] = password;
      final streamedResponse = await request.send();
      final response = await Response.fromStream(streamedResponse);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        SharedPrefServiceLogin().saveLoginData(
          token: data['data']['access_token'],
        );
        return data;
      } else {
        return {'error': 'Failed to login'};
      }
    } catch (e) {
      return {'error': e.toString()};
    }
  }
}

class QRCodeAPI {
  Future<String> getQRCode(String token) async {
    try {
      var request = MultipartRequest('GET', Uri.parse(api_http + 'qr'));
      request.headers['Authorization'] = 'Bearer $token';
      final streamedResponse = await request.send();
      final response = await Response.fromStream(streamedResponse);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String url = data['data']['qr_url'];
        return url;
      } else {
        return 'Failed to get QR code';
      }
    } catch (e) {
      return e.toString();
    }
  }
}
