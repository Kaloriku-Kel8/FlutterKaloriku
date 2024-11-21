import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kaloriku/model/Makanan.dart';
import 'package:kaloriku/service/tokenService.dart';
import 'package:kaloriku/util/config/config.dart';

class MakananService {
  final ApiService _apiService = ApiService();

  Future<Map<String, String>> _getHeaders() async {
    return await _apiService.getHeaders();
  }

  Future<List<Makanan>> getAllMakanan() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.http(AppConfig.API_HOST, '/api/makanan'),
        headers: headers,
      );

      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final List<dynamic> rawData = responseData['data']['makanan'] ?? [];
        return rawData.map((json) => Makanan.fromJson(json)).toList();
      } else {
        throw Exception(
            responseData['message'] ?? 'Gagal mengambil data makanan');
      }
    } catch (e) {
      throw Exception('Error fetching makanan: $e');
    }
  }

  Future<Makanan> createMakanan(Makanan makanan) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.http(AppConfig.API_HOST, '/api/makanan'),
        headers: headers,
        body: jsonEncode(makanan.toJson()),
      );

      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return Makanan.fromJson(responseData['data']['makanan']);
      } else {
        throw Exception(responseData['message'] ?? 'Gagal menambahkan makanan');
      }
    } catch (e) {
      throw Exception('Error creating makanan: $e');
    }
  }

  Future<Makanan> getMakananById(String id) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.http(AppConfig.API_HOST, '/api/makanan/$id'),
        headers: headers,
      );

      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return Makanan.fromJson(responseData['data']['makanan']);
      } else {
        throw Exception(responseData['message'] ?? 'Makanan tidak ditemukan');
      }
    } catch (e) {
      throw Exception('Error fetching makanan: $e');
    }
  }

  Future<Makanan> updateMakanan(Makanan makanan) async {
    try {
      if (makanan.idMakanan == null) {
        throw Exception('ID makanan harus disertakan untuk update');
      }

      final headers = await _getHeaders();
      final response = await http.put(
        Uri.http(AppConfig.API_HOST, '/api/makanan/${makanan.idMakanan}'),
        headers: headers,
        body: jsonEncode(makanan.toJson()),
      );

      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return Makanan.fromJson(responseData['data']['makanan']);
      } else {
        throw Exception(responseData['message'] ?? 'Gagal memperbarui makanan');
      }
    } catch (e) {
      throw Exception('Error updating makanan: $e');
    }
  }

  Future<void> deleteMakanan(String id) async {
    try {
      final headers = await _getHeaders();
      final response = await http.delete(
        Uri.http(AppConfig.API_HOST, '/api/makanan/$id'),
        headers: headers,
      );

      final responseData = jsonDecode(response.body);
      if (response.statusCode != 200) {
        throw Exception(responseData['message'] ?? 'Gagal menghapus makanan');
      }
    } catch (e) {
      throw Exception('Error deleting makanan: $e');
    }
  }

  Future<List<Makanan>> getMakananByCategory(KategoriMakanan category) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.http(AppConfig.API_HOST,
            '/api/makanan/category/${category.toString().split('.').last}'),
        headers: headers,
      );

      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final List<dynamic> rawData = responseData['data']['makanan'] ?? [];
        return rawData.map((json) => Makanan.fromJson(json)).toList();
      } else {
        throw Exception(responseData['message'] ??
            'Gagal mengambil makanan berdasarkan kategori');
      }
    } catch (e) {
      throw Exception('Error fetching makanan by category: $e');
    }
  }

  Future<List<Makanan>> searchMakananByName(String keyword) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.http(AppConfig.API_HOST, '/api/makanan/search'),
        headers: headers,
        body: jsonEncode({'nama_makanan': keyword}),
      );

      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final List<dynamic> rawData = responseData['data']['makanan'] ?? [];
        return rawData.map((json) => Makanan.fromJson(json)).toList();
      } else {
        throw Exception(responseData['message'] ?? 'Gagal mencari makanan');
      }
    } catch (e) {
      throw Exception('Error searching makanan: $e');
    }
  }
}
