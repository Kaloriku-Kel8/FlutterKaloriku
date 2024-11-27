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
        return Theme(
          data: ThemeData(
            dialogBackgroundColor:
                isError ? Colors.red[100] : Colors.green[100],
            primaryColor: isError ? Colors.red : Colors.green,
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: isError ? Colors.red : Colors.green,
              ),
            ),
          ),
          child: AlertDialog(
            title: Text(isError ? 'Error' : 'Pemberitahuan'),
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

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final response = await _authService.login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (!response['success']) {
        _showDialog(
          context,
          response['error']['message'] ?? 'Terjadi kesalahan saat login',
          isError: true,
        );
        return;
      }

      // Navigate to home screen on successful login
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
<<<<<<< HEAD
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
=======
        child: Form(
          key: _formKey,
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
>>>>>>> 15f359deb95996de3cc199ec21435c6adbf4b167

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

<<<<<<< HEAD
              // TextField Password
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock),
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
                    borderSide: const BorderSide(color: Color(0xFF61CA3D), width: 2),
=======
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
>>>>>>> 15f359deb95996de3cc199ec21435c6adbf4b167
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
