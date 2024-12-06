import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:intl/intl.dart';

// Import halaman lain
import 'package:kaloriku/screens/ui_makanan/ui_sarapan.dart';
import 'package:kaloriku/screens/ui_makanan/ui_makanMalam.dart';
import 'package:kaloriku/screens/ui_makanan/ui_makanSiang.dart';
import 'package:kaloriku/screens/ui_makanan/ui_cemilan.dart';
import '../Pertanyaan/pertanyaan.dart';

import 'latihan.dart';
import 'riwayat.dart';
import 'saran_menu.dart';
import 'harian/asupanharian.dart';
import '../profil/profil.dart';
import 'package:kaloriku/service/kaloriKonsumsiService.dart';



class HomeMenuScreen extends StatelessWidget {
  const HomeMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
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
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  double totalCalorie = 0;
  double consumedCalorie = 0;
  double remainingCalorie = 0;
  double progressValue = 0;
  bool _isLoading = false;

  Map<String, double> targetCalories = {};
  Map<String, double> consumedCalories = {};
  final _kaloriService = KaloriKonsumsiService();

  Color circleColor = Colors.blue; // Menambahkan nilai default
  String status = 'Target Tepat'; // Menambahkan status default

  @override
  void initState() {
    super.initState();
    _loadSummaryData(); // Memanggil fungsi untuk memuat data saat aplikasi dimulai
    _loadAllMealData();
  }

