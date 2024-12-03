import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:kaloriku/model/dataUser.dart';
import 'package:kaloriku/service/userProfilService.dart';

class EditProfil extends StatefulWidget {
  final DataUser? dataUser;

  EditProfil({Key? key, required this.dataUser}) : super(key: key);

  @override
  _EditProfilState createState() => _EditProfilState();
}

class _EditProfilState extends State<EditProfil> {
  late DataUser _dataUser;
  final UserProfilService _userProfilService = UserProfilService();
  bool _isLoading = true;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    try {
      if (widget.dataUser != null) {
        _dataUser = widget.dataUser!;
      } else {
        _dataUser = await _userProfilService.getUserProfile();
      }

      _nameController.text = _dataUser.nama ?? '';
      _weightController.text = _dataUser.beratBadan?.toString() ?? '';
      _heightController.text = _dataUser.tinggiBadan?.toString() ?? '';

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal memuat data: $e")),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      _dataUser
        ..nama = _nameController.text
        ..beratBadan = double.tryParse(_weightController.text)
        ..tinggiBadan = double.tryParse(_heightController.text);

      final updatedUser = await _userProfilService.updateUserProfile(_dataUser);
      setState(() {
        _dataUser = updatedUser;
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Profil berhasil diperbarui")),
      );
      Navigator.pop(context, updatedUser);
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal memperbarui profil: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            FluentIcons.arrow_left_20_regular,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Edit Profil",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.green,
        elevation: 0,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTextField(
                        controller: _nameController,
                        label: "Nama",
                        hintText: "Masukkan nama lengkap",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Nama tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                      _buildDatePicker(
                        label: "Tanggal Lahir",
                        selectedDate: _dataUser.tanggalLahir,
                        onDateChanged: (date) {
                          setState(() {
                            _dataUser.tanggalLahir = date;
                          });
                        },
                      ),
                      _buildDropdown<JenisKelamin>(
                        label: "Jenis Kelamin",
                        hintText: "Pilih jenis kelamin",
                        value: _dataUser.jenisKelamin,
                        items: JenisKelamin.values,
                        itemToString: (item) => item == JenisKelamin.laki
                            ? "Laki-Laki"
                            : "Perempuan",
                        onChanged: (value) {
                          setState(() {
                            _dataUser.jenisKelamin = value;
                          });
                        },
                      ),
                      _buildTextField(
                        controller: _weightController,
                        label: "Berat Badan (kg)",
                        hintText: "Masukkan berat badan dalam kg",
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Berat badan tidak boleh kosong';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Masukkan angka yang valid';
                          }
                          return null;
                        },
                      ),
                      _buildTextField(
                        controller: _heightController,
                        label: "Tinggi Badan (cm)",
                        hintText: "Masukkan tinggi badan dalam cm",
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Tinggi badan tidak boleh kosong';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Masukkan angka yang valid';
                          }
                          return null;
                        },
                      ),
                      _buildDropdown<TingkatAktivitas>(
                        label: "Tingkat Aktivitas",
                        hintText: "Pilih tingkat aktivitas",
                        value: _dataUser.tingkatAktivitas,
                        items: TingkatAktivitas.values,
                        itemToString: (item) {
                          switch (item) {
                            case TingkatAktivitas.rendah:
                              return "Ringan";
                            case TingkatAktivitas.sedang:
                              return "Normal";
                            case TingkatAktivitas.tinggi:
                              return "Berat";
                          }
                        },
                        onChanged: (value) {
                          setState(() {
                            _dataUser.tingkatAktivitas = value;
                          });
                        },
                      ),
                      _buildDropdown<Tujuan>(
                        label: "Tujuan",
                        hintText: "Pilih tujuan Anda",
                        value: _dataUser.tujuan,
                        items: Tujuan.values,
                        itemToString: (item) {
                          switch (item) {
                            case Tujuan.menambah:
                              return "Menambah Berat Badan";
                            case Tujuan.menurunkan:
                              return "Mengurangi Berat Badan";
                            case Tujuan.mempertahankan:
                              return "Mempertahankan Berat Badan";
                          }
                        },
                        onChanged: (value) {
                          setState(() {
                            _dataUser.tujuan = value;
                          });
                        },
                      ),
                      SizedBox(height: 24),
                      Center(
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _updateProfile,
                          child: _isLoading
                              ? CircularProgressIndicator(color: Colors.white)
                              : Text("Simpan Perubahan"),
                          style: ElevatedButton.styleFrom(
                            elevation: 2,
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(),
          ),
          validator: validator,
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildDatePicker({
    required String label,
    DateTime? selectedDate,
    required Function(DateTime) onDateChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        GestureDetector(
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: selectedDate ?? DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
            );
            if (pickedDate != null) {
              onDateChanged(pickedDate);
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              selectedDate == null
                  ? "Pilih Tanggal Lahir"
                  : "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}",
            ),
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildDropdown<T>({
    required String label,
    required String hintText,
    T? value,
    required List<T> items,
    required String Function(T) itemToString,
    required Function(T?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        DropdownButtonFormField<T>(
          value: value,
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(),
          ),
          items: items
              .map((item) => DropdownMenuItem(
                    value: item,
                    child: Text(itemToString(item)),
                  ))
              .toList(),
          onChanged: onChanged,
        ),
        SizedBox(height: 16),
      ],
    );
  }
}
