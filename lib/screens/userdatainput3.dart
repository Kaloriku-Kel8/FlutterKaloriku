import 'package:flutter/material.dart';
import 'userdatainput4.dart';

class StepThree extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const StepThree({super.key, required this.onNext, required this.onBack});

  @override
  _StepThreeState createState() => _StepThreeState();
}

class _StepThreeState extends State<StepThree> {
  String? selectedGoal;

  void _onGoalSelected(String goal) {
    setState(() {
      selectedGoal = goal;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Langkah 3 dari 4",
              style: TextStyle(color: Colors.black87),
            ),
            const SizedBox(height: 8),
            const Text(
              "Lengkapi datamu dulu, yuk",
              style: TextStyle(
                fontFamily: 'Roboto',
                color: Color(0xFF61CA3D),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 50),
              const Align(
                alignment: Alignment.center,
                child: Text(
                  "Apa tujuan yang ingin kamu capai?",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black87),
                ),
              ),

            const SizedBox(height: 40),
            _buildGoalOption(
              title: "Menambah Berat Badan",
              value: "menambah",
            ),
            const SizedBox(height: 16),
            _buildGoalOption(
              title: "Mempertahankan",
              value: "mempertahankan",
            ),
            const SizedBox(height: 16),
            _buildGoalOption(
              title: "Mengurangi Berat Badan",
              value: "mengurangi",
            ),
            const SizedBox(height: 180),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF61CA3D),
                  padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                onPressed: selectedGoal != null 
                ? () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StepFour(onNext: () {}, onBack: () {}),
                    ),
                  );
                }
                
                : null,
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

  Widget _buildGoalOption({
    required String title,
    required String value,
  }) {
    return GestureDetector(
      onTap: () => _onGoalSelected(value),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: selectedGoal == value ? const Color(0xFF61CA3D) : Colors.grey,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Radio<String>(
              value: value,
              groupValue: selectedGoal,
              onChanged: (String? newValue) {
                _onGoalSelected(newValue!);
              },
              activeColor: const Color(0xFF61CA3D),
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'Roboto-Bold.ttf',
                fontSize: 20,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
