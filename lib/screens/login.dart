import 'package:flutter/material.dart';
import 'register.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginScreen({super.key});

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
      bool accountExists = true; // Ganti dengan logika pengecekan akun yang sebenarnya
      bool isPasswordCorrect = false; // Ganti dengan logika pengecekan password yang sebenarnya

      if (!accountExists) {
        _showDialog(context, 'Akun tidak ditemukan. Daftar dulu?');
      } else if (!isPasswordCorrect) {
        _showDialog(context, 'Email atau password salah. Coba lagi.');
      } else {
        // Jika login berhasil
        _showDialog(context, 'Login berhasil');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
      padding: const EdgeInsets.all(16.0),
        child:SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            
              Text('KaloriKu', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold,
              color: Color(0xFF61CA3D)),
            ),
            
            SizedBox(height: 22),

            Image.asset('assets/images/gambar1.png', width: 300, height: 300),
          
          SizedBox(height: 22),
          
          ElevatedButton(
            onPressed: () {
              _login(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF61CA3D),
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
              fontWeight: FontWeight.w300,
              color: Colors.white,
            ),
              textAlign: TextAlign.center,
            ),
          ),
              SizedBox(height: 35), // Tambahkan jarak antar tombol


            Text("Belum Punya Akun? Daftar di sini",
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w100,
              color: Colors.black,
              fontSize: 10, 
            ),
           ),
              SizedBox(height:5),

            ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RegisterScreen()),
                        );
                      },
               style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFFFFF),
              shape: RoundedRectangleBorder(
               side :BorderSide(color: Color(0xFF61CA3D), width: 2),
                borderRadius: BorderRadius.circular(30.0), // Ganti dengan radius yang diinginkan
              ),
            ).copyWith(
              minimumSize: WidgetStateProperty.all(const Size(250, 50)), // Ganti dengan ukuran minimum yang diinginkan
            ),
            child: const Text('Sign Up',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 24,
              fontWeight: FontWeight. w300,
              color: Color(0xFF61CA3D),
            ),
              textAlign: TextAlign.center,
            ),
          ),
            SizedBox(height: 35),
          ],
        ),

      ),
      
    ),
    );
  }
}