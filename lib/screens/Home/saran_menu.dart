import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'home_menu.dart';

void main() {
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
      routes: {
        '/home': (context) => const HomeMenuScreen(),
      },
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
  String _selectedCategory = '';
  String _selectedCalorie = '';

  // Gambar default dan hitam putih untuk kategori makanan
  final Map<String, String> _images = {
    'Sarapan': 'assets/images/home/breakfast.png',
    'Siang': 'assets/images/home/lunch.png',
    'Malam': 'assets/images/home/dinner.png',
    'Camilan': 'assets/images/home/snack.png',
  };

  final Map<String, String> _imagesBlack = {
    'Sarapan': 'assets/images/home/breakfastblack.png',
    'Siang': 'assets/images/home/lunchblack.png',
    'Malam': 'assets/images/home/dinnerblack.png',
    'Camilan': 'assets/images/home/snackblack.png',
  };

  // Gambar default dan hitam putih untuk penghitung kalori
  final Map<String, String> _calorieImages = {
    '50-200 Cal': 'assets/images/home/vegetable.png',
    '200-400 Cal': 'assets/images/home/noodle.png',
    '400-600 Cal': 'assets/images/home/chicken.png',
    '600-800 Cal': 'assets/images/home/katsu.png',
  };

  final Map<String, String> _calorieImagesBlack = {
    '50-200 Cal': 'assets/images/home/vegetableblack.png',
    '200-400 Cal': 'assets/images/home/noodleblack.png',
    '400-600 Cal': 'assets/images/home/chickenblack.png',
    '600-800 Cal': 'assets/images/home/katsublack.png',
  };

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
        automaticallyImplyLeading: false,
        flexibleSpace: Material(
          elevation: 2,
          color: const Color.fromRGBO(248, 248, 248, 1.0),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: const Row(
              children: [
                SizedBox(width: 16),
                Text(
                  'Saran Menu dari Kami',
                  style: TextStyle(
                    fontSize: 20,
                    color: Color.fromRGBO(97, 202, 61, 1.0),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
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
              _buildSearchBar(),
              const SizedBox(height: 20),
              const Text(
                'Kategori Makanan',
                style: TextStyle(fontSize: 16, fontFamily: 'Mulish', fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _buildFoodCategorySection(),
              const SizedBox(height: 20),
              const Text(
                'Penghitung Kalori',
                style: TextStyle(fontSize: 16, fontFamily: 'Mulish' ,fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _buildCalorieSection(),
              const SizedBox(height: 20),
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

  Widget _buildSearchBar() {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(15),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Cari Makanan',
          hintStyle: const TextStyle(
            fontSize: 14,
            fontFamily: 'Mulish',
            color: Colors.grey,
          ),
          prefixIcon: const Icon(
            FluentIcons.search_12_regular,
            color: Colors.black,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: const Color.fromRGBO(248, 248, 248, 1.0),
        ),
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black,
        ),
        onChanged: (value) {
          print("Input pencarian: $value");
        },
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
          children: _images.keys.map((category) {
            final isSelected = _selectedCategory == category;
            return Row(
              children: [
                _buildCategoryItem(
                  Image.asset(
                    isSelected ? _imagesBlack[category]! : _images[category]!,
                    height: 40,
                    width: 40,
                  ),
                  category,
                  () {
                    setState(() {
                      _selectedCategory = category;
                    });
                  },
                  isSelected,
                ),
                const SizedBox(width: 2),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildCategoryItem(Widget iconWidget, String label, VoidCallback onTap, bool isSelected) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(11),
        ),
        child: Container(
          width: 109,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isSelected ? Colors.grey[300] : const Color.fromRGBO(248, 248, 248, 1.0),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 40, width: 40, child: iconWidget),
              const SizedBox(height: 5),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.black : Colors.grey,
                ),
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
          children: _calorieImages.keys.map((calorieRange) {
            final isSelected = _selectedCalorie == calorieRange;
            return Row(
              children: [
                _buildCalorieItem(
                  Image.asset(
                    isSelected
                        ? _calorieImagesBlack[calorieRange]!
                        : _calorieImages[calorieRange]!,
                    height: 40,
                    width: 40,
                  ),
                  calorieRange,
                  () {
                    setState(() {
                      _selectedCalorie = calorieRange;
                    });
                  },
                  isSelected,
                ),
                const SizedBox(width: 2),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildCalorieItem(
    Widget iconWidget,
    String label,
    VoidCallback onTap,
    bool isSelected,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          width: 108,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isSelected ? Colors.grey[300] : const Color.fromRGBO(248, 248, 248, 1.0),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 40, width: 40, child: iconWidget),
              const SizedBox(height: 5),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.black : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
