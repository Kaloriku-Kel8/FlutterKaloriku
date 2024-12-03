import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kaloriku/model/kaloriKonsumsi.dart';
import 'package:kaloriku/util/config/config.dart';
import 'package:kaloriku/service/tokenService.dart';

class KaloriKonsumsiService {
  final ApiService _apiService = ApiService();

  Future<Map<String, String>> _getHeaders() async {
    return await _apiService.getHeaders();
  }

  // Fetch all konsumsi kalori
  Future<List<KonsumsiKalori>> getAllKonsumsiKalori() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.http(AppConfig.API_HOST, '/api/KonsumsiKalori/konsumsi-kalori'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final List<dynamic> rawData =
            responseData['data']['konsumsi_kalori'] ?? [];
        return rawData.map((json) => KonsumsiKalori.fromJson(json)).toList();
      } else {
        throw Exception(jsonDecode(response.body)['message'] ??
            'Gagal mengambil data konsumsi kalori');
      }
    } catch (e) {
      throw Exception('Error fetching konsumsi kalori: $e');
    }
  }

  // Get konsumsi kalori hari ini
  Future<List<KonsumsiKalori>> getKonsumsiKaloriToday() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.http(
            AppConfig.API_HOST, '/api/KonsumsiKalori/konsumsi-kaloriToday'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final List<dynamic> rawData =
            responseData['data']['konsumsi_kalori'] ?? [];
        return rawData.map((json) => KonsumsiKalori.fromJson(json)).toList();
      } else {
        throw Exception(jsonDecode(response.body)['message'] ??
            'Gagal mengambil data konsumsi kalori hari ini');
      }
    } catch (e) {
      throw Exception('Error fetching today\'s konsumsi kalori: $e');
    }
  }

  // Create konsumsi kalori
  Future<KonsumsiKalori> createKonsumsiKalori(KonsumsiKalori konsumsi) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.http(AppConfig.API_HOST, '/api/KonsumsiKalori/konsumsi-kalori'),
        headers: headers,
        body: jsonEncode(konsumsi.toJson()),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return KonsumsiKalori.fromJson(responseData['data']['konsumsi_kalori']);
      } else {
        throw Exception(jsonDecode(response.body)['message'] ??
            'Gagal menambahkan konsumsi kalori');
      }
    } catch (e) {
      throw Exception('Error creating konsumsi kalori: $e');
    }
  }

  // Get konsumsi kalori by ID
  Future<KonsumsiKalori> getKonsumsiKaloriById(String id) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.http(AppConfig.API_HOST, '/api/KonsumsiKalori/konsumsi-kalori/$id'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return KonsumsiKalori.fromJson(responseData['data']['konsumsi_kalori']);
      } else {
        throw Exception(jsonDecode(response.body)['message'] ??
            'Konsumsi kalori tidak ditemukan');
      }
    } catch (e) {
      throw Exception('Error fetching konsumsi kalori: $e');
    }
  }

  // Update konsumsi kalori
  Future<KonsumsiKalori> updateKonsumsiKalori(
      String id, KonsumsiKalori konsumsi) async {
    try {
      final headers = await _getHeaders();
      final response = await http.put(
        Uri.http(AppConfig.API_HOST, '/api/KonsumsiKalori/konsumsi-kalori/$id'),
        headers: headers,
        body: jsonEncode(konsumsi.toJson()),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return KonsumsiKalori.fromJson(responseData['data']['konsumsi_kalori']);
      } else {
        throw Exception(jsonDecode(response.body)['message'] ??
            'Gagal memperbarui konsumsi kalori');
      }
    } catch (e) {
      throw Exception('Error updating konsumsi kalori: $e');
    }
  }

  // Delete konsumsi kalori
  Future<void> deleteKonsumsiKalori(String id) async {
    try {
      final headers = await _getHeaders();
      final response = await http.delete(
        Uri.http(AppConfig.API_HOST, '/api/KonsumsiKalori/konsumsi-kalori/$id'),
        headers: headers,
      );

      if (response.statusCode != 200) {
        throw Exception(jsonDecode(response.body)['message'] ??
            'Gagal menghapus konsumsi kalori');
      }
    } catch (e) {
      throw Exception('Error deleting konsumsi kalori: $e');
    }
  }

  // Get weekly summary
  Future<List<Map<String, dynamic>>> getWeeklySummary() async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.http(
            AppConfig.API_HOST, '/api/KonsumsiKalori/konsumsi-kalori/weekly'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final List<dynamic> data = responseData['data'] ?? [];
        return List<Map<String, dynamic>>.from(data);
      } else {
        throw Exception(jsonDecode(response.body)['message'] ??
            'Gagal mengambil ringkasan mingguan');
      }
    } catch (e) {
      throw Exception('Error fetching weekly summary: $e');
    }
  }

  Future<Map<String, dynamic>> updateSummary(String date) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.http(
            AppConfig.API_HOST, '/api/KonsumsiKalori/konsumsi-kalori/update'),
        headers: headers,
        body: jsonEncode({'tanggal': date}),
      );

      if (response.statusCode != 200) {
        throw Exception(jsonDecode(response.body)['message'] ??
            'Gagal memperbarui ringkasan konsumsi');
      }

      final data = jsonDecode(response.body);
      return data;
    } catch (e) {
      throw Exception('Error updating summary: $e');
    }
  }

  // Get konsumsi by day and category
  Future<Map<String, dynamic>> getKonsumsiByDayAndCategory(
      String date, String category) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.http(AppConfig.API_HOST,
            '/api/KonsumsiKalori/konsumsi-kalori/by-day-category'),
        headers: headers,
        body: jsonEncode({
          'date': date,
          'category': category,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return responseData['data'];
      } else {
        throw Exception(jsonDecode(response.body)['message'] ??
            'Gagal mengambil data konsumsi berdasarkan hari dan kategori');
      }
    } catch (e) {
      throw Exception('Error fetching konsumsi by day and category: $e');
    }
  }
}
