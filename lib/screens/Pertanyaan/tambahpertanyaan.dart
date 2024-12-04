import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import '../Home/home_menu.dart';
import '../profil/profil.dart';
import 'pertanyaan.dart';
import 'package:kaloriku/service/forumService.dart';
import 'package:kaloriku/model/qna.dart';
import 'dart:convert'; // Add this import

class BuatPertanyaanScreen extends StatelessWidget {
  const BuatPertanyaanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BuatPertanyaanPage(),
      theme: ThemeData(
        fontFamily: 'Roboto',
        textTheme: ThemeData.light().textTheme.apply(fontFamily: 'Roboto'),
      ),
    );
  }
}

class BuatPertanyaanPage extends StatefulWidget {
  @override
  _BuatPertanyaanPageState createState() => _BuatPertanyaanPageState();
}

class _BuatPertanyaanPageState extends State<BuatPertanyaanPage> {
  int _selectedIndex = 1;
  final ForumService _forumService = ForumService();
  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  bool _isLoading = false;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeMenuScreen()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => PertanyaanScreen()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ProfilScreen()),
        );
        break;
    }
  }

  Future<void> _postPertanyaan() async {
    final String judul = _judulController.text.trim();
    final String deskripsi = _deskripsiController.text.trim();

    if (judul.isEmpty || deskripsi.isEmpty) {
      _showSnackBar('Judul dan deskripsi tidak boleh kosong');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final Qna newQuestion = await _forumService.createQuestion(
        judul,
        deskripsi,
      );

      if (mounted) {
        _showSnackBar('Pertanyaan berhasil dibuat');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => PertanyaanScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar(e.toString().replaceAll('Exception: ', ''));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSnackBar(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Buat Pertanyaan',
          style: TextStyle(color: Colors.green),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => PertanyaanScreen()),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildInputContainer(
                title: 'Tulis Judul',
                hintText: 'Masukkan judul pertanyaan...',
                controller: _judulController,
                maxLines: 1,
              ),
              const SizedBox(height: 16),
              _buildInputContainer(
                title: 'Tulis Deskripsi',
                hintText: 'Jelaskan detail pertanyaan Anda...',
                controller: _deskripsiController,
                maxLines: 5,
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _postPertanyaan,
                  icon: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.send, color: Colors.white),
                  label: Text(_isLoading ? 'Mengirim...' : 'Post'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    disabledBackgroundColor: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(FluentIcons.home_12_regular),
            activeIcon: Icon(FluentIcons.home_12_filled),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(FluentIcons.chat_12_regular),
            activeIcon: Icon(FluentIcons.chat_12_filled),
            label: 'Pertanyaan',
          ),
          BottomNavigationBarItem(
            icon: Icon(FluentIcons.person_12_regular),
            activeIcon: Icon(FluentIcons.person_12_filled),
            label: 'Profil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        showUnselectedLabels: true,
        backgroundColor: Colors.white,
      ),
    );
  }

  Widget _buildInputContainer({
    required String title,
    required String hintText,
    required TextEditingController controller,
    required int maxLines,
  }) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          TextField(
            controller: controller,
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: hintText,
              border: InputBorder.none,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _judulController.dispose();
    _deskripsiController.dispose();
    super.dispose();
  }
}
