import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:kaloriku/screens/Home/riwayat.dart';
import '../Home/home_menu.dart';
import 'editprofil.dart';
import 'package:kaloriku/service/userprofilservice.dart';
import 'package:kaloriku/model/dataUser.dart';

void main() {
  runApp(const Profil());
}

class Profil extends StatelessWidget {
  const Profil({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green),
      home: const ProfilScreen(),
    );
  }
}

class ProfilScreen extends StatefulWidget {
  const ProfilScreen({Key? key}) : super(key: key);

  @override
  State<ProfilScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  int _selectedIndex = 2; 
  late UserProfilService _userProfilService;
  DataUser? _userData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _userProfilService = UserProfilService();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    try {
      final userData = await _userProfilService.getUserProfile();
      setState(() {
        _userData = userData;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeMenuScreen()),
      );
    } else if (index == 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Halaman Pertanyaan belum tersedia")),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const RiwayatScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text(
          'Profil',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _userData == null
              ? const Center(child: Text('Data pengguna tidak tersedia'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 50,
                        backgroundColor: Color.fromRGBO(209, 255, 193, 1.0),
                        child: Icon(
                          FluentIcons.person_12_regular,
                          size: 100,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _userData?.nama ?? 'Nama tidak tersedia',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => EditProfil()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Edit Profil',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 16),
                      _buildProfileRow('Usia', '${_userData?.umur ?? '-'} Tahun'),
                      _buildProfileRow('Jenis Kelamin', 
                          _userData?.jenisKelamin?.name ?? '-'),
                      _buildProfileRow('Berat Badan', 
                          '${_userData?.beratBadan?.toStringAsFixed(2) ?? '-'} Kg'),
                      _buildProfileRow('Tinggi Badan', 
                          '${_userData?.tinggiBadan?.toStringAsFixed(2) ?? '-'} cm'),
                      _buildProfileRow('Tingkat Aktivitas', 
                          _userData?.tingkatAktivitas?.name ?? '-'),
                      _buildProfileRow('Tujuan', 
                          _userData?.tujuan?.name ?? '-'),
                      _buildProfileRow('BMI', 
                          '${_userData?.bmi?.toStringAsFixed(2) ?? '-'}'),
                      _buildProfileRow('BMI Kategori', 
                          _userData?.bmiKategori?.name ?? '-'),
                      _buildProfileRow('Target Kalori', 
                          '${_userData?.targetKalori?.toStringAsFixed(2) ?? '-'} Kcal'),
                    ],
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
    );
  }

  Widget _buildProfileRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 16)),
        Text(value, style: const TextStyle(fontSize: 16)),
      ],
    );
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
}
