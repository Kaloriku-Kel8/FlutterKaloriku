import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import '../home_menu.dart';
import '../saran_menu.dart';
import 'tambah_menu.dart';
import 'package:kaloriku/screens/profil/profil.dart';

void main() {
  runApp(MenuMakananScreen());
}

class MenuMakananScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const FoodDetailScreen(),
      theme: ThemeData(
        fontFamily: 'Roboto',
        textTheme: ThemeData.light().textTheme.apply(
              fontFamily: 'Roboto',
            ),
      ),
      routes: {
        '/home': (context) => const HomeMenuScreen(),
        '/saran': (context) => const SaranMenuScreen(),
        '/tambah': (context) => const TambahMenuScreen(), // Tambahkan rute ini
      },
    );
  }
}

class FoodDetailScreen extends StatefulWidget {
  const FoodDetailScreen({Key? key}) : super(key: key);

  @override
  _FoodDetailScreenState createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends State<FoodDetailScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (_selectedIndex == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeMenuScreen()),
      );
    } else if (_selectedIndex == 1) {
      // Dummy navigation
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Navigasi ke Pertanyaan belum diimplementasi")),
      );
    } else if (_selectedIndex == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ProfilScreen()),
      );
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
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const SaranMenuScreen()),
                    );
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
              child: Image.asset(
                'assets/images/home/sate.png',
                fit: BoxFit.cover,
                height: 200,
                width: double.infinity,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Sate ayam dengan saus kacang, nasi, dan irisan timun.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                Text('789 Cal', style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal)),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                Text('Resepnya aaaa', style: TextStyle(fontSize: 16)),
              ],
            ),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Navigasi ke TambahMenuScreen
                  Navigator.pushNamed(context, '/tambah');
                },
                child: const Text('Tambah'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.green,
                  elevation: 2,
                  minimumSize: const Size(150, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
