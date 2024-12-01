import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:kaloriku/service/resepMakananService.dart';
import 'package:kaloriku/model/resepMakanan.dart';
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
  final _resepMakananService = ResepMakananService();
  int _selectedIndex = 0;
  KategoriResep? _selectedCategory;
  String? _selectedCalorie;
  List<ResepMakanan> _resepMakananList = [];
  bool _isLoading = false;
  String _searchKeyword = '';

  final Map<String, KategoriResep> _categoryMap = {
    'Sarapan': KategoriResep.sarapan,
    'Siang': KategoriResep.makan_siang,
    'Malam': KategoriResep.makan_malam,
    'Camilan': KategoriResep.cemilan,
  };

  final Map<String, List<int>> _calorieRanges = {
    '50-200 Cal': [50, 200],
    '200-400 Cal': [200, 400],
    '400-600 Cal': [400, 600],
    '600-800 Cal': [600, 800],
  };

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


  @override
  void initState() {
    super.initState();
    _fetchResepMakanan();
  }

  Future<void> _fetchResepMakanan() async {
    setState(() {
      _isLoading = true;
    });

    try {
      Map<String, dynamic> result = await _resepMakananService.filterAndSearchResepMakanan(
        kategori: _selectedCategory,
        kaloriMin: _selectedCalorie != null 
            ? _calorieRanges[_selectedCalorie]![0].toDouble() 
            : null,
        kaloriMax: _selectedCalorie != null 
            ? _calorieRanges[_selectedCalorie]![1].toDouble() 
            : null,
        keyword: _searchKeyword.isNotEmpty ? _searchKeyword : null,
      );

      setState(() {
        _resepMakananList = result['data'] is List
            ? List<ResepMakanan>.from(result['data'])
            : [];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat resep: $e')),
      );
    }
  }

  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.pushNamed(context, '/home');
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
          child: SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 10, 
                horizontal: 16
              ),
              child: Text(
                'Saran Menu dari Kami',
                style: TextStyle(
                  fontSize: 20,
                  color: const Color.fromRGBO(97, 202, 61, 1.0),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center, // Atur center
            children: [
              _buildSearchBar(context),
              const SizedBox(height: 16),
              _buildSectionTitle('Kategori Makanan'),
              const SizedBox(height: 8),
              _buildFoodCategorySection(context),
              const SizedBox(height: 16),
              _buildSectionTitle('Penghitung Kalori'),
              const SizedBox(height: 8),
              _buildCalorieSection(context),
              const SizedBox(height: 16),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _buildRecipeList(context),
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
    );
  }

  BottomNavigationBarItem _buildBottomNavItem({
    required IconData icon, 
    required String label
  }) {
    return BottomNavigationBarItem(
      icon: Icon(icon),
      label: label,
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16, 
        fontWeight: FontWeight.bold
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(15),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Cari Makanan',
          prefixIcon: const Icon(
            FluentIcons.search_12_regular,
            color: Colors.black,
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 12, 
            horizontal: 16
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: const Color.fromRGBO(248, 248, 248, 1.0),
        ),
        onChanged: (value) {
          setState(() {
            _searchKeyword = value;
          });
          _fetchResepMakanan();
        },
      ),
    );
  }

Widget _buildFoodCategorySection(BuildContext context) {
  return Center( // Memastikan semuanya di tengah
    child: Wrap(
      spacing: 16, // Jarak horizontal antar elemen
      runSpacing: 16, // Jarak vertikal antar elemen (jika ada overflow ke baris baru)
      children: _categoryMap.keys.map((category) {
        final isSelected = _selectedCategory == _categoryMap[category];
        return _buildCategoryItem(
          Image.asset(
            isSelected ? _imagesBlack[category]! : _images[category]!,
            height: 50,
            width: 50,
          ),
          category,
          () {
            setState(() {
              _selectedCategory =
                  _selectedCategory == _categoryMap[category]
                      ? null
                      : _categoryMap[category];
            });
            _fetchResepMakanan();
          },
          isSelected,
        );
      }).toList(),
    ),
  );
}

  Widget _buildCategoryItem(
    Widget icon, 
    String title, 
    VoidCallback onTap, 
    bool isSelected,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 90,
        width: 90,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: isSelected
              ? const Color.fromRGBO(97, 202, 61, 1.0)
              : const Color.fromRGBO(248, 248, 248, 1.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

Widget _buildCalorieSection(BuildContext context) {
  return Center(
    child: Wrap(
      spacing: 16, // Jarak antar elemen horizontal
      runSpacing: 16, // Jarak antar elemen vertikal jika ada overflow
      children: _calorieRanges.keys.map((range) {
        final isSelected = _selectedCalorie == range;
        return _buildCategoryItem(
          Image.asset(
            isSelected
                ? _calorieImagesBlack[range]!
                : _calorieImages[range]!,
            height: 50,
            width: 50,
          ),
          range,
          () {
            setState(() {
              _selectedCalorie = _selectedCalorie == range ? null : range;
            });
            _fetchResepMakanan();
          },
          isSelected,
        );
      }).toList(),
    ),
  );
}


Widget _buildRecipeList(BuildContext context) {
  return _resepMakananList.isEmpty
      ? Center( // Tambahkan Center
          child: const Text(
            'Tidak ada resep ditemukan',
            style: TextStyle(fontSize: 16),
          ),
        )
      : ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _resepMakananList.length,
          itemBuilder: (context, index) {
            final resep = _resepMakananList[index];
            return _buildRecipeCard(resep);
          },
        );
}

  Widget _buildRecipeCard(ResepMakanan resep) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                resep.namaResep ?? 'Nama resep tidak tersedia',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Kalori: ${resep.kaloriMakanan}',
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 8),
              Text(
                resep.deskripsi ?? 'Deskripsi tidak tersedia',
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}