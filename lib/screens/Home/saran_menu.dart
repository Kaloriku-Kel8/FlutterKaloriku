import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'home_menu.dart'; // Import HomeMenuScreen dari home_menu.dart

void main()  {
  runApp(const SaranMenuScreen());

}

class SaranMenuScreen extends StatelessWidget {
  const SaranMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MenuSuggestionScreen(),
      theme: ThemeData(
        fontFamily: 'Roboto',
        textTheme: ThemeData.light().textTheme.apply(
              fontFamily: 'Roboto',
            ),
      ),
    );
  }
}

class MenuSuggestionScreen extends StatefulWidget {
  const MenuSuggestionScreen({super.key});

  @override
  _MenuSuggestionScreenState createState() => _MenuSuggestionScreenState();
}

class _MenuSuggestionScreenState extends State<MenuSuggestionScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeMenuScreen()),
      );
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
        title: const Text(
          'Saran Menu dari kami',
          style: TextStyle(color: Colors.green),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const Text(
              'Kategori Makanan',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildCategoryIcon(FluentIcons.food_toast_24_filled, 'Sarapan'),
                _buildCategoryIcon(Icons.lunch_dining, 'Siang'),
                _buildCategoryIcon(Icons.dinner_dining, 'Malam'),
                _buildCategoryIcon(FluentIcons.food_apple_24_filled, 'Camilan'),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Resep Hari Ini',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildRecipeCard(),
            const SizedBox(height: 20),
            const Text(
              'Penghitung Kalori',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildCalorieIcon(FluentIcons.food_carrot_24_filled, '50-100 Cal'),
                _buildCalorieIcon(FluentIcons.food_egg_24_filled, '200-300 Cal'),
                _buildCalorieIcon(FluentIcons.food_chicken_leg_24_filled, '400-500 Cal'),
                _buildCalorieIcon(FluentIcons.food_pizza_24_filled, '600-700 Cal'),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              _selectedIndex == 0 ? FluentIcons.home_12_filled : FluentIcons.home_12_regular,
            ),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              _selectedIndex == 1 ? FluentIcons.chat_12_filled : FluentIcons.chat_12_regular,
            ),
            label: 'Pertanyaan',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              _selectedIndex == 2 ? FluentIcons.person_12_filled : FluentIcons.person_12_regular,
            ),
            label: 'Profil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        onTap: _onItemTapped,
        showUnselectedLabels: true,
        backgroundColor: Colors.white,
      ),
    );
  }

  Widget _buildCategoryIcon(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, size: 40),
        const SizedBox(height: 5),
        Text(label),
      ],
    );
  }

  Widget _buildRecipeCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 2,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
            child: Image.network(
              'https://m.ftscrt.com/static/recipe/523b5e66-47cc-4d25-9d68-2ea36e9e8905.jpg', // Replace with actual image URL
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
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 5),
                Text(
                  '600-700 Cal',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalorieIcon(dynamic iconOrPath, String label) {
    return Column(
      children: [
        if (iconOrPath is IconData)
          Icon(iconOrPath, size: 40)
        else if (iconOrPath is String)
          Image.asset(
            iconOrPath,
            width: 40,
            height: 40,
          ),
        const SizedBox(height: 5),
        Text(label),
      ],
    );
  }
}
