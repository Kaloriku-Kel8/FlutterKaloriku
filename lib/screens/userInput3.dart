import 'package:flutter/material.dart';
import 'package:kaloriku/model/dataUser.dart';
import 'package:kaloriku/service/userDataService.dart';
import 'userInput4.dart';

class StepThree extends StatefulWidget {
  final DataUser userData;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const StepThree({
    super.key,
    required this.userData,
    required this.onNext,
    required this.onBack,
  });

  @override
  _StepThreeState createState() => _StepThreeState();
}

class _StepThreeState extends State<StepThree>
    with SingleTickerProviderStateMixin {
  final UserDataService _dataUserService = UserDataService();
  bool _isLoading = false;
  String? _errorMessage;
  DataUser userData = DataUser();
  late AnimationController _animationController;
  late Animation<double> _animation;
  String? selectedGoal;

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

  void _onGoalSelected(String goal) {
    setState(() {
      selectedGoal = goal;
      widget.userData.tujuan = _mapGoalToEnum(goal);
    });
  }

  Tujuan _mapGoalToEnum(String goal) {
    switch (goal) {
      case 'menambah':
        return Tujuan.menambah;
      case 'mempertahankan':
        return Tujuan.mempertahankan;
      case 'menurunkan':
        return Tujuan.menurunkan;
      default:
        return Tujuan.mempertahankan;
    }
  }

  Future<void> _handleContinue() async {
    if (!_validateSelection()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await _dataUserService.inputData3(widget.userData.tujuan!);

      widget.onNext();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => StepFour(
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
    return selectedGoal != null;
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
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xFF61CA3D)),
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
        'Pilih Tujuan',
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
          _buildGoalOptions(),
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
          "Langkah 3 dari 4",
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
          "Apa tujuan yang ingin kamu capai?",
          style: TextStyle(
            fontSize: 18,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildGoalOptions() {
    return Column(
      children: [
        _buildGoalOption(
          title: "Menambah Berat Badan",
          description: "Meningkatkan berat badan secara sehat",
          value: "menambah",
        ),
        const SizedBox(height: 16),
        _buildGoalOption(
          title: "Mempertahankan",
          description: "Menjaga berat badan tetap ideal",
          value: "mempertahankan",
        ),
        const SizedBox(height: 16),
        _buildGoalOption(
          title: "Mengurangi Berat Badan",
          description: "Menurunkan berat badan secara sehat",
          value: "menurunkan",
        ),
      ],
    );
  }

  Widget _buildContinueButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor:
              _validateSelection() ? const Color(0xFF61CA3D) : Colors.grey[300],
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
            color: _validateSelection() && !_isLoading
                ? Colors.white
                : Colors.grey,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  Widget _buildGoalOption({
    required String title,
    required String description,
    required String value,
  }) {
    return GestureDetector(
      onTap: () => _onGoalSelected(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: selectedGoal == value
                ? const Color(0xFF61CA3D)
                : Colors.grey.shade300,
            width: selectedGoal == value ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
          color: selectedGoal == value
              ? const Color(0xFF61CA3D).withOpacity(0.1)
              : Colors.white,
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
