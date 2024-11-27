import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kaloriku/screens/Home/home_menu.dart';
import 'package:kaloriku/service/authService.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  static const String TOKEN_KEY = 'jwt_token';
  static const String USER_KEY = 'current_user';
  final _storage = const FlutterSecureStorage();

  Future<Map<String, dynamic>> _performLogin(
      String email, String password) async {
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
        // Save token
        await _storage.write(key: TOKEN_KEY, value: data['data']['token']);

        // Save user data
        await _storage.write(
            key: USER_KEY, value: jsonEncode(data['data']['user']));

        // Save UUID
        await _storage.write(
            key: 'user_uuid', value: data['data']['user']['user_uuid']);
      }

      return data;
    } catch (e) {
      return {'status': 'error', 'message': e.toString()};
    }
  }

  void _showDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: ThemeData(
            dialogBackgroundColor: Colors.green[100],
            primaryColor: Colors.green,
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.green,
              ),
            ),
          ),
          child: AlertDialog(
            title: const Text('Pemberitahuan'),
            content: Text(message),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _login(BuildContext context) async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showDialog(context, 'Silahkan isi terlebih dahulu');
      return;
    }

    // Perform login
    final response = await _performLogin(email, password);

    if (response['success'] == true) {
      // Navigate to home screen on successful login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeMenuScreen()),
      );
    } else {
      _showDialog(context, response['message'] ?? 'Login gagal');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        titleTextStyle: const TextStyle(
          fontFamily: 'Roboto',
          fontSize: 20,
          color: Color(0xFF61CA3D),
          fontWeight: FontWeight.w100,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              SvgPicture.asset(
                'assets/images/Vector Login.svg',
                width: MediaQuery.of(context).size.width * 0.7,
                height: MediaQuery.of(context).size.width * 0.7,
              ),
              const SizedBox(height: 50),

              // Email TextField
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Masukkan Email',
                  prefixIcon: const Icon(Icons.email),
                  floatingLabelStyle: const TextStyle(color: Colors.black54),
                  fillColor: const Color(0xFFFFFFFF),
                  filled: true,
                  hintText: 'Contoh: budiono@gmail.com',
                  hintStyle: const TextStyle(color: Colors.black45),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF61CA3D)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF61CA3D)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:
                        const BorderSide(color: Color(0xFF61CA3D), width: 2),
                  ),
                ),
                cursorColor: const Color(0xFF61CA3D),
              ),
              const SizedBox(height: 15),

              // Password TextField
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  filled: true,
                  fillColor: const Color(0xFFFFFFFF),
                  hintText: 'Minimal 6 karakter',
                  hintStyle: const TextStyle(color: Colors.black45),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF61CA3D)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF61CA3D)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:
                        const BorderSide(color: Color(0xFF61CA3D), width: 2),
                  ),
                ),
                obscureText: true,
                cursorColor: const Color(0xFF61CA3D),
              ),
              const SizedBox(height: 40),

              // Login Button
              ElevatedButton(
                onPressed: () => _login(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFFFFF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ).copyWith(
                  minimumSize: MaterialStateProperty.all(const Size(250, 50)),
                ),
                child: const Text(
                  'Login',
                  style: TextStyle(
                    fontFamily: 'Roboto-Regular.ttf',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF61CA3D),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
