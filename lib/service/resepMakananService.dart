import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kaloriku/model/resepMakanan.dart';
import 'package:kaloriku/service/tokenService.dart';
import 'package:kaloriku/util/config/config.dart';

class ResepMakananService {
  final ApiService _apiService = ApiService();

  Future<Map<String, String>> _getHeaders() async {
    return await _apiService.getHeaders();
  }

  Future<List<ResepMakanan>> getAllResepMakanan() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.http(AppConfig.API_HOST, '/api/resep-makanan'),
        headers: headers,
      );

      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final List<dynamic> rawData =
            responseData['data']['resep_makanan'] ?? [];
        return rawData.map((json) => ResepMakanan.fromJson(json)).toList();
      } else {
        throw Exception(
            responseData['message'] ?? 'Gagal mengambil data resep makanan');
      }
    } catch (e) {
      throw Exception('Error fetching resep makanan: $e');
    }
  }

  Future<ResepMakanan> createResepMakanan(ResepMakanan resepMakanan) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.http(AppConfig.API_HOST, '/api/resep-makanan'),
        headers: headers,
        body: jsonEncode(resepMakanan.toJson()),
      );

      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return ResepMakanan.fromJson(responseData['data']['resep_makanan']);
      } else {
        throw Exception(
            responseData['message'] ?? 'Gagal menambahkan resep makanan');
      }
    } catch (e) {
      throw Exception('Error creating resep makanan: $e');
    }
  }

  Future<ResepMakanan> getResepMakananById(int id) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.http(AppConfig.API_HOST, '/api/resep-makanan/$id'),
        headers: headers,
      );

      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return ResepMakanan.fromJson(responseData['data']['resep_makanan']);
      } else {
        throw Exception(
            responseData['message'] ?? 'Resep makanan tidak ditemukan');
      }
    } catch (e) {
      throw Exception('Error fetching resep makanan: $e');
    }
  }

  Future<ResepMakanan> updateResepMakanan(ResepMakanan resepMakanan) async {
    try {
      if (resepMakanan.idResep == null) {
        throw Exception('ID resep harus disertakan untuk update');
      }

      final headers = await _getHeaders();
      final response = await http.put(
        Uri.http(
            AppConfig.API_HOST, '/api/resep-makanan/${resepMakanan.idResep}'),
        headers: headers,
        body: jsonEncode(resepMakanan.toJson()),
      );

      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return ResepMakanan.fromJson(responseData['data']['resep_makanan']);
      } else {
        throw Exception(
            responseData['message'] ?? 'Gagal memperbarui resep makanan');
      }
    } catch (e) {
      throw Exception('Error updating resep makanan: $e');
    }
  }

  Future<void> deleteResepMakanan(int id) async {
    try {
      final headers = await _getHeaders();
      final response = await http.delete(
        Uri.http(AppConfig.API_HOST, '/api/resep-makanan/$id'),
        headers: headers,
      );

      final responseData = jsonDecode(response.body);
      if (response.statusCode != 200) {
        throw Exception(
            responseData['message'] ?? 'Gagal menghapus resep makanan');
      }
    } catch (e) {
      throw Exception('Error deleting resep makanan: $e');
    }
  }

  Future<List<ResepMakanan>> getResepMakananByCategory(
      KategoriResep category) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.http(AppConfig.API_HOST,
            '/api/resep-makanan/category/${category.toString().split('.').last}'),
        headers: headers,
      );

      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final List<dynamic> rawData =
            responseData['data']['resep_makanan'] ?? [];
        return rawData.map((json) => ResepMakanan.fromJson(json)).toList();
      } else {
        throw Exception(responseData['message'] ??
            'Gagal mengambil resep makanan berdasarkan kategori');
      }
    } catch (e) {
      throw Exception('Error fetching resep makanan by category: $e');
    }
  }

  Future<List<ResepMakanan>> searchResepMakanan(String keyword) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.http(AppConfig.API_HOST, '/api/resep-makanan/search'),
        headers: headers,
        body: jsonEncode({'keyword': keyword}),
      );

      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final List<dynamic> rawData =
            responseData['data']['resep_makanan'] ?? [];
        return rawData.map((json) => ResepMakanan.fromJson(json)).toList();
      } else {
        throw Exception(
            responseData['message'] ?? 'Gagal mencari resep makanan');
      }
    } catch (e) {
      throw Exception('Error searching resep makanan: $e');
    }
  }


  
  Future<Map<String, dynamic>> filterAndSearchResepMakanan({
    KategoriResep? kategori,
    double? kaloriMin,
    double? kaloriMax,
    String? keyword,
    int page = 1,
    int perPage = 10,
  }) async {
    try {
      final headers = await _getHeaders();
      final queryParams = <String, dynamic>{
        'page': page.toString(),
        'per_page': perPage.toString(),
      };

      if (kategori != null) {
        queryParams['kategori'] = kategori.toString().split('.').last;
      }
      if (kaloriMin != null) queryParams['kalori_min'] = kaloriMin.toString();
      if (kaloriMax != null) queryParams['kalori_max'] = kaloriMax.toString();
      if (keyword != null) queryParams['keyword'] = keyword;

      final response = await http.get(
        Uri.http(AppConfig.API_HOST, '/api/resep-makanan/filter', queryParams),
        headers: headers,
      );

      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final List<dynamic> rawData = responseData['data']['data'] ?? [];
        return {
          'data': rawData.map((json) => ResepMakanan.fromJson(json)).toList(),
          'pagination': responseData['data']['pagination'] ?? {},
        };
      } else {
        throw Exception(
            responseData['message'] ?? 'Gagal memfilter resep makanan');
      }
    } catch (e) {
      throw Exception('Error filtering resep makanan: $e');
    }
  }
}
