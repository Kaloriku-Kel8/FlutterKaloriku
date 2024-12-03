import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'profil.dart'; // Pastikan file ini ada

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green),
      home: EditProfil(),
    ),
  );
}

class EditProfil extends StatefulWidget {
  @override
  _EditProfilState createState() => _EditProfilState();
}

class _EditProfilState extends State<EditProfil> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();

  DateTime? _selectedDate;
  String? _gender;
  String? _activityLevel;
  String? _goal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            IconButton(
              icon: Icon(
                FluentIcons.arrow_left_20_regular,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context); // Kembali ke layar sebelumnya
              },
            ),
            Text("Edit Profil"),
          ],
        ),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Nama",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: "Masukkan nama lengkap",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              Text(
                "Tanggal Lahir",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _selectedDate = pickedDate;
                    });
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _selectedDate == null
                        ? "Pilih Tanggal Lahir"
                        : "${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}",
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                "Jenis Kelamin",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              DropdownButtonFormField<String>(
                dropdownColor: Colors.white,
                value: _gender,
                decoration: InputDecoration(
                  hintText: "Pilih jenis kelamin",
                  border: OutlineInputBorder(),
                ),
                items: ["Laki-Laki", "Perempuan"]
                    .map((gender) => DropdownMenuItem(
                          value: gender,
                          child: Text(gender),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _gender = value;
                  });
                },
              ),
              SizedBox(height: 16),
              Text(
                "Berat Badan (kg)",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: _weightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "Masukkan berat badan dalam kg",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              Text(
                "Tinggi Badan (cm)",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: _heightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "Masukkan tinggi badan dalam cm",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              Text(
                "Tingkat Aktivitas",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              DropdownButtonFormField<String>(
                dropdownColor: Colors.white,
                value: _activityLevel,
                decoration: InputDecoration(
                  hintText: "Pilih tingkat aktivitas",
                  border: OutlineInputBorder(),
                ),
                items: ["Ringan", "Normal", "Berat"]
                    .map((level) => DropdownMenuItem(
                          value: level,
                          child: Text(level),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _activityLevel = value;
                  });
                },
              ),
              SizedBox(height: 16),
              Text(
                "Tujuan",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              DropdownButtonFormField<String>(
                dropdownColor: Colors.white,
                value: _goal,
                decoration: InputDecoration(
                  hintText: "Pilih tujuan Anda",
                  border: OutlineInputBorder(),
                ),
                items: [
                  "Menambah Berat Badan",
                  "Mempertahankan Berat Badan",
                  "Mengurangi Berat Badan"
                ]
                    .map((goal) => DropdownMenuItem(
                          value: goal,
                          child: Text(goal),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _goal = value;
                  });
                },
              ),
              SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Navigasi ke halaman Profil
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Profil(), // Ganti dengan halaman Profil
                      ),
                    );
                  },
                  child: Text("Selesai"),
                  style: ElevatedButton.styleFrom(
                    elevation: 2,
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
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
