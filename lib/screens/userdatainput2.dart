import 'package:flutter/material.dart';
import 'userdatainput3.dart'; // Pastikan ini adalah halaman tujuan yang benar

class StepTwo extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const StepTwo({super.key, required this.onNext, required this.onBack});

  @override
  _StepTwoState createState() => _StepTwoState();
}

class _StepTwoState extends State<StepTwo> {
  String? selectedActivity;

  void _onActivitySelected(String activity) {
    setState(() {
      selectedActivity = activity;
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
              "Langkah 2 dari 4",
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
            const SizedBox(height: 16),
            const Text(
              "Kami ingin tahu seberapa aktif kamu dalam beraktivitas sehari-hari. Pilih kolom di bawah sesuai rutinitasmu, ya!",
              style: TextStyle(color: Colors.black87),
            ),
            const SizedBox(height: 24),
            _buildActivityOption(
              title: "Aktivitas Ringan",
              description: "Seharian duduk (contoh: pekerja kantoran)",
              value: "ringan",
            ),
            const SizedBox(height: 16),
            _buildActivityOption(
              title: "Aktivitas Normal",
              description: "Sering berjalan dalam waktu yang lama (contoh: pekerja lapangan)",
              value: "normal",
            ),
            const SizedBox(height: 16),
            _buildActivityOption(
              title: "Aktivitas Berat",
              description: "Aktivitas berat (contoh: pekerja bangunan, atlet)",
              value: "berat",
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
                
              onPressed: selectedActivity != null
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StepThree(onNext: () {}, onBack: () {}),
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

  Widget _buildActivityOption({
    required String title,
    required String description,
    required String value,
  }) {
    return GestureDetector(
      onTap: () => _onActivitySelected(value),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: selectedActivity == value ? const Color(0xFF61CA3D) : Colors.grey,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Radio<String>(
              value: value,
              groupValue: selectedActivity,
              onChanged: (String? newValue) {
                _onActivitySelected(newValue!);
              },
              activeColor: const Color(0xFF61CA3D),
            ),
            const SizedBox(width: 8),
            Expanded(
            child:Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ), 
        ],
         
        ),
      ),
    );
  }
}
