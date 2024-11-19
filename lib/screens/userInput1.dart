import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kaloriku/model/dataUser.dart';
import 'package:kaloriku/service/userDataService.dart';
import 'userInput2.dart';

class ProfileInputScreen extends StatefulWidget {
  const ProfileInputScreen({super.key});

  @override
  _ProfileInputScreenState createState() => _ProfileInputScreenState();
}

class _ProfileInputScreenState extends State<ProfileInputScreen> {
  DataUser userData = DataUser();
  final _dataUserService = UserDataService();
  bool isLoading = false;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();

  String selectedGender = '';
  bool isFormComplete = false;

  @override
  void dispose() {
    nameController.dispose();
    dobController.dispose();
    weightController.dispose();
    heightController.dispose();
    super.dispose();
  }

  void _showDialog(BuildContext context, String message,
      {bool isError = false}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: isError ? Colors.red[50] : Colors.green[100],
          title: Text(isError ? 'Error' : 'Pemberitahuan'),
          content: Text(message),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                if (!isError) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StepTwo(
                        userData: userData,
                        onNext: () {},
                        onBack: () {},
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _submitData(BuildContext context) async {
    setState(() => isLoading = true);

    try {
      _prepareDataForNextStep();
      final response = await _dataUserService.inputData1(userData);

      setState(() => isLoading = false);

      if (response.containsKey('error')) {
        _showDialog(
          context,
          response['error']['message'] ??
              'Terjadi kesalahan saat menyimpan data',
          isError: true,
        );
        return;
      }

      _showDialog(
        context,
        response['message'] ?? 'Data berhasil disimpan!',
        isError: false,
      );
    } catch (e) {
      setState(() => isLoading = false);
      _showDialog(context, 'Terjadi kesalahan: ${e.toString()}', isError: true);
    }
  }

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
      userData.jenisKelamin =
          gender == 'Laki-laki' ? JenisKelamin.laki : JenisKelamin.perempuan;
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
            colorScheme: ColorScheme.light(primary: Colors.green),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        dobController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
        userData.tanggalLahir = pickedDate;
        _validateForm();
      });
    }
  }

  void _prepareDataForNextStep() {
    userData.nama = nameController.text;
    userData.beratBadan = double.tryParse(weightController.text);
    userData.tinggiBadan = double.tryParse(heightController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   elevation: 0,
      //   backgroundColor: Colors.white,
      //   leading: IconButton(
      //     icon: const Icon(Icons.arrow_back, color: Colors.black),
      //     onPressed: () => Navigator.pop(context),
      //   ),
      // ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Langkah 1 dari 4",
                style: TextStyle(color: Colors.black87)),
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
            _buildTextField(label: "Nama", controller: nameController),
            const SizedBox(height: 16),
            _buildDateField(
                label: "Tanggal Lahir",
                controller: dobController,
                context: context),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Jenis Kelamin",
                    style: TextStyle(color: Colors.black87)),
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
                isNumeric: true),
            const SizedBox(height: 16),
            _buildTextField(
                label: "Tinggi Badan (cm)",
                controller: heightController,
                isNumeric: true),
            const SizedBox(height: 60),
            if (isFormComplete)
              Center(
                child: isLoading
                    ? const CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Color(0xFF61CA3D)))
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF61CA3D),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 100, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        onPressed: () => _submitData(context),
                        child: const Text("Lanjut",
                            style:
                                TextStyle(color: Colors.white, fontSize: 18)),
                      ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      {required String label,
      required TextEditingController controller,
      bool isNumeric = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.black87)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
          decoration: InputDecoration(
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFF61CA3D))),
            errorText: _getErrorText(label, controller.text),
          ),
          onChanged: (value) => _validateForm(),
        ),
      ],
    );
  }

  String? _getErrorText(String label, String value) {
    if (label.contains("Berat badan") && !_isValidWeight(value))
      return "Masukkan berat badan dalam kg yang valid";
    if (label.contains("Tinggi Badan") && !_isValidHeight(value))
      return "Masukkan tinggi badan dalam cm yang valid";
    return null;
  }

  Widget _buildDateField(
      {required String label,
      required TextEditingController controller,
      required BuildContext context}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.black87)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          readOnly: true,
          onTap: () => _selectDate(context),
          decoration: InputDecoration(
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFF61CA3D))),
            suffixIcon:
                const Icon(Icons.calendar_today, color: Color(0xFF61CA3D)),
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(gender),
    );
  }

  bool _isValidWeight(String weight) => double.tryParse(weight) != null;
  bool _isValidHeight(String height) => double.tryParse(height) != null;
}
