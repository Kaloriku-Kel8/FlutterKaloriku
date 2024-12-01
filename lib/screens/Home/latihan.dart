import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'home_menu.dart';
import 'latihan/listlatihan.dart';

void main() {
  runApp(const LatihanApp());
}

class LatihanApp extends StatelessWidget {
  const LatihanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Latihan',
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.white, // Atur background menjadi putih
        fontFamily: 'Roboto', // Set font default
        ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LatihanScreen(),
        '/home': (context) => const HomeMenuScreen(),
        '/list': (context) => const ListLatihan(),
      },
    );
  }
}

class LatihanScreen extends StatefulWidget {
  const LatihanScreen({super.key});

  @override
  State<LatihanScreen> createState() => _LatihanScreenState();
}

class _LatihanScreenState extends State<LatihanScreen> {
  int _selectedIndex = 0;

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
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Halaman Profil belum tersedia")),
    );
  }
}



 @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.white, // Pastikan latar belakang Scaffold putih
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Pilih latihan",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 0), // Atur jarak
          const Text(
            "yang ingin anda lakukan",
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
          const SizedBox(height: 16), // Atur jarak
          Expanded(
            child: ListView(
              children: [
                latihanCard(context, "Kardio", "assets/images/home/cardio.jpeg"),
                latihanCard(context, "Upper Body", "assets/images/home/upperbody.jpeg"),
                latihanCard(context, "Lower Body", "assets/images/home/lowerbodu.jpeg"),
              ],
            ),
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
      backgroundColor: Colors.white, // Background BottomNavigationBar putih
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

  Widget latihanCard(BuildContext context, String title, String imagePath) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ListLatihanScreen(latihanType: title),
            ),
          );
        },
        child: SizedBox(
          height: 250,
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  imagePath,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.black.withOpacity(0.4),
                ),
              ),
              Positioned(
                left: 16,
                bottom: 16,
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Positioned(
                right: 16,
                bottom: 16,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                      vertical: 8, horizontal: 16),
                  child: const Text(
                    "Mulai",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
