import 'package:flutter/material.dart';


class LoginScreen extends StatelessWidget {

  LoginScreen({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void _showDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
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
      // Ganti dengan logika login yang sebenarnya
      _showDialog(context, 'Login berhasil');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login'), titleTextStyle: 
      TextStyle(
        fontFamily: 'Roboto',
        fontSize: 20, 
        color: Color(0xFF61CA3D),
        fontWeight: FontWeight.w100,
      ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
TextField(
  controller: emailController,
  decoration: InputDecoration(
    labelText: 'Masukkan Email',
    fillColor: Color(0xFFE0F7FA), // Warna latar belakang
    filled: true, // Mengaktifkan warna latar belakang
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xFF61CA3D), width: 2.0), // Warna border saat tidak fokus
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xFF61CA3D), width: 2.0), // Warna border saat fokus
    ),
  ),
  cursorColor: Color(0xFF61CA3D), // Warna kursor
),
SizedBox(height: 15),
TextField(
  controller: passwordController,
  decoration: InputDecoration(
    labelText: 'Password',
    fillColor: Color(0xFFE0F7FA), // Warna latar belakang
    filled: true, // Mengaktifkan warna latar belakang
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xFF61CA3D), width: 2.0), // Warna border saat tidak fokus
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xFF61CA3D), width: 2.0), // Warna border saat fokus
    ),
  ),
  obscureText: true,
  cursorColor: Color(0xFF61CA3D), // Warna kursor
),
            const SizedBox(height: 20),

          ElevatedButton(
            onPressed: () {
              _login(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFFFFF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0), // Ganti dengan radius yang diinginkan
              ),
            ).copyWith(
              minimumSize: WidgetStateProperty.all(const Size(250, 50)), // Ganti dengan ukuran minimum yang diinginkan
            ),
            child: const Text('Login',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF61CA3D),
            ),
              textAlign: TextAlign.center,
            ),
          ), 
          ],
        ),
      ),
    );
  }
}