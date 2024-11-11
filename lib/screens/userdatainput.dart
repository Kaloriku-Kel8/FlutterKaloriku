import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'userdatainput2.dart';

class ProfileInputScreen extends StatefulWidget {
  const ProfileInputScreen({super.key});

  @override
  _ProfileInputScreenState createState() => _ProfileInputScreenState();
}

class _ProfileInputScreenState extends State<ProfileInputScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();

  String selectedGender = '';
  bool isFormComplete = false;

  void _validateForm() {
    setState(() {
      isFormComplete = nameController.text.isNotEmpty &&
          dobController.text.isNotEmpty &&
          weightController.text.isNotEmpty &&
          heightController.text.isNotEmpty &&
          selectedGender.isNotEmpty &&
          _isValidWeight(weightController.text) &&
          _isValidHeight(heightController.text);
    });
  }

  void _selectGender(String gender) {
    setState(() {
      selectedGender = gender;
      _validateForm();
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
      return Theme(
        data: ThemeData.light().copyWith(
          primaryColor: const Color(0xFFFFFFFF), // Warna untuk elemen utama
          buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary), colorScheme: const ColorScheme.light(primary: Colors.green).copyWith(secondary: Colors.green),
        ),
        child: child!,
      );
    },
  );
    

    if (pickedDate != null) {
      setState(() {
        dobController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
        _validateForm();
      });
    }
  }

  bool _isValidWeight(String input) {
    // Validasi berat badan dalam kg (angka positif)
    final num? value = num.tryParse(input);
    return value != null && value > 0;
  }

  bool _isValidHeight(String input) {
    // Validasi tinggi badan dalam cm (angka positif)
    final num? value = num.tryParse(input);
    return value != null && value > 0;
  }

  @override
  void initState() {
    super.initState();
    nameController.addListener(_validateForm);
    dobController.addListener(_validateForm);
    weightController.addListener(_validateForm);
    heightController.addListener(_validateForm);
  }

  @override
  void dispose() {
    nameController.dispose();
    dobController.dispose();
    weightController.dispose();
    heightController.dispose();
    super.dispose();
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.white,
    appBar: AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () {
      Navigator.pop(context); // Menambahkan logika untuk kembali ke halaman sebelumnya
        },
      ),
    ),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Langkah 1 dari 4",
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
          const SizedBox(height: 24),
          _buildTextField(
            label: "Nama",
            controller: nameController,
          ),
          const SizedBox(height: 16),
          _buildDateField(
            label: "Tanggal Lahir",
            controller: dobController,
            context: context,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Jenis Kelamin",
                style: TextStyle(
                  fontFamily: 'Roboto',
                  color: Colors.black87),
              ),
              Row(
                children: [
                  _buildGenderButton("Laki-laki"),
                  const SizedBox(width: 8),
                  _buildGenderButton("Perempuan"),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: "Berat badan (kg)",
            controller: weightController,
            isNumeric: true,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: "Tinggi Badan (cm)",
            controller: heightController,
            isNumeric: true,
          ),
          const SizedBox(height: 60), // Memberikan jarak sebelum tombol "Lanjut"
          if (isFormComplete)
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF61CA3D),
                  padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                onPressed: () {
                  // Logic for next step
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => StepTwo(onNext: () {  }, onBack: () {  })),
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
  );
}


  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    bool isNumeric = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.black87),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
          style: const TextStyle(
            fontFamily: 'Roboto',
          color: Colors.black87),
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF61CA3D)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color:Color(0xFF61CA3D)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF61CA3D), width: 2),
            ),
            errorText: _getErrorText(label, controller.text),
          ),
          cursorColor: Colors.green[600],
          onChanged: (value) => _validateForm(),
        ),
      ],
    );
  }

  String? _getErrorText(String label, String value) {
    if (label.contains("Berat badan") && !_isValidWeight(value)) {
      return "Masukkan berat badan dalam kg yang valid";
    } else if (label.contains("Tinggi Badan") && !_isValidHeight(value)) {
      return "Masukkan tinggi badan dalam cm yang valid";
    }
    return null;
  }

  Widget _buildDateField({
    required String label,
    required TextEditingController controller,
    required BuildContext context,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.black87),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          readOnly: true,
          onTap: () => _selectDate(context),
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF61CA3D)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF61CA3D)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF61CA3D), width: 2),
            ),
            suffixIcon: const Icon(Icons.calendar_today, color: Color(0xFF61CA3D)),
          ),
        ),
      ],
    );
  }

  Widget _buildGenderButton(String gender) {
    bool isSelected = selectedGender == gender;
    return ElevatedButton(
      onPressed: () => _selectGender(gender),
      style: ElevatedButton.styleFrom(
        foregroundColor: isSelected ? Colors.white : Colors.green,
        backgroundColor: isSelected ? Colors.green : Colors.white,
        side: const BorderSide(color: Color(0xFF61CA3D)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(gender),
    );
  }
}
