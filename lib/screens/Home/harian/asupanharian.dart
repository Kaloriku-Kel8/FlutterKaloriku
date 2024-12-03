import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:intl/intl.dart';
import '../home_menu.dart';
import 'package:kaloriku/screens/profil/profil.dart';

// Import necessary services and models
import 'package:kaloriku/model/kaloriKonsumsi.dart';
import 'package:kaloriku/service/kaloriKonsumsiService.dart';

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
  final KaloriKonsumsiService _kaloriKonsumsiService = KaloriKonsumsiService();

  // Mapping between UI categories and backend enum
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

  List<KonsumsiKalori> _todayMeals = [];
  double _totalCalorie = 3138; // Default total daily calorie
  double _consumedCalorie = 0;
  double _remainingCalorie = 0;

  @override
  void initState() {
    super.initState();
    _fetchTodayMeals();
  }

  // Fetch today's meals from backend
  Future<void> _fetchTodayMeals() async {
    try {
      final meals = await _kaloriKonsumsiService.getKonsumsiKaloriToday();
      
      setState(() {
        _todayMeals = meals;
        _consumedCalorie = meals.fold(0, (sum, meal) => sum + (meal.kaloriKonsumsi ?? 0));
        _remainingCalorie = _totalCalorie - _consumedCalorie;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching meals: $e')),
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
        MaterialPageRoute(builder: (context) => const ProfilScreen()),
      );
    }
  }

  Widget _buildFoodCategorySection(BuildContext context) {
    return Center(
      child: Wrap(
        spacing: 16,
        runSpacing: 16,
        children: _categoryMap.keys.map((category) {
          final isSelected = _selectedCategory == category;
          return _buildCategoryItem(
            Image.asset(
              isSelected ? _imagesBlack[category]! : _images[category]!,
              height: 50,
              width: 50,
            ),
            category,
            () {
              setState(() {
                _selectedCategory = _selectedCategory == category ? null : category;
              });
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

  // Filter meals based on selected category
  List<KonsumsiKalori> _getFilteredMeals() {
    if (_selectedCategory == null) return _todayMeals;
    
    return _todayMeals.where((meal) {
      final category = _categoryMap.keys.firstWhere(
        (key) => _categoryMap[key] == meal.waktuMakan,
        orElse: () => '',
      );
      return category == _selectedCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredMeals = _getFilteredMeals();
    final progressValue = _consumedCalorie / _totalCalorie;

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
                          '${_totalCalorie.toInt()} Cal',
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
                                '${_remainingCalorie.toInt()} Cal',
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
                          '${_consumedCalorie.toInt()} Cal',
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
            _buildFoodCategorySection(context),
            const SizedBox(height: 20),
            ...filteredMeals.map((meal) {
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(meal.namaMakanan ?? 'Unnamed Meal', 
                        style: const TextStyle(fontSize: 16)),
                      Text('${meal.kaloriKonsumsi?.toStringAsFixed(0) ?? '0'} Cal', 
                        style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}

// The CustomCircularProgressIndicator remains the same as in the original file
class CustomCircularProgressIndicator extends StatelessWidget {
  final double progress;
  final double strokeWidth;
  final Color backgroundColor;
  final Color valueColor;

  const CustomCircularProgressIndicator({
    required this.progress,
    this.strokeWidth = 8.0,
    this.backgroundColor = Colors.grey,
    this.valueColor = Colors.blue,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size.square(150),
      painter: _CircularProgressPainter(
        progress: progress,
        strokeWidth: strokeWidth,
        backgroundColor: backgroundColor,
        valueColor: valueColor,
      ),
    );
  }
}

class _CircularProgressPainter extends CustomPainter {
  final double progress;
  final double strokeWidth;
  final Color backgroundColor;
  final Color valueColor;

  _CircularProgressPainter({
    required this.progress,
    required this.strokeWidth,
    required this.backgroundColor,
    required this.valueColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawCircle(center, radius, backgroundPaint);

    final foregroundPaint = Paint()
      ..color = valueColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * 3.14159265359 * progress;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.14159265359 / 2,
      sweepAngle,
      false,
      foregroundPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}