import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'home_menu.dart';
import '../profil/profil.dart';
import 'package:kaloriku/service/kaloriKonsumsiService.dart';
import 'package:percent_indicator/percent_indicator.dart';

void main() {
  runApp(const Riwayat());
}

class Riwayat extends StatelessWidget {
  const Riwayat({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green),
      home: const RiwayatScreen(),
    );
  }
}

class RiwayatScreen extends StatefulWidget {
  const RiwayatScreen({Key? key}) : super(key: key);

  @override
  State<RiwayatScreen> createState() => _RiwayatScreenState();
}

class _RiwayatScreenState extends State<RiwayatScreen> {
  int _selectedIndex = 0;
  late Future<List<Map<String, dynamic>>> _riwayatData;

  @override
  void initState() {
    super.initState();
    _riwayatData = KaloriKonsumsiService().getWeeklySummary();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Riwayat',
          style: TextStyle(
              color: Colors.white), // Changed to white for better contrast
        ),
        backgroundColor:
            Colors.green, // Dark green background for better contrast
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _riwayatData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final riwayatData = snapshot.data ?? [];
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: riwayatData.length,
            itemBuilder: (context, index) {
              final data = riwayatData[index];
              final total = double.tryParse(data["target_kalori"]) ?? 0;
              final terpenuhi = double.tryParse(data["kalori_terpenuhi"]) ?? 0;
              final tersisa = total - terpenuhi;
              final progressValue = total != 0 ? terpenuhi / total : 0;

              String status = '';
              Color circleColor = const Color.fromARGB(255, 81, 81, 81);

              if (tersisa < 0) {
                status =
                    'Melebihi Target ${(terpenuhi - total).toStringAsFixed(0)} Cal';
                circleColor = const Color.fromARGB(
                    255, 234, 72, 60); // Red for over target
              } else if (tersisa == 0) {
                status = 'Target Tepat';
                circleColor = const Color.fromARGB(
                    255, 80, 176, 83); // Green for target met
              } else {
                status = '${tersisa.toStringAsFixed(0)} Cal Tersisa';
                circleColor = const Color.fromARGB(
                    255, 61, 138, 201); // Blue for remaining calories
              }

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  color:
                      Colors.green.shade50, // Soft green background for cards
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data["tanggal"],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                status,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: circleColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularPercentIndicator(
                                radius: 60.0,
                                lineWidth: 15.0,
                                animation: true,
                                animationDuration: 1000,
                                percent: (progressValue > 1.0
                                        ? 1.0
                                        : (progressValue < 0.0
                                            ? 0.0
                                            : progressValue))
                                    .toDouble(),
                                center: Text(
                                  "${terpenuhi.toInt()} Cal",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                circularStrokeCap: CircularStrokeCap.round,
                                progressColor: circleColor,
                                backgroundColor: const Color(0xFFE5E5E5),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "${total.toStringAsFixed(0)} Cal",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                "Target Harian",
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Color.fromARGB(255, 50, 47, 47)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
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
        selectedItemColor: Colors.black, // Change to green for consistency
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        showUnselectedLabels: true,
        backgroundColor: Colors.white,
      ),
    );
  }

  BottomNavigationBarItem _buildBottomNavItem({
    required IconData icon,
    required String label,
  }) {
    return BottomNavigationBarItem(
      icon: Icon(icon),
      label: label,
    );
  }
}
