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
  String? _selectedCategory;
  final Map<String, String> _categoryMap = {
    'Sarapan': 'Sarapan',
    'Makan Siang': 'Makan Siang',
    'Makan Malam': 'Makan Malam',
    'Camilan': 'Camilan',
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

  final List<Map<String, String>> mealData = [
    {'kategori': 'Sarapan', 'nama': 'Oatmeal', 'kalori': '300 Cal'},
    {'kategori': 'Makan Siang', 'nama': 'Nasi Ayam', 'kalori': '450 Cal'},
    {'kategori': 'Makan Malam', 'nama': 'Salad', 'kalori': '200 Cal'},
    {'kategori': 'Camilan', 'nama': 'Biskuit', 'kalori': '150 Cal'},
  ];

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

  Widget _buildFoodCategorySection(BuildContext context) {
    return Center(
      child: Wrap(
        spacing: 16,
        runSpacing: 16,
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
                _selectedCategory = _selectedCategory == _categoryMap[category]
                    ? null
                    : _categoryMap[category];
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

  @override
  Widget build(BuildContext context) {
    double totalCalorie = 3138;
    double consumedCalorie = 1000;
    double remainingCalorie = totalCalorie - consumedCalorie;
    double progressValue = consumedCalorie / totalCalorie;

    List<Map<String, String>> filteredMeals = _selectedCategory == null
        ? mealData
        : mealData
            .where((meal) => meal['kategori'] == _selectedCategory)
            .toList();

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
                      Text(meal['nama']!, style: const TextStyle(fontSize: 16)),
                      Text(meal['kalori']!, style: const TextStyle(fontSize: 16)),
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

// Widget Kustom
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
