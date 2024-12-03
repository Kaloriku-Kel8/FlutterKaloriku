import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:kaloriku/screens/Home/riwayat.dart';
import '../Home/home_menu.dart';
import 'editprofil.dart';

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
  int _selectedIndex = 2; // Index default untuk halaman Profil

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
      body: Padding(
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
            const Text(
              'Alfonso Mayzart',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
              child: const Text('Edit Profil', style: TextStyle(color: Colors.white),),
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('Usia', style: TextStyle(fontSize: 16)),
                Text('20 Tahun', style: TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('Jenis Kelamin', style: TextStyle(fontSize: 16)),
                Text('Laki-Laki', style: TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('Berat Badan', style: TextStyle(fontSize: 16)),
                Text('60 Kg', style: TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('Tinggi Badan', style: TextStyle(fontSize: 16)),
                Text('168 cm', style: TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('Tingkat Aktivitas', style: TextStyle(fontSize: 16)),
                Text('Rendah', style: TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('Tujuan', style: TextStyle(fontSize: 16)),
                Text('Menambah', style: TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('BMI', style: TextStyle(fontSize: 16)),
                Text('999', style: TextStyle(fontSize: 16)),
              ],
            ),
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
