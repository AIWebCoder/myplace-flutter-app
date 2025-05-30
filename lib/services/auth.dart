// ignore: library_prefixes
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:x_place/services/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert'; // for json encode/decode

class Auth extends ChangeNotifier {
  bool _isLoggedIn = false;
  String? _token;

  bool get authenticated => _isLoggedIn;
  String? get token => _token;

  Future<void> initAuth() async {
    const secureStorage = FlutterSecureStorage();
    _token = await secureStorage.read(key: 'token');
    // ignore: avoid_print
    print('stored token in initAuth: $_token');
    // ignore: avoid_print
    print('${_token != null}');

    if (_token != null) {
      _isLoggedIn = true;
    }
    notifyListeners();
    // ignore: avoid_print
    print('auth.authenticated in initAuth: $authenticated');
  }

  Future<dynamic> login({Map? creds}) async {
    try {
      print('Login route: ${DioClient.dio.options.baseUrl}/login-api');
      print('Login data: $creds');

      final response = await DioClient.dio.post('/login-api', data: creds);

      if (response.statusCode == 200) {
        final data = response.data['data'];
        final user = data['user'];
        _token = data['token'] as String?;

        const secureStorage = FlutterSecureStorage();

        // Save token
        await secureStorage.write(key: 'token', value: _token!);

        // Save user as JSON string
        await secureStorage.write(key: 'user', value: jsonEncode(user));

        _isLoggedIn = true;
        notifyListeners();

        return [true, user];
      } else {
        return "Login failed with status code ${response.statusCode}";
      }
    } catch (e) {
      if (e is DioException) {
        print('DioException response data: ${e.response?.data}');
      }
      print("Error: $e");
      return "Error: $e";
    }
  }

  Future<bool> register({required Map<String, dynamic> data}) async {
    try {
      print("this is the register data : $data");
      final response = await DioClient.dio.post('/register-api', data: data);

      if (response.statusCode == 201) {
        final responseData = response.data['data'];
        final user = responseData['user'];
        _token = responseData['token'];

        const secureStorage = FlutterSecureStorage();

        // Save token and user info
        await secureStorage.write(key: 'token', value: _token);
        await secureStorage.write(key: 'user', value: jsonEncode(user));

        _isLoggedIn = true;
        notifyListeners();

        return true;
      } else {
        print("Registration failed with status code ${response.statusCode}");
        return false;
      }
    } catch (e) {
      if (e is DioException) {
        print('DioException: ${e.response?.data}');
      }
      print("Error during registration: $e");
      return false;
    }
  }

  void logout() async {
    const secureStorage = FlutterSecureStorage();
    await secureStorage.delete(key: 'token');

    _isLoggedIn = false;
    _token = null;
    notifyListeners();
  }

}
