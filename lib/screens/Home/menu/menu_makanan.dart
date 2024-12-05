import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:kaloriku/screens/Pertanyaan/pertanyaan.dart';
import '../home_menu.dart';
import '../saran_menu.dart';
import 'tambah_menu.dart';
import 'package:kaloriku/screens/profil/profil.dart';
import 'package:kaloriku/model/resepMakanan.dart';
import 'package:kaloriku/service/resepMakananService.dart';

class FoodDetailScreen extends StatefulWidget {
  final int? resepId;

  const FoodDetailScreen({Key? key, this.resepId}) : super(key: key);

  @override
  _FoodDetailScreenState createState() => _FoodDetailScreenState();

  // Static method to navigate to detail screen
  static void navigateToDetail(BuildContext context, int resepId) {
    Navigator.pushNamed(context, '/detail', arguments: {'resepId': resepId});
  }
}

class _FoodDetailScreenState extends State<FoodDetailScreen> {
  int _selectedIndex = 0;
  ResepMakanan? _resep;
  bool _isLoading = true;
  String? _errorMessage;
  int? idResep; // Declare resepId here for state usage

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ??
            {};
    if (args.containsKey('resepId')) {
      idResep = args['resepId'];
      _fetchResepDetails();
    } else {
      setState(() {
        _errorMessage = 'ID Resep tidak ditemukan';
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchResepDetails() async {
    try {
      final resep = await ResepMakananService().getResepMakananById(idResep!);
      setState(() {
        _resep = resep;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeMenuScreen()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const PertanyaanScreen()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ProfilScreen()),
        );
        break;
    }
  }

  BottomNavigationBarItem _buildBottomNavItem({
    required IconData icon,
    required String label,
  }) {
    return BottomNavigationBarItem(
      icon: Icon(icon),
      label: label,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error: $_errorMessage'),
              ElevatedButton(
                onPressed: _fetchResepDetails,
                child: Text('Coba Lagi'),
              )
            ],
          ),
        ),
      );
    }

    if (_resep == null) {
      return Scaffold(
        body: Center(child: Text('Resep tidak ditemukan')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: Material(
          elevation: 2,
          color: const Color.fromRGBO(248, 248, 248, 1.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(FluentIcons.arrow_left_12_regular),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(width: 16),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          _buildBottomNavItem(
            icon: _selectedIndex == 0
                ? FluentIcons.home_12_filled
                : FluentIcons.home_12_regular,
            label: 'Beranda',
          ),
          _buildBottomNavItem(
            icon: _selectedIndex == 1
                ? FluentIcons.chat_12_filled
                : FluentIcons.chat_12_regular,
            label: 'Pertanyaan',
          ),
          _buildBottomNavItem(
            icon: _selectedIndex == 2
                ? FluentIcons.person_12_filled
                : FluentIcons.person_12_regular,
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: _resep?.gambar != null
                  ? Image.network(
                      _resep!.gambar!,
                      fit: BoxFit.cover,
                      height: 200,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 200,
                          color: Colors.grey[200],
                          child: const Center(
                            child: Icon(
                              Icons.image_not_supported,
                              size: 50,
                              color: Colors.grey,
                            ),
                          ),
                        );
                      },
                    )
                  : Container(
                      height: 200,
                      color: Colors.grey[200],
                      child: const Center(
                        child: Text('Gambar tidak tersedia'),
                      ),
                    ),
            ),
            const SizedBox(height: 16),
            Text(
              _resep?.namaResep ?? 'Nama Resep Tidak Tersedia',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  '${_resep?.kaloriMakanan?.toStringAsFixed(0) ?? '0'} Cal',
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.normal),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    _resep?.deskripsi ?? 'Deskripsi tidak tersedia',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TambahMenuScreen(resep: _resep),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.green,
                  elevation: 2,
                  minimumSize: const Size(150, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text('Tambah'),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
