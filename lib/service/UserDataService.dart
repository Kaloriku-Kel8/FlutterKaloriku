import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kaloriku/model/dataUser.dart';
import 'package:kaloriku/util/config/config.dart';
import 'package:kaloriku/service/authService.dart';

class UserDataService {
  final AuthService _authService = AuthService();

  Map<String, String> get headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  Future<Map<String, dynamic>> inputData1(DataUser userData) async {
    try {
      await _authService.init();
      String? userUuid = await _authService.getUserUUID();
      if (userUuid == null) {
        throw Exception('User UUID tidak ditemukan.Harap untuk register terlebih dahulu.');
      }

      final response = await http.post(
        Uri.http(AppConfig.API_HOST, '/api/DataUser/InputData1'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        body: jsonEncode({
          'uuid': userUuid,
          'nama': userData.nama,
          'tanggal_lahir': userData.tanggalLahir?.toIso8601String(),
          'jenis_kelamin':
              userData.jenisKelamin == JenisKelamin.laki ? 'laki' : 'perempuan',
          'berat_badan': userData.beratBadan,
          'tinggi_badan': userData.tinggiBadan,
        }),
      );

      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return responseData;
      } else {
        throw Exception(
            responseData['message'] ?? 'Gagal untuk menyimpan user profile data');
      }
    } catch (e) {
      throw Exception('Error input data step 1 : $e');
    }
  }

  Future<Map<String, dynamic>> inputData2(TingkatAktivitas aktivitas) async {
    try {
      await _authService.init();
      String? userUuid = await _authService.getUserUUID();

      if (userUuid == null) {
        throw Exception('User UUID tidak ditemukan.Harap untuk register terlebih dahulu.');
      }

      final response = await http.post(
        Uri.http(AppConfig.API_HOST, '/api/DataUser/InputData2'),
        headers: headers,
        body: jsonEncode({
          'uuid': userUuid,
          'tingkat_aktivitas': aktivitas.toString().split('.').last,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return responseData;
      } else {
        throw Exception(
            responseData['message'] ?? 'Gagal untuk menyimpan aktivitas');
      }
    } catch (e) {
      throw Exception('Error during registration step 3: $e');
    }
  }

  Future<Map<String, dynamic>> inputData3(Tujuan tujuan) async {
    try {
      // Initialize AuthService
      await _authService.init();

      // Get UUID from SharedPreferences - dengan await
      String? userUuid = await _authService.getUserUUID();

      if (userUuid == null) {
        throw Exception('User UUID tidak ditemukan.Harap untuk register terlebih dahulu.');
      }

      final response = await http.post(
        Uri.http(AppConfig.API_HOST, '/api/DataUser/InputData3'),
        headers: headers,
        body: jsonEncode({
          'uuid': userUuid,
          'tujuan': tujuan.toString().split('.').last,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return responseData;
      } else {
        throw Exception(responseData['message'] ?? 'Gagal untuk menyimpan tujuan');
      }
    } catch (e) {
      throw Exception('Error during registration step 4: $e');
    }
  }

  // Helper method untuk mendapatkan UUID
  Future<String> getRequiredUUID() async {
    await _authService.init();
    final uuid = await _authService.getUserUUID();
    if (uuid == null) {
      throw Exception('User UUID not found. Please login again.');
    }
    return uuid;
  }
}
