import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'menu_makanan.dart';
import '../home_menu.dart';

void main() {
  runApp(const TambahMenuApp());
}

class TambahMenuApp extends StatelessWidget {
  const TambahMenuApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const TambahMenuScreen(),
    );
  }
}

class TambahMenuScreen extends StatefulWidget {
  const TambahMenuScreen({Key? key}) : super(key: key);

  @override
  _TambahMenuScreenState createState() => _TambahMenuScreenState();
}

class _TambahMenuScreenState extends State<TambahMenuScreen> {
  String? selectedCategory;

  final List<String> foodCategories = [
    'Sarapan',
    'Siang',
    'Malam',
    'Camilan',
  ];

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if (index == 0) {
      // Navigasi ke HomeMenuScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeMenuScreen()),
      );
    } else if (index == 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Navigasi ke Pertanyaan belum diimplementasi")),
      );
    } else if (index == 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Navigasi ke Profil belum diimplementasi")),
      );
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
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(FluentIcons.arrow_left_12_regular),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MenuMakananScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 16),
                const Text(
                  'Tambah',
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
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 300,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Pilih Kategori Makanan',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  items: foodCategories.map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedCategory = newValue;
                    });
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  hint: const Text('Kategori Makanan'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (selectedCategory == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Silakan pilih kategori makanan terlebih dahulu!'),
                        ),
                      );
                    } else {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomeMenuScreen(),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.green,
                    elevation: 2,
                    minimumSize: const Size(150, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Selesai'),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
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
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        backgroundColor: Colors.white,
      ),
    );
  }
}
