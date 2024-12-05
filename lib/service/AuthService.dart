import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kaloriku/model/user.dart';
import 'package:kaloriku/util/config/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  //Register
  static const String USER_UUID_KEY = 'user_uuid';
  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<SharedPreferences> get prefs async {
    if (_prefs == null) {
      await init();
    }
    return _prefs!;
  }

  Future<void> saveUserUUID(String uuid) async {
    final preferences = await prefs;
    await preferences.setString(USER_UUID_KEY, uuid);
  }

  Future<String?> getUserUUID() async {
    final preferences = await prefs;
    return preferences.getString(USER_UUID_KEY);
  }

  Future<void> removeUserUUID() async {
    final preferences = await prefs;
    await preferences.remove(USER_UUID_KEY);
  }

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
      print('Registration gagal: ${e.toString()}');
      return {
        'success': false,
        'message': 'Terjadi kesalahan koneksi: ${e.toString()}'
      };
    }
  }

  //LOGIN
  static const String TOKEN_KEY = 'jwt_token';
  static const String USER_KEY = 'current_user';

  final _storage = const FlutterSecureStorage();

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

      if (response.statusCode == 200 && data['success'] == true) {
        // Simpan token
        await _storage.write(key: TOKEN_KEY, value: data['data']['token']);

        // Simpan data user
        await _storage.write(
            key: USER_KEY, value: jsonEncode(data['data']['user']));

        // Simpan UUID
        await _storage.write(
            key: 'user_uuid', value: data['data']['user']['user_uuid']);
      } else if (response.statusCode == 401) {
        // Password salah atau email tidak ditemukan
        return {
          'success': false,
          'message': data['message'] ?? 'Email atau password salah.'
        };
      } else {
        // Kesalahan server lainnya
        return {
          'success': false,
          'message':
              'Terjadi kesalahan: ${data['message'] ?? 'Tidak diketahui.'}'
        };
      }

      return data;
    } catch (e) {
      // Kesalahan koneksi atau lainnya
      return {
        'success': false,
        'message': 'Terjadi kesalahan koneksi: ${e.toString()}',
      };
    }
  }

  // Mengambil data user saat ini
  Future<User?> getCurrentUser() async {
    try {
      final userStr = await _storage.read(key: USER_KEY);
      if (userStr != null) {
        return User.fromJson(jsonDecode(userStr));
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Mendapatkan token
  Future<String?> getToken() async {
    return await _storage.read(key: TOKEN_KEY);
  }

  // Fungsi logout
  Future<void> logout() async {
    await _storage.deleteAll();
  }

  // Fungsi untuk memeriksa status login
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null;
  }
}