import 'package:flutter/material.dart';
import 'package:kaloriku/model/DataUser.dart';
import 'package:kaloriku/service/UserDataService.dart';
import 'userInput3.dart';

class StepTwo extends StatefulWidget {
  final DataUser userData;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const StepTwo({
    super.key,
    required this.userData,
    required this.onNext,
    required this.onBack,
  });

  @override
  _StepTwoState createState() => _StepTwoState();
}

class _StepTwoState extends State<StepTwo> with SingleTickerProviderStateMixin {
  final UserDataService _dataUserService = UserDataService();
  bool _isLoading = false;
  String? _errorMessage;
  DataUser userData = DataUser();
  late AnimationController _animationController;
  late Animation<double> _animation;
  String? selectedActivity;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onActivitySelected(String activity) {
    setState(() {
      selectedActivity = activity;
      widget.userData.tingkatAktivitas = _mapActivityToEnum(activity);
    });
  }

  TingkatAktivitas _mapActivityToEnum(String activity) {
    switch (activity) {
      case 'ringan':
        return TingkatAktivitas.rendah;
      case 'normal':
        return TingkatAktivitas.sedang;
      case 'berat':
        return TingkatAktivitas.tinggi;
      default:
        return TingkatAktivitas.rendah;
    }
  }

  Future<void> _handleContinue() async {
    if (!_validateSelection()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await _dataUserService.inputData2(widget.userData.tingkatAktivitas!);

      widget.onNext();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => StepThree(
            userData: widget.userData,
            onNext: () {},
            onBack: () {},
          ),
        ),
      );
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text(_errorMessage ?? 'Terjadi kesalahan'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  bool _validateSelection() {
    return selectedActivity != null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildCustomAppBar(),
        body: Stack(
          children: [
            FadeTransition(
              opacity: _animation,
              child: _buildBody(context),
            ),
            if (_isLoading)
              Container(
                color: Colors.black.withOpacity(0.3),
                child: const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF61CA3D)),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildCustomAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () {
          Navigator.pop(context);
          widget.onBack();
        },
      ),
      title: const Text(
        'Pilih Tingkat Aktivitas',
        style: TextStyle(color: Colors.black),
      ),
      centerTitle: true,
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderText(),
          const SizedBox(height: 24),
          _buildActivityOptions(),
          const SizedBox(height: 32),
          _buildContinueButton(context),
        ],
      ),
    );
  }

  Widget _buildHeaderText() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Langkah 2 dari 4",
          style: TextStyle(color: Colors.black87),
        ),
        SizedBox(height: 8),
        Text(
          "Lengkapi datamu dulu, yuk",
          style: TextStyle(
            fontFamily: 'Roboto',
            color: Color(0xFF61CA3D),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16),
        Text(
          "Kami ingin tahu seberapa aktif kamu dalam beraktivitas sehari-hari. Pilih kolom di bawah sesuai rutinitasmu, ya!",
          style: TextStyle(color: Colors.black87),
        ),
      ],
    );
  }

  Widget _buildActivityOptions() {
    return Column(
      children: [
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
      ],
    );
  }

  Widget _buildContinueButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: _validateSelection() ? const Color(0xFF61CA3D) : Colors.grey[300],
          padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        onPressed: _validateSelection() && !_isLoading ? _handleContinue : null,
        child: Text(
          _isLoading ? "Memproses..." : "Lanjut",
          style: TextStyle(
            fontFamily: 'Roboto',
            color: _validateSelection() && !_isLoading ? Colors.white : Colors.grey,
            fontSize: 18,
          ),
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
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: selectedActivity == value ? const Color(0xFF61CA3D) : Colors.grey.shade300,
            width: selectedActivity == value ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
          color: selectedActivity == value ? const Color(0xFF61CA3D).withOpacity(0.1) : Colors.white,
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
              child: Column(
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
