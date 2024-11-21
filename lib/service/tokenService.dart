import 'package:kaloriku/service/authService.dart';

class ApiService {
  final AuthService _authService = AuthService();
  Future<Map<String, String>> _getHeaders() async {
    final token = await _authService.getToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }
}
