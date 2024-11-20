import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'home_menu.dart';
import 'Kategori Makanan/menu_sarapan.dart';
import 'Kategori Makanan/menu_siang.dart';
import 'Kategori Makanan/menu_malam.dart';
import 'Kategori Makanan/menu_camilan.dart';
import 'Penghitung Kalori/50-200cal.dart';
import 'Penghitung Kalori/200-400cal.dart';
import 'Penghitung Kalori/400-600cal.dart';
import 'Penghitung Kalori/600-800cal.dart';

void main() {
  runApp(SaranMenuScreen());
}

class SaranMenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MenuSuggestionScreen(),
      theme: ThemeData(
        fontFamily: 'Roboto',
        textTheme: ThemeData.light().textTheme.apply(
              fontFamily: 'Roboto',
            ),
      ),
      routes: {
        '/home': (context) => HomeMenuScreen(),
        '/menu_sarapan': (context) => MenuSarapanScreen(),
        '/menu_siang': (context) => MenuSiangScreen(),
        '/menu_malam': (context) => MenuMalamScreen(),
        '/menu_camilan': (context) => MenuCamilanScreen(),
        '/50-200': (context) => Menu50_200Screen(),
        '/200-400': (context) => Menu200_400Screen(),
        '/400-600': (context) => Menu400_600Screen(),
        '/600-800': (context) => Menu600_800Screen(),
      },
    );
  }
}

class MenuSuggestionScreen extends StatefulWidget {
  @override
  _MenuSuggestionScreenState createState() => _MenuSuggestionScreenState();
}

class _MenuSuggestionScreenState extends State<MenuSuggestionScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.pushNamed(context, '/home'); // Navigasi ke halaman Beranda
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
  backgroundColor: Colors.transparent,
  elevation: 2,
  automaticallyImplyLeading: false,
  flexibleSpace: Container(
    padding: const EdgeInsets.symmetric(vertical: 10),
    decoration: const BoxDecoration(
      color: Color.fromRGBO(248, 248, 248, 1.0), // Warna latar belakang
    ),
    child: const Row(
      children: [
        SizedBox(width: 16), // Margin kiri
        Text(
          'Saran Menu dari Kami',
          style: TextStyle(
            fontSize: 20,
            color: Colors.green,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  ),
),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              const Text(
                'Kategori Makanan',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _buildFoodCategorySection(),
              const SizedBox(height: 20),
              const Text(
                'Penghitung Kalori',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _buildCalorieSection(),
              const SizedBox(height: 20),
              const SizedBox(height: 10),
              _buildRecipeCard(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              _selectedIndex == 0
                  ? FluentIcons.home_12_filled
                  : FluentIcons.home_12_regular,
            ),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              _selectedIndex == 1
                  ? FluentIcons.chat_12_filled
                  : FluentIcons.chat_12_regular,
            ),
            label: 'Pertanyaan',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              _selectedIndex == 2
                  ? FluentIcons.person_12_filled
                  : FluentIcons.person_12_regular,
            ),
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

  Widget _buildFoodCategorySection() {
  return SizedBox(
    height: 93,
    child: Center(
      child: ListView(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        children: [
          _buildCategoryItem(FluentIcons.food_toast_24_filled, 'Sarapan', '/menu_sarapan'),
          const SizedBox(width: 2),
          _buildCategoryItem(Icons.lunch_dining, 'Siang', '/menu_siang'),
          const SizedBox(width: 2),
          _buildCategoryItem(Icons.dinner_dining, 'Malam', '/menu_malam'),
          const SizedBox(width: 2),
          _buildCategoryItem(FluentIcons.food_apple_24_filled, 'Camilan', '/menu_camilan'),
        ],
      ),
    ),
  );
}


  Widget _buildCategoryItem(IconData icon, String label, String route) {
  return GestureDetector(
    onTap: () {
      Navigator.pushNamed(context, route);
    },
    child: Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(11),
      ),
      child: Container(
        width: 109,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(248, 248, 248, 1.0),
          borderRadius: BorderRadius.circular(11),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.black),
            const SizedBox(height: 5),
            Text(
              label,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    ),
  );
}


  Widget _buildRecipeCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
      elevation: 2,
      color: const Color.fromRGBO(248, 248, 248, 1.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Resep Hari Ini',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
            child: Image.network(
              'https://m.ftscrt.com/static/recipe/523b5e66-47cc-4d25-9d68-2ea36e9e8905.jpg',
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sate ayam dengan saus kacang, nasi, dan irisan timun.',
                  style: TextStyle(fontSize: 13),
                ),
                SizedBox(height: 5),
                Text(
                  '600-700 Cal',
                  style: TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalorieSection() {
  return SizedBox(
    height: 93,
    child: Center(
      child: ListView(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        children: [
          _buildCalorieItem(FluentIcons.food_carrot_24_filled, '50-200 Cal', '/50-200'),
          const SizedBox(width: 2),
          _buildCalorieItem(FluentIcons.food_egg_24_filled, '200-400 Cal', '/200-400'),
          const SizedBox(width: 2),
          _buildCalorieItem(FluentIcons.food_chicken_leg_24_filled, '400-600 Cal', '/400-600'),
          const SizedBox(width: 2),
          _buildCalorieItem(FluentIcons.food_pizza_24_filled, '600-800 Cal', '/600-800'),
        ],
      ),
    ),
  );
}


  Widget _buildCalorieItem(IconData icon, String label, String route) {
  return GestureDetector(
    onTap: () {
      Navigator.pushNamed(context, route);
    },
    child: Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        width: 108,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(248, 248, 248, 1.0),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.black),
            const SizedBox(height: 5),
            Text(
              label,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    ),
  );
}
}