  Future<void> _loadSummaryData() async {
    try {
      final formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final response = await _kaloriService.updateSummary(formattedDate);

      setState(() {
        totalCalorie = response['data']['target_kalori'] ?? 0;
        consumedCalorie =
            double.tryParse(response['data']['kalori_terpenuhi'].toString()) ??
                0;
        remainingCalorie = totalCalorie - consumedCalorie;
        progressValue = totalCalorie > 0 ? consumedCalorie / totalCalorie : 0;
        _calculateTargetCalories();
        if (remainingCalorie > 0) {
          circleColor = Colors.green; // Kalori masih tersisa
          status = 'Tersisa';
        } else if (remainingCalorie < 0) {
          circleColor = Colors.red; // Kalori melebihi target
          status = 'Melebihi Target';
          remainingCalorie = remainingCalorie * -1;
        } else {
          circleColor = Colors.blue; // Kalori tepat sesuai target
          status = 'Target Tepat';
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat data: $e')),
      );
    }
  }

  void _calculateTargetCalories() {
    targetCalories = {
      'sarapan': totalCalorie * 0.2, // 20% for breakfast
      'makan_siang': totalCalorie * 0.4, // 40% for lunch
      'makan_malam': totalCalorie * 0.3, // 30% for dinner
      'cemilan': totalCalorie * 0.1 // 10% for snacks
    };
  }

  Future<void> _loadAllMealData() async {
    final date = DateFormat('yyyy-MM-dd').format(DateTime.now());

    try {
      // Fetch data for each meal category
      final categories = ['sarapan', 'makan_siang', 'makan_malam', 'cemilan'];

      for (var category in categories) {
        final response =
            await _kaloriService.getKonsumsiByDayAndCategory(date, category);
        setState(() {
          consumedCalories[category] =
              response['total_kalori']?.toDouble() ?? 0.0;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat data makanan: $e')),
      );
    }
  }

  void _onItemTapped(int index) async {
    if (_isLoading) return; // Prevent multiple taps while loading

    setState(() {
      _selectedIndex = index;
      _isLoading = true;
    });

    // Add artificial delay
    await Future.delayed(const Duration(milliseconds: 3000));

    if (!mounted) return;

    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const PertanyaanScreen()),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ProfilScreen()),
      );
    }

    setState(() {
      _isLoading = false;
    });
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
              'Aktivitas Hari Ini',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 16),
            _buildSummaryCard(),
            const SizedBox(height: 20),
            _buildFeatureRow(),
            const SizedBox(height: 20),
// Inside the build method:
            _buildMealCard(
              'Sarapan',
              'sarapan',
              'assets/images/home/breakfast.png',
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Sarapan()),
                );
              },
            ),
            _buildMealCard(
              'Makan Siang',
              'makan_siang',
              'assets/images/home/lunch.png',
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MakanSiang()),
                );
              },
            ),
            _buildMealCard(
              'Makan Malam',
              'makan_malam',
              'assets/images/home/dinner.png',
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MakanMalam()),
                );
              },
            ),
            _buildMealCard('Cemilan', 'cemilan', 'assets/images/home/snack.png',
                () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Cemilan()),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Material(
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
            _buildSummaryColumn('${totalCalorie.toInt()} Cal', 'Asupan Harian'),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AsupanHarianScreen(),
                  ),
                );
              },
              child: SizedBox(
                width: 150,
                height: 150,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CustomCircularProgressIndicator(
                      progress: progressValue,
                      strokeWidth: 15,
                      backgroundColor: const Color.fromRGBO(85, 85, 85, 1.0),
                      valueColor:
                          circleColor, // Menyesuaikan dengan warna dinamis
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${remainingCalorie.toInt()} Cal',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color:
                                circleColor, // Mengubah warna berdasarkan status
                          ),
                        ),
                        Text(
                          status,
                          style: TextStyle(
                            fontSize: 10,
                            color:
                                circleColor, // Mengubah warna berdasarkan status
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            _buildSummaryColumn('${consumedCalorie.toInt()} Cal', 'Terpenuhi'),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryColumn(String value, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 0),
        Text(
          label,
          style: const TextStyle(fontSize: 10),
        ),
      ],
    );
  }

  Widget _buildFeatureRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          child: _buildFeatureButton(
            Image.asset('assets/images/home/history.png'),
            'Riwayat',
            () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RiwayatScreen()),
              );
            },
          ),
        ),
        const SizedBox(width: 40),
        Expanded(
          child: _buildFeatureButton(
            Image.asset('assets/images/home/exercise.png'),
            'Latihan',
            () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LatihanScreen()),
              );
            },
          ),
        ),
        const SizedBox(width: 40),
        Expanded(
          child: _buildFeatureButton(
            Image.asset('assets/images/home/eat.png'),
            'Saran Menu',
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const SaranMenuScreen()),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureButton(
      Widget iconWidget, String label, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Material(
        elevation: 2, // Menambahkan elevation untuk efek bayangan
        borderRadius: BorderRadius.circular(8),
        color: Colors
            .transparent, // Transparan untuk mempertahankan warna dari Container
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color.fromRGBO(227, 253, 222, 1.0),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 50, width: 50, child: iconWidget),
              const SizedBox(height: 4),
              Text(label, style: const TextStyle(fontSize: 10)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMealCard(
      String title, String category, String imageAsset, VoidCallback onTap) {
    // Convert title to category format (e.g., "Makan Siang" to "makan_siang")
    final categoryKey = category.toLowerCase().replaceAll(' ', '_');

    // Get target and consumed calories for this category
    final targetCal = targetCalories[categoryKey] ?? 0.0;
    final consumedCal = consumedCalories[categoryKey] ?? 0.0;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: const Color.fromRGBO(227, 253, 222, 1.0),
      child: GestureDetector(
        onTap: onTap, // Memanggil onTap ketika card ditekan
        child: ListTile(
          leading: Image.asset(
              imageAsset), // Jika `icon` adalah IconData, bungkus dengan `Icon`.
          title: Text(title, style: const TextStyle(fontSize: 19)),
          subtitle: Text('${consumedCal.toInt()} / ${targetCal.toInt()} Cal',
              style: const TextStyle(fontSize: 10)),
          trailing: const Icon(FluentIcons.add_square_48_filled,
              size: 50, color: Colors.green),
        ),
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
    super.key,
    required this.progress,
    this.strokeWidth = 15,
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
