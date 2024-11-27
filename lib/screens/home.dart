import 'package:flutter/material.dart';
import 'register.dart';
import 'login.dart';
import 'package:flutter_svg/flutter_svg.dart';


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
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center, // Distribusi konten secara merata
            children: [
              const Align(
                alignment: Alignment.center,
              ),
              const SizedBox(height: 100),
              // Judul "KaloriKu"
              const Text(
                'KaloriKu',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF61CA3D),
                ),
              ),

              const SizedBox(height: 22),

              // Gambar
                        SvgPicture.asset(
                          'assets/images/login_regis/Vector Login.svg',
                          width: MediaQuery.of(context).size.width * 0.7,
                          height: MediaQuery.of(context).size.width * 0.7,
                        ),

              const SizedBox(height: 30),

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
                  minimumSize: WidgetStateProperty.all(const Size(250, 50)), // Ukuran minimum tombol disesuaikan dengan lebar layar
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

              const SizedBox(height: 35), // Tambahkan jarak antar tombol

              // Text "Belum Punya Akun? Daftar di sini"
              const Text(
                "Belum Punya Akun? Daftar di sini",
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                  fontSize: 10,
                ),
              ),

              const SizedBox(height: 5),

              // Tombol Sign Up
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RegisterScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFFFFF),
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(color: Color(0xFF61CA3D), width: 2),
                    borderRadius: BorderRadius.circular(30.0), // Ganti dengan radius yang diinginkan
                  ),
                ).copyWith(
                  minimumSize: WidgetStateProperty.all(const Size(250, 50)), // Ukuran minimum tombol disesuaikan dengan lebar layar
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