import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kaloriku/service/tokenService.dart';
import 'package:kaloriku/util/config/config.dart';
import 'package:kaloriku/model/dataUser.dart';

class UserProfilService {
  final ApiService _apiService = ApiService();


  Future<Map<String, String>> _getHeaders() async {
    final headers = await _apiService.getHeaders();
    headers['Content-Type'] = 'application/json'; // Add this line
    return headers;
  }

  /// Get user profile data
  Future<DataUser> getUserProfile() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.http(AppConfig.API_HOST, '/api/UserData/user-show'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final userData = responseData['data']['user_data'];
        return DataUser.fromJson(userData);
      } else {
        throw Exception(jsonDecode(response.body)['message'] ??
            'Gagal mengambil data profil pengguna');
      }
    } catch (e) {
      throw Exception('Error fetching user profile: $e');
    }
  }

  /// Update user profile data
   Future<DataUser> updateUserProfile(DataUser userData) async {
    try {
      final headers = await _getHeaders();
      final response = await http.put(
        Uri.http(AppConfig.API_HOST, '/api/UserData/user-update'),
        headers: headers,
        body: jsonEncode(userData.toJson()), // Encode the body as JSON
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final updatedUserData = responseData['data']['user_data'];
        return DataUser.fromJson(updatedUserData);
      } else {
        throw Exception(jsonDecode(response.body)['message'] ??
            'Gagal memperbarui data profil pengguna');
      }
    } catch (e) {
      throw Exception('Error updating user profile: $e');
    }
  }

  /// Delete user profile
  Future<void> deleteUserProfile() async {
    try {
      final headers = await _getHeaders();
      final response = await http.delete(
        Uri.http(AppConfig.API_HOST, '/api/UserData/user-delete'),
        headers: headers,
      );

      if (response.statusCode != 200) {
        throw Exception(
            jsonDecode(response.body)['message'] ?? 'Gagal menghapus akun');
      }
    } catch (e) {
      throw Exception('Error deleting user profile: $e');
    }
  }
}
