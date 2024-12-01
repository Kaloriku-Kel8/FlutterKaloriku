import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kaloriku/service/tokenService.dart';
import 'package:kaloriku/util/config/config.dart';
import 'package:kaloriku/model/latihan.dart';
import 'package:kaloriku/model/stepLatihan.dart';

class LatihanService {
  final ApiService _apiService = ApiService();

  Future<Map<String, String>> _getHeaders() async {
    return await _apiService.getHeaders();
  }

  /// Get all Latihan data
  Future<List<Latihan>> getAllLatihan() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.http(AppConfig.API_HOST, '/api/Latihan/latihan'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final List<dynamic> rawData = responseData['data']['latihan'] ?? [];
        return rawData.map((json) => Latihan.fromJson(json)).toList();
      } else {
        throw Exception(jsonDecode(response.body)['message'] ??
            'Gagal mengambil data latihan');
      }
    } catch (e) {
      throw Exception('Error fetching latihan: $e');
    }
  }

  /// Get specific Latihan by ID and its related steps
  Future<Map<String, dynamic>> getLatihanWithSteps(String id) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.http(AppConfig.API_HOST, '/api/Latihan/step-latihan/$id'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final List<dynamic> latihanData = responseData['data']['latihan'] ?? [];
        final List<dynamic> stepLatihanData =
            responseData['data']['stepLatihan'] ?? [];

        return {
          'latihan': latihanData.map((json) => Latihan.fromJson(json)).toList(),
          'stepLatihan': stepLatihanData
              .map((json) => StepLatihan.fromJson(json))
              .toList(),
        };
      } else {
        throw Exception(jsonDecode(response.body)['message'] ??
            'Gagal mengambil data latihan atau steps');
      }
    } catch (e) {
      throw Exception('Error fetching latihan with steps: $e');
    }
  }
}
