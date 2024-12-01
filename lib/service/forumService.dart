import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kaloriku/service/tokenService.dart';
import 'package:kaloriku/util/config/config.dart';
import 'package:kaloriku/model/qna.dart';
import 'package:kaloriku/model/komentar.dart' as komentar_model;
import 'package:kaloriku/model/like.dart' as like_model;

class ForumService {
  final ApiService _apiService = ApiService();

  Future<Map<String, String>> _getHeaders() async {
    return await _apiService.getHeaders();
  }

  /// Get all questions with optional search
  Future<List<Map<String, dynamic>>> getAllQuestions({String? keyword}) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.http(AppConfig.API_HOST, '/api/Forum/questions-get'),
        headers: headers,
        body: keyword != null ? {'keywoard': keyword} : null,
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final List<dynamic> questions = responseData['data']['questions'] ?? [];
        return List<Map<String, dynamic>>.from(questions);
      } else {
        throw Exception(jsonDecode(response.body)['message'] ?? 'Failed to fetch questions');
      }
    } catch (e) {
      throw Exception('Error fetching questions: $e');
    }
  }

  /// Get specific question with comments and likes
  Future<Map<String, dynamic>> getQuestion(String id) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.http(AppConfig.API_HOST, '/api/Forum/questions/$id'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return responseData['data']['question'];
      } else {
        throw Exception(jsonDecode(response.body)['message'] ?? 'Failed to fetch question');
      }
    } catch (e) {
      throw Exception('Error fetching question: $e');
    }
  }

  /// Create new question
  Future<Qna> createQuestion(String judul, String isi) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.http(AppConfig.API_HOST, '/api/Forum/questions'),
        headers: headers,
        body: {
          'judul_qna': judul,
          'isi_qna': isi,
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return Qna.fromJson(responseData['data']['question']);
      } else {
        throw Exception(jsonDecode(response.body)['message'] ?? 'Failed to create question');
      }
    } catch (e) {
      throw Exception('Error creating question: $e');
    }
  }

  /// Update existing question
  Future<Qna> updateQuestion(String id, String judul, String isi) async {
    try {
      final headers = await _getHeaders();
      final response = await http.put(
        Uri.http(AppConfig.API_HOST, '/api/Forum/questions/$id'),
        headers: headers,
        body: {
          'judul_qna': judul,
          'isi_qna': isi,
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return Qna.fromJson(responseData['data']['question']);
      } else {
        throw Exception(jsonDecode(response.body)['message'] ?? 'Failed to update question');
      }
    } catch (e) {
      throw Exception('Error updating question: $e');
    }
  }

  /// Delete question
  Future<void> deleteQuestion(String id) async {
    try {
      final headers = await _getHeaders();
      final response = await http.delete(
        Uri.http(AppConfig.API_HOST, '/api/Forum/questions/$id'),
        headers: headers,
      );

      if (response.statusCode != 200) {
        throw Exception(jsonDecode(response.body)['message'] ?? 'Failed to delete question');
      }
    } catch (e) {
      throw Exception('Error deleting question: $e');
    }
  }

  /// Add comment to question
  Future<komentar_model.Komentar> addComment(String questionId, String isiKomentar) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.http(AppConfig.API_HOST, '/api/Forum/questions/$questionId/comments'),
        headers: headers,
        body: {
          'isi_komentar': isiKomentar,
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return komentar_model.Komentar.fromJson(responseData['data']['comment']);
      } else {
        throw Exception(jsonDecode(response.body)['message'] ?? 'Failed to add comment');
      }
    } catch (e) {
      throw Exception('Error adding comment: $e');
    }
  }

  /// Toggle like on question
  Future<bool> toggleLike(String questionId) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.http(AppConfig.API_HOST, '/api/Forum/questions/$questionId/like'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return responseData['data']['liked'] ?? false;
      } else {
        throw Exception(jsonDecode(response.body)['message'] ?? 'Failed to toggle like');
      }
    } catch (e) {
      throw Exception('Error toggling like: $e');
    }
  }
}