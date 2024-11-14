import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'latihan.dart';
import 'riwayat.dart';
import 'saran_menu.dart';

void main() {
  MaterialApp(
  home: (HomeMenuScreen()
  ),
  );
}

class HomeMenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
      theme: ThemeData(
        fontFamily: 'Roboto',
        textTheme: ThemeData.light().textTheme.apply(
              fontFamily: 'Roboto',
            ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    double totalCalorie = 3138;
    double consumedCalorie = 1000;
    double remainingCalorie = totalCalorie - consumedCalorie;
    double progressValue = consumedCalorie / totalCalorie;

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
        unselectedItemColor: Colors.black,
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
              'Aktivitas Hari Ini',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(227, 253, 222, 1.0),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${totalCalorie.toInt()} Cal',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 0),
                      const Text(
                        'Asupan Harian',
                        style: TextStyle(
                          fontSize: 10,
                        ),
                      ),
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
                          backgroundColor: const Color.fromRGBO(85, 85, 85, 1.0),
                          valueColor: const Color.fromRGBO(113, 132, 237, 1.0),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${remainingCalorie.toInt()} Cal',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 0),
                            const Text(
                              'Tersisa',
                              style: TextStyle(fontSize: 10),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${consumedCalorie.toInt()} Cal',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 0),
                      const Text(
                        'Terpenuhi',
                        style: TextStyle(fontSize: 10),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(child: _buildFeatureButton(FluentIcons.history_48_regular, 'Riwayat', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RiwayatScreen()),
                  );
                })),
                const SizedBox(width: 40),
                Expanded(child: _buildFeatureButton(Icons.fitness_center, 'Latihan', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LatihanScreen()),
                  );
                })),
                const SizedBox(width: 40),
                Expanded(child: _buildFeatureButton(FluentIcons.food_48_regular, 'Saran Menu', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SaranMenuScreen()),
                  );
                })),
              ],
            ),
            const SizedBox(height: 20),
            _buildMealCard('Sarapan', '391 / 635 Cal', FluentIcons.food_toast_24_filled),
            _buildMealCard('Makan Siang', '856 / 847 Cal', Icons.lunch_dining),
            _buildMealCard('Makan Malam', '379 / 529 Cal', Icons.dinner_dining),
            _buildMealCard('Camilan', '159 / 200 Cal', FluentIcons.food_apple_24_filled),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureButton(IconData icon, String label, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(227, 253, 222, 1.0),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, size: 50, color: Colors.black),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(fontSize: 10)),
          ],
        ),
      ),
    );
  }

  Widget _buildMealCard(String title, String calories, dynamic icon) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: const Color.fromRGBO(227, 253, 222, 1.0),
      child: ListTile(
        leading: icon is String
            ? Image.asset(icon, width: 40, height: 40)
            : Icon(icon, size: 40, color: Colors.black),
        title: Text(title, style: const TextStyle(fontSize: 19)),
        subtitle: Text(calories, style: const TextStyle(fontSize: 10)),
        trailing: const Icon(FluentIcons.add_square_48_filled, size: 50, color: Colors.green),
      ),
    );
  }
}

class CustomCircularProgressIndicator extends StatelessWidget {
  final double progress;
  final double strokeWidth;
  final Color backgroundColor;
  final Color valueColor;

  const CustomCircularProgressIndicator({
    Key? key,
    required this.progress,
    this.strokeWidth = 15,
    this.backgroundColor = Colors.grey,
    this.valueColor = Colors.blue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(150),
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
    final angle = 2 * 3.14159265359 * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.14159265359 / 2,
      angle,
      false,
      foregroundPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
