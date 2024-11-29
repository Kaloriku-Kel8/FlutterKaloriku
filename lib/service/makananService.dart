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

  // Future<List<Makanan>> getUserMakanan() async {
  //   try {
  //     final headers = await _getHeaders();
  //     final response = await http.get(
  //       Uri.http(AppConfig.API_HOST, '/api/Makanan/makanan'),
  //       headers: headers,
  //     );

  //     final responseData = jsonDecode(response.body);
  //     if (response.statusCode == 200) {
  //       final List<dynamic> rawData = responseData['data']['makanan'] ?? [];
  //       return rawData.map((json) => Makanan.fromJson(json)).toList();
  //     } else {
  //       throw Exception(
  //           responseData['message'] ?? 'Gagal mengambil data makanan pengguna');
  //     }
  //   } catch (e) {
  //     throw Exception('Error fetching user makanan: $e');
  //   }
  // }

  // Future<List<Makanan>> getGeneralMakanan() async {
  //   try {
  //     final headers = await _getHeaders();
  //     final response = await http.get(
  //       Uri.http(AppConfig.API_HOST, '/api/Makanan/makanan-general'),
  //       headers: headers,
  //     );

  //     final responseData = jsonDecode(response.body);
  //     if (response.statusCode == 200) {
  //       final List<dynamic> rawData = responseData['data']['makanan'] ?? [];
  //       return rawData.map((json) => Makanan.fromJson(json)).toList();
  //     } else {
  //       throw Exception(
  //           responseData['message'] ?? 'Gagal mengambil data makanan umum');
  //     }
  //   } catch (e) {
  //     throw Exception('Error fetching general makanan: $e');
  //   }
  // }

  //Menambahkan Custom Makanan
  Future<Makanan> createMakanan(Makanan makanan) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.http(AppConfig.API_HOST, '/api/Makanan/makanan'),
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

  // //Mengambil Makanan Berdasarkan id
  // Future<Makanan> getMakananById(String id, {bool isGeneral = false}) async {
  //   try {
  //     final headers = await _getHeaders();
  //     final url = isGeneral
  //         ? '/api/Makanan/makanan/general/$id'
  //         : '/api/Makanan/makanan/$id';
  //     final response = await http.get(
  //       Uri.http(AppConfig.API_HOST, url),
  //       headers: headers,
  //     );

  //     final responseData = jsonDecode(response.body);
  //     if (response.statusCode == 200) {
  //       return Makanan.fromJson(responseData['data']['makanan']);
  //     } else {
  //       throw Exception(responseData['message'] ?? 'Makanan tidak ditemukan');
  //     }
  //   } catch (e) {
  //     throw Exception('Error fetching makanan: $e');
  //   }
  // }
  
  // //Memperbarui Makanan
  // Future<Makanan> updateMakanan(Makanan makanan) async {
  //   try {
  //     if (makanan.idMakanan == null) {
  //       throw Exception('ID makanan harus disertakan untuk update');
  //     }

  //     final headers = await _getHeaders();
  //     final response = await http.put(
  //       Uri.http(
  //           AppConfig.API_HOST, '/api/Makanan/makanan/${makanan.idMakanan}'),
  //       headers: headers,
  //       body: jsonEncode(makanan.toJson()),
  //     );

  //     final responseData = jsonDecode(response.body);
  //     if (response.statusCode == 200) {
  //       return Makanan.fromJson(responseData['data']['makanan']);
  //     } else {
  //       throw Exception(responseData['message'] ?? 'Gagal memperbarui makanan');
  //     }
  //   } catch (e) {
  //     throw Exception('Error updating makanan: $e');
  //   }
  // }

  //Menghapus Makanan
  Future<void> deleteMakanan(String id) async {
    try {
      final headers = await _getHeaders();
      final response = await http.delete(
        Uri.http(AppConfig.API_HOST, '/api/Makanan/makanan/$id'),
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

  // Future<List<Makanan>> getMakananByCategory(String category,
  //     {bool isGeneral = false}) async {
  //   try {
  //     final headers = await _getHeaders();
  //     final url = isGeneral
  //         ? '/api/Makanan/makanan/category-general/$category'
  //         : '/api/Makanan/makanan/category/$category';
  //     final response = await http.get(
  //       Uri.http(AppConfig.API_HOST, url),
  //       headers: headers,
  //     );

  //     final responseData = jsonDecode(response.body);
  //     if (response.statusCode == 200) {
  //       final List<dynamic> rawData = responseData['data']['makanan'] ?? [];
  //       return rawData.map((json) => Makanan.fromJson(json)).toList();
  //     } else {
  //       throw Exception(responseData['message'] ??
  //           'Gagal mengambil makanan berdasarkan kategori');
  //     }
  //   } catch (e) {
  //     throw Exception('Error fetching makanan by category: $e');
  //   }
  // }

  //Menampilkan berdasarkan kategori dan mencari makanan
  Future<List<Makanan>> GetAndSearchMakanan({
  String? keyword,
  required String category,
  bool isGeneral = false,
  }) async {
  try {
    if (category.isEmpty) {
      throw Exception('Kategori makanan harus diisi.');
    }

    final headers = await _getHeaders();
    final url = isGeneral
        ? '/api/Makanan/makanan/search-general'
        : '/api/Makanan/makanan/search';

    
    final requestBody = {
      if (keyword != null && keyword.isNotEmpty) 'nama_makanan': keyword,
      'kategori_makanan': category,
    };

    final response = await http.post(
      Uri.http(AppConfig.API_HOST, url),
      headers: headers,
      body: jsonEncode(requestBody),
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
