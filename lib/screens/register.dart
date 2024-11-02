import 'package:flutter/material.dart';


class RegisterScreen extends StatelessWidget {

  RegisterScreen({super.key});

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

  void _register(BuildContext context) {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showDialog(context, 'Silahkan isi terlebih dahulu');
    } else {
      // Simulasi pendaftaran
      // Ganti dengan logika pendaftaran yang sebenarnya
      _showDialog(context, 'Pendaftaran berhasil');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),

          ElevatedButton(
            onPressed: () {
              _register(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFFFFF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0), // Ganti dengan radius yang diinginkan
              ),
            ).copyWith(
              minimumSize: WidgetStateProperty.all(const Size(250, 50)), // Ganti dengan ukuran minimum yang diinginkan
            ),
            child: const Text('Sign Up',
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