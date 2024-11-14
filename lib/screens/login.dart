import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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

  void _login(BuildContext context) {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showDialog(context, 'Silahkan isi terlebih dahulu');
    } else {
      // Simulasi login
      _showDialog(context, 'Login berhasil');
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

              // TextField Email
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Masukkan Email',
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
                    borderSide: const BorderSide(color: Color(0xFF61CA3D), width: 2),
                  ),
                ),
                cursorColor: const Color(0xFF61CA3D),
              ),
              const SizedBox(height: 15),

              // TextField Password
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
                    borderSide: const BorderSide(color: Color(0xFF61CA3D), width: 2),
                  ),
                ),
                obscureText: true,
                cursorColor: const Color(0xFF61CA3D),
              ),
              const SizedBox(height: 40),

              // Tombol Login
              ElevatedButton(
                onPressed: () {
                  _login(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFFFFF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ).copyWith(
                  minimumSize: WidgetStateProperty.all(const Size(250, 50)),
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
