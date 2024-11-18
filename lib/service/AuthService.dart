import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kaloriku/model/User.dart';
import 'package:kaloriku/util/config/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String USER_UUID_KEY = 'user_uuid';
  static const String TOKEN_KEY = 'token';
  static const String USER_KEY = 'user';

  // Make _prefs nullable and initialize it lazily
  SharedPreferences? _prefs;

  // Initialize SharedPreferences
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Helper method to ensure prefs is initialized
  Future<SharedPreferences> get prefs async {
    if (_prefs == null) {
      await init();
    }
    return _prefs!;
  }

  // Menyimpan UUID
  Future<void> saveUserUUID(String uuid) async {
    final preferences = await prefs;
    await preferences.setString(USER_UUID_KEY, uuid);
  }

  // Mengambil UUID
  Future<String?> getUserUUID() async {
    final preferences = await prefs;
    return preferences.getString(USER_UUID_KEY);
  }

  // Menghapus UUID
  Future<void> removeUserUUID() async {
    final preferences = await prefs;
    await preferences.remove(USER_UUID_KEY);
  }

  // Fungsi register
  Future<Map<String, dynamic>> register(
      String email, String password, String confirmPassword) async {
    if (password != confirmPassword) {
      return {'success': false, 'message': 'Passwords do not match'};
    }

    try {
      final response = await http.post(
        Uri.http(AppConfig.API_HOST, '/api/auth/register'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        body: jsonEncode({
          'email': email,
          'password': password,
          'confirmPassword': confirmPassword,
        }),
      );

      final responseData = jsonDecode(response.body);

      // Handle successful registration
      if (response.statusCode == 200 && responseData['success'] == true) {
        if (responseData['data'] != null &&
            responseData['data']['user'] != null &&
            responseData['data']['user']['user_uuid'] != null) {
          final userUUID = responseData['data']['user']['user_uuid'];
          await saveUserUUID(userUUID);
          return responseData;
        }
      }

      // Handle validation errors
      if (responseData['data'] != null &&
          responseData['data']['email'] != null) {
        return {
          'success': false,
          'message':
              responseData['data']['email'][0] ?? 'Email validation failed',
        };
      }

      return {
        'success': false,
        'message':
            responseData['message'] ?? 'Terjadi kesalahan saat mendaftar',
      };
    } catch (e) {
      print('Registration error: ${e.toString()}');
      return {
        'success': false,
        'message': 'Terjadi kesalahan koneksi: ${e.toString()}'
      };
    }
  }

  // Fungsi login
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.http(AppConfig.API_HOST, '/api/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['status'] == 'success') {
        final preferences = await prefs;
        await saveUserUUID(data['user']['uuid']);
        await preferences.setString(TOKEN_KEY, data['token']);
        await preferences.setString(USER_KEY, jsonEncode(data['user']));
      }

      return data;
    } catch (e) {
      return {'status': 'error', 'message': e.toString()};
    }
  }

  // Mengambil data user saat ini
  Future<User?> getCurrentUser() async {
    final preferences = await prefs;
    final userStr = preferences.getString(USER_KEY);
    if (userStr != null) {
      return User.fromJson(jsonDecode(userStr));
    }
    return null;
  }

  // Mendapatkan token
  Future<String?> getToken() async {
    final preferences = await prefs;
    return preferences.getString(TOKEN_KEY);
  }

  // Fungsi logout
  Future<void> logout() async {
    final preferences = await prefs;
    await preferences.remove(TOKEN_KEY);
    await preferences.remove(USER_KEY);
    await removeUserUUID();
  }
}
