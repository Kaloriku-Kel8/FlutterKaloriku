import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:intl/intl.dart';
import '../home_menu.dart';
import 'package:kaloriku/screens/profil/profil.dart';
import 'package:kaloriku/screens/Pertanyaan/pertanyaan.dart';

// Updated imports
import 'package:kaloriku/model/kaloriKonsumsi.dart';
import 'package:kaloriku/service/kaloriKOnsumsiService.dart';

void main() {
  runApp(const AsupanHarianScreen());
}

class AsupanHarianScreen extends StatelessWidget {
  const AsupanHarianScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AsupanHarianHome(),
      theme: ThemeData(
        fontFamily: 'Roboto',
        textTheme: ThemeData.light().textTheme.apply(fontFamily: 'Roboto'),
      ),
    );
  }
}

class AsupanHarianHome extends StatefulWidget {
  const AsupanHarianHome({super.key});

  @override
  State<AsupanHarianHome> createState() => _AsupanHarianHomeState();
}

class _AsupanHarianHomeState extends State<AsupanHarianHome> {
  int _selectedIndex = 0;
  String? _selectedCategory;
  final KaloriKonsumsiService _kaloriService = KaloriKonsumsiService();

  double totalCalorie = 0;
  double consumedCalorie = 0;
  double remainingCalorie = 0;
  Color circleColor = Colors.blue;
  String status = 'Tersisa';
  String info = 'Kalori Masih Kurang';

  List<KonsumsiKalori> filteredMeals = [];
  double categoryTotalCalories = 0;

  final Map<String, WaktuMakan> _categoryMap = {
    'Sarapan': WaktuMakan.sarapan,
    'Makan Siang': WaktuMakan.makan_siang,
    'Makan Malam': WaktuMakan.makan_malam,
    'Camilan': WaktuMakan.cemilan,
  };

  final Map<String, String> _images = {
    'Sarapan': 'assets/images/home/breakfast.png',
    'Makan Siang': 'assets/images/home/lunch.png',
    'Makan Malam': 'assets/images/home/dinner.png',
    'Camilan': 'assets/images/home/snack.png',
  };

  final Map<String, String> _imagesBlack = {
    'Sarapan': 'assets/images/home/breakfastblack.png',
    'Makan Siang': 'assets/images/home/lunchblack.png',
    'Makan Malam': 'assets/images/home/dinnerblack.png',
    'Camilan': 'assets/images/home/snackblack.png',
  };

  @override
  void initState() {
    super.initState();
    _loadSummaryData();
  }

  Future<void> _loadSummaryData() async {
    try {
      final formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final response = await _kaloriService.updateSummary(formattedDate);

      setState(() {
        totalCalorie =
            double.tryParse(response['data']['target_kalori'].toString()) ?? 0;
        consumedCalorie =
            double.tryParse(response['data']['kalori_terpenuhi'].toString()) ??
                0;
        remainingCalorie = totalCalorie - consumedCalorie;

        if (remainingCalorie > 0) {
          circleColor = Colors.green;
          status = 'Tersisa';
          info = 'Kalori Masih Kurang Sebanyak :';
        } else if (remainingCalorie < 0) {
          circleColor = Colors.red;
          status = 'Melebihi Target Sebanyak : ';
          info = 'Kalori Melebihi Target'; // Status jika kalori lebih
          remainingCalorie = remainingCalorie
              .abs(); // Menampilkan nilai positif jika melebihi target
        } else {
          circleColor = Colors.blue;
          status = 'Memenuhi Target Kalori';
          info = 'Kalori Terpenuhi'; // Status jika kalori sesuai dengan target
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat data: $e')),
      );
    }
  }

  Future<void> _loadCategoryMeals(String category) async {
    try {
      final formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final waktuMakan = _categoryMap[category];
      if (waktuMakan == null) return;

      final response = await _kaloriService.getKonsumsiByDayAndCategory(
        formattedDate,
        waktuMakan.toString().split('.').last,
      );

      setState(() {
        final List<dynamic> konsumsiList = response['konsumsi'] ?? [];
        filteredMeals =
            konsumsiList.map((meal) => KonsumsiKalori.fromJson(meal)).toList();

        categoryTotalCalories =
            double.tryParse(response['total_kalori']?.toString() ?? '0') ?? 0;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat data kategori: $e')),
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
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => PertanyaanScreen()),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ProfilScreen()),
      );
    }
  }

  Widget _buildFoodCategorySection(BuildContext context) {
    return Column(
      children: _categoryMap.keys.map((category) {
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedCategory = category;
            });
            _loadCategoryMeals(category);
          },
          child: Card(
            color: _selectedCategory == category
                ? Colors.green.withOpacity(0.3)
                : Colors.white,
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
              child: Row(
                children: [
                  Image.asset(
                    _selectedCategory == category
                        ? _imagesBlack[category]!
                        : _images[category]!,
                    width: 40,
                    height: 40,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(category, style: const TextStyle(fontSize: 16)),
                        if (_selectedCategory == category)
                          Text(
                            '${categoryTotalCalories.toInt()} Cal',
                            style: const TextStyle(fontSize: 16),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMealsList() {
    if (filteredMeals.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('Belum ada makanan yang ditambahkan'),
        ),
      );
    }

    return Column(
      children: filteredMeals.map((meal) {
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      meal.namaMakanan ?? 'Unnamed Meal',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${meal.beratKonsumsi?.toStringAsFixed(0) ?? '0'} gram',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
                Text(
                  '${meal.kaloriKonsumsi?.toStringAsFixed(0) ?? '0'} Cal',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCalorieStatus() {
    return Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(12),
      color: const Color.fromRGBO(227, 253, 222, 1.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text(
                      '${totalCalorie.toInt()} Cal',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const Text('Target Harian', style: TextStyle(fontSize: 12)),
                  ],
                ),
                Column(
                  children: [
                    Icon(
                      Icons.circle,
                      size: 30,
                      color: circleColor,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      info,
                      style: TextStyle(
                          fontSize: 14,
                          color: circleColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      status,
                      style: TextStyle(
                          fontSize: 14,
                          color: circleColor,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${remainingCalorie.toInt()}',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            LinearProgressIndicator(
              value: totalCalorie > 0 ? consumedCalorie / totalCalorie : 0,
              backgroundColor: Colors.grey[300],
              color: circleColor,
              minHeight: 8,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Asupan Harian',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 16),
            _buildCalorieStatus(),
            const SizedBox(height: 20),
            _buildFoodCategorySection(context),
            const SizedBox(height: 20),
            _buildMealsList(),
          ],
        ),
      ),
    );
  }
}
