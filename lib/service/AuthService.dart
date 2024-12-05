import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kaloriku/model/user.dart';
import 'package:kaloriku/util/config/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String TOKEN_KEY = 'jwt_token';
  static const String USER_KEY = 'current_user';
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

  // Simpan token
  Future<void> saveToken(String token) async {
    final preferences = await prefs;
    await preferences.setString(TOKEN_KEY, token);
  }

  // Ambil token
  Future<String?> getToken() async {
    final preferences = await prefs;
    return preferences.getString(TOKEN_KEY);
  }

  // Simpan user
  Future<void> saveUser(String userJson) async {
    final preferences = await prefs;
    await preferences.setString(USER_KEY, userJson);
  }

  // Ambil user
  Future<User?> getCurrentUser() async {
    final preferences = await prefs;
    final userStr = preferences.getString(USER_KEY);
    if (userStr != null) {
      return User.fromJson(jsonDecode(userStr));
    }
    return null;
  }

  // Simpan user UUID
  Future<void> saveUserUUID(String uuid) async {
    final preferences = await prefs;
    await preferences.setString(USER_UUID_KEY, uuid);
  }

  // Ambil user UUID
  Future<String?> getUserUUID() async {
    final preferences = await prefs;
    return preferences.getString(USER_UUID_KEY);
  }

  // Hapus semua data
  Future<void> clearData() async {
    final preferences = await prefs;
    await preferences.clear();
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

      if (response.statusCode == 200 && responseData['success'] == true) {
        if (responseData['data'] != null &&
            responseData['data']['user'] != null &&
            responseData['data']['user']['user_uuid'] != null) {
          final userUUID = responseData['data']['user']['user_uuid'];
          await saveUserUUID(userUUID);
          return responseData;
        }
      }

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
        await saveToken(data['data']['token']);

        // Simpan data user
        await saveUser(jsonEncode(data['data']['user']));

        // Simpan UUID
        await saveUserUUID(data['data']['user']['user_uuid']);
      } else if (response.statusCode == 401) {
        return {
          'success': false,
          'message': data['message'] ?? 'Email atau password salah.'
        };
      } else {
        return {
          'success': false,
          'message':
              'Terjadi kesalahan: ${data['message'] ?? 'Tidak diketahui.'}'
        };
      }

      return data;
    } catch (e) {
      return {
        'success': false,
        'message': 'Terjadi kesalahan koneksi: ${e.toString()}',
      };
    }
  }

  Future<void> logout() async {
    await clearData();
  }

  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null;
  }
}
