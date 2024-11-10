import 'package:flutter/material.dart';

class MultiStepFormScreen extends StatefulWidget {
  @override
  _MultiStepFormScreenState createState() => _MultiStepFormScreenState();
}

class _MultiStepFormScreenState extends State<MultiStepFormScreen> {
  int currentStep = 1;

  void _nextStep() {
    if (currentStep < 4) {
      setState(() {
        currentStep++;
      });
    }
  }

  void _previousStep() {
    if (currentStep > 1) {
      setState(() {
        currentStep--;
      });
    }
  }

  Widget _buildCurrentStep() {
    switch (currentStep) {
      case 1:
        return _buildStepOne();
      case 2:
        return _buildStepTwo();
      case 3:
        return _buildStepThree();
      case 4:
        return _buildStepFour();
      default:
        return _buildStepOne();
    }
  }

  Widget _buildStepOne() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Langkah 1 dari 4", style: TextStyle(color: Colors.black87)),
        SizedBox(height: 8),
        Text("Lengkapi data pada langkah 1", style: TextStyle(fontSize: 18)),
        // Tambahkan form atau input sesuai kebutuhan langkah 1
      ],
    );
  }

  Widget _buildStepTwo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Langkah 2 dari 4", style: TextStyle(color: Colors.black87)),
        SizedBox(height: 8),
        Text("Lengkapi data pada langkah 2", style: TextStyle(fontSize: 18)),
        // Tambahkan form atau input sesuai kebutuhan langkah 2
      ],
    );
  }

  Widget _buildStepThree() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Langkah 3 dari 4", style: TextStyle(color: Colors.black87)),
        SizedBox(height: 8),
        Text("Lengkapi data pada langkah 3", style: TextStyle(fontSize: 18)),
        // Tambahkan form atau input sesuai kebutuhan langkah 3
      ],
    );
  }

  Widget _buildStepFour() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Langkah 4 dari 4", style: TextStyle(color: Colors.black87)),
        SizedBox(height: 8),
        Text("Lengkapi data pada langkah 4", style: TextStyle(fontSize: 18)),
        // Tambahkan form atau input sesuai kebutuhan langkah 4
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Form Multi-Langkah"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCurrentStep(),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (currentStep > 1)
                  ElevatedButton(
                    onPressed: _previousStep,
                    child: Text("Kembali"),
                  ),
                ElevatedButton(
                  onPressed: _nextStep,
                  child: Text(currentStep < 4 ? "Lanjut" : "Selesai"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
