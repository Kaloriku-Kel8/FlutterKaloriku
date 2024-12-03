import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

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
  String selectedCategory = 'Semua';
  String selectedCalorieRange = 'Semua Kalori';

  final List<Map<String, String>> categories = [
    {'kategori': 'Semua', 'gambar': 'assets/icons/all.png'},
    {'kategori': 'Sarapan', 'gambar': 'assets/images/home/breakfast.png'},
    {'kategori': 'Makan Siang', 'gambar': 'assets/icons/lunch.png'},
    {'kategori': 'Makan Malam', 'gambar': 'assets/icons/dinner.png'},
    {'kategori': 'Camilan', 'gambar': 'assets/icons/snack.png'},
  ];

  final List<Map<String, String>> mealData = [
    {'kategori': 'Sarapan', 'nama': 'Oatmeal', 'kalori': '300 Cal'},
    {'kategori': 'Makan Siang', 'nama': 'Nasi Ayam', 'kalori': '450 Cal'},
    {'kategori': 'Makan Malam', 'nama': 'Salad', 'kalori': '200 Cal'},
    {'kategori': 'Camilan', 'nama': 'Biskuit', 'kalori': '150 Cal'},
  ];

  final Map<String, List<int>> calorieRanges = {
    '50-200 Cal': [50, 200],
    '200-400 Cal': [200, 400],
    '400-600 Cal': [400, 600],
    '600-800 Cal': [600, 800],
  };

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) {
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
    double totalCalorie = 3138;
    double consumedCalorie = 1000;
    double remainingCalorie = totalCalorie - consumedCalorie;
    double progressValue = consumedCalorie / totalCalorie;

    List<Map<String, String>> filteredMeals = selectedCategory == 'Semua'
        ? mealData
        : mealData.where((meal) => meal['kategori'] == selectedCategory).toList();

    if (selectedCalorieRange != 'Semua Kalori') {
      final range = calorieRanges[selectedCalorieRange];
      filteredMeals = filteredMeals.where((meal) {
        final calories = int.tryParse(meal['kalori']!.split(' ')[0]) ?? 0;
        return calories >= range![0] && calories <= range[1];
      }).toList();
    }

    return Scaffold(
      backgroundColor: Colors.white,
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
            Material(
              elevation: 2,
              borderRadius: BorderRadius.circular(12),
              color: const Color.fromRGBO(227, 253, 222, 1.0),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text(
                          '${totalCalorie.toInt()} Cal',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const Text('Asupan Harian', style: TextStyle(fontSize: 10)),
                      ],
                    ),
                    SizedBox(
                      width: 150,
                      height: 150,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CustomCircularProgressIndicator(
                            progress: progressValue,
                            strokeWidth: 15,
                            backgroundColor: Colors.grey,
                            valueColor: Colors.blue,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${remainingCalorie.toInt()} Cal',
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const Text('Tersisa', style: TextStyle(fontSize: 10)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          '${consumedCalorie.toInt()} Cal',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const Text('Terpenuhi', style: TextStyle(fontSize: 10)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Filter kategori
            SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  final isSelected = selectedCategory == category['kategori'];

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedCategory = category['kategori']!;
                      });
                    },
                    child: Column(
                      children: [
                        CircleAvatar(
                          backgroundColor:
                              isSelected ? Colors.green : Colors.grey.shade200,
                          radius: 30,
                          backgroundImage: AssetImage(category['gambar']!),
                        ),
                        Text(category['kategori']!),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            // Filter kalori
            SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: calorieRanges.keys.length,
                itemBuilder: (context, index) {
                  final calorieRange = calorieRanges.keys.elementAt(index);
                  final isSelected = selectedCalorieRange == calorieRange;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedCalorieRange = isSelected ? 'Semua Kalori' : calorieRange;
                      });
                    },
                    child: Column(
                      children: [
                        CircleAvatar(
                          backgroundColor:
                              isSelected ? Colors.blue : Colors.grey.shade200,
                          radius: 30,
                          backgroundImage: AssetImage('assets/images/home/vegetable.png'),
                        ),
                        Text(calorieRange),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            // Display filtered meals
            ListView.builder(
              shrinkWrap: true,
              itemCount: filteredMeals.length,
              itemBuilder: (context, index) {
                final meal = filteredMeals[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: AssetImage(meal['gambar']!),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              meal['nama']!,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(meal['kalori']!),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Custom Circular Progress Indicator to show calorie progress
class CustomCircularProgressIndicator extends StatelessWidget {
  final double progress;
  final double strokeWidth;
  final Color backgroundColor;
  final Color valueColor;

  const CustomCircularProgressIndicator({
    required this.progress,
    required this.strokeWidth,
    required this.backgroundColor,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      value: progress,
      strokeWidth: strokeWidth,
      backgroundColor: backgroundColor,
      valueColor: AlwaysStoppedAnimation(valueColor),
    );
  }
}
