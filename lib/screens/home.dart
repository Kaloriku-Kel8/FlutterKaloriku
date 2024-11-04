import 'package:flutter/material.dart';
import 'register.dart';
import 'login.dart';

class HomeScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center, // Distribusi konten secara merata
            children: [
              SizedBox(height: 100),
              // Judul "KaloriKu"
              Text(
                'KaloriKu',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF61CA3D),
                ),
              ),

              SizedBox(height: 22),

              // Gambar
              Image.asset(
                'assets/images/gambar1.png',
                width: MediaQuery.of(context).size.width * 0.7, // Ukuran gambar disesuaikan dengan lebar layar
                height: MediaQuery.of(context).size.width * 0.7, // Ukuran gambar disesuaikan dengan lebar layar
              ),

              SizedBox(height: 30),

              // Tombol Login
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF61CA3D),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0), // Ganti dengan radius yang diinginkan
                  ),
                ).copyWith(
                  minimumSize: WidgetStateProperty.all(const Size(double.infinity, 50)), // Ukuran minimum tombol disesuaikan dengan lebar layar
                ),
                child: const Text(
                  'Login',
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

              // Text "Belum Punya Akun? Daftar di sini"
              Text(
                "Belum Punya Akun? Daftar di sini",
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w100,
                  color: Colors.black,
                  fontSize: 10,
                ),
              ),

              SizedBox(height: 5),

              // Tombol Sign Up
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
                    side: BorderSide(color: Color(0xFF61CA3D), width: 2),
                    borderRadius: BorderRadius.circular(30.0), // Ganti dengan radius yang diinginkan
                  ),
                ).copyWith(
                  minimumSize: MaterialStateProperty.all(const Size(double.infinity, 50)), // Ukuran minimum tombol disesuaikan dengan lebar layar
                ),
                child: const Text(
                  'Sign Up',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 24,
                    fontWeight: FontWeight.w300,
                    color: Color(0xFF61CA3D),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}