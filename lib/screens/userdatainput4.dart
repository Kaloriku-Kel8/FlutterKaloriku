import 'package:flutter/material.dart';

class StepFour extends StatelessWidget {
  final VoidCallback onNext;

  const StepFour({super.key, required this.onNext, required Null Function() onBack});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Datamu sudah lengkap, nih!",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Yuk, lanjutkan perjalananmu!",
              style: TextStyle(
                fontFamily: 'Roboto',
                color: Color(0xFF61CA3D),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            Image.asset(
              'assets/images/coba2.png', // Ganti dengan path gambar yang benar
                width: MediaQuery.of(context).size.width * 0.7,
                height: MediaQuery.of(context).size.width * 0.7 // Anda dapat menyesuaikan tinggi atau ukuran gambar
            ),
            const SizedBox(height: 32),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF61CA3D),
                  padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                onPressed: onNext,
                child: const Text(
                  "Lanjut",
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
