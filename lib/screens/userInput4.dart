import 'package:flutter/material.dart';
import 'package:kaloriku/model/DataUser.dart';
import 'login.dart';

class StepFour extends StatelessWidget {
  final DataUser userData;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const StepFour({
    super.key,
    required this.onNext,
    required this.onBack,
    required this.userData,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        // Wrap Column with SingleChildScrollView
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 80), // Add padding to center vertically
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
                'assets/images/coba2.png',
                width: MediaQuery.of(context).size.width * 0.7,
                height: MediaQuery.of(context).size.width * 0.7,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 32),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF61CA3D),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 100, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ),
                    );
                  },
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
      ),
    );
  }
}
