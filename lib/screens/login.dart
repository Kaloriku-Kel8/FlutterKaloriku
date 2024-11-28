// login_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kaloriku/service/authService.dart';
import 'package:kaloriku/screens/Home/home_menu.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;

  void _showDialog(BuildContext context, String message,
      {bool isError = false}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: isError ? Colors.red[100] : Colors.green[100],
          title: Row(
            children: [
              Icon(
                isError ? Icons.error_outline : Icons.check_circle_outline,
                color: isError ? Colors.red : Colors.green,
              ),
              const SizedBox(width: 8),
              Text(
                isError ? 'Error' : 'Pemberitahuan',
                style: TextStyle(
                  color: isError ? Colors.red : Colors.green,
                ),
              ),
            ],
          ),
          content: Text(
            message,
            style: const TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                foregroundColor: isError ? Colors.red : Colors.green,
              ),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final response = await _authService.login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (!response['success']) {
        // Tampilkan pesan error dari server atau pesan default
        _showDialog(
          context,
          response['message'] ?? 'Terjadi kesalahan saat login.',
          isError: true,
        );
        return;
      }

      // Navigasi ke layar utama jika login berhasil
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeMenuScreen()),
      );
    } catch (e) {
      _showDialog(context, 'Terjadi kesalahan: ${e.toString()}', isError: true);
    } finally {
      setState(() => _isLoading = false);
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
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                SvgPicture.asset(
                  'assets/images/login_regis/Vector Login.svg',
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: MediaQuery.of(context).size.width * 0.7,
                ),
                const SizedBox(height: 50),

                // Email TextField
                TextFormField(
                  controller: _emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email tidak boleh kosong';
                    }
                    if (!value.contains('@')) {
                      return 'Email tidak valid';
                    }
                    return null;
                  },
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
                TextFormField(
                  controller: _passwordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password tidak boleh kosong';
                    }
                    if (value.length < 6) {
                      return 'Password minimal 6 karakter';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock),
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
                  onPressed: _isLoading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFFFFF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ).copyWith(
                    minimumSize: MaterialStateProperty.all(const Size(250, 50)),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Color(0xFF61CA3D)),
                        )
                      : const Text(
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
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
