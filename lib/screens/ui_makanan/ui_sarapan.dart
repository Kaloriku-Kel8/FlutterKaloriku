import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:kaloriku/model/makanan.dart'; // Import model Makanan
import 'package:kaloriku/service/makananService.dart';
import 'package:kaloriku/screens/Pertanyaan/pertanyaan.dart';
import 'package:kaloriku/screens/profil/profil.dart';
import 'package:kaloriku/screens/Home/home_menu.dart';

void main() {
  runApp(Sarapan());
}

class Sarapan extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.green,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Color(0xFFE8F5E9),
          hintStyle: TextStyle(color: Color(0xFF000000)),
          labelStyle: TextStyle(color: Color(0xFF000000)),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.lightGreen, width: 1),
            borderRadius: BorderRadius.circular(15.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF61CA3D), width: 2),
            borderRadius: BorderRadius.circular(15.0),
          ),
        ),
      ),
      home: FoodPortionList(),
    );
  }
}

class FoodPortionList extends StatefulWidget {
  @override
  _FoodPortionListState createState() => _FoodPortionListState();
}

class _FoodPortionListState extends State<FoodPortionList> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;
  late MakananService _makananService;

  List<Makanan> makananList = [];  // Ini akan di-update dari API
  List<Makanan> filteredMakananList = [];
  List<Makanan> myOwnMenu = [];
  List<Makanan> filteredMyOwnMenu = [];
  List<Makanan> filteredAddedMenu = [];
  Makanan? selectedMakananItem;

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

  @override
  void initState() {
    super.initState();
    _makananService = MakananService();
    _tabController = TabController(length: 3, vsync: this);
    fetchMakananData();  // Mengambil data dari API saat awal
  }

  Future<void> fetchMakananData() async {
    try {
      List<Makanan> fetchedMakanan = await _makananService.GetAndSearchMakanan(
        category: "sarapan",  // Mengambil makanan dengan kategori sarapan
        keyword: '',
        isGeneral: false,
      );
      setState(() {
        makananList = fetchedMakanan;
        filteredMakananList = fetchedMakanan;  // Menampilkan semua item makanan
      });
    } catch (e) {
      print('Error fetching makanan: $e');
    }
  }

  void filterSearchResults(String query) {
    setState(() {
      filteredMakananList = makananList
          .where((food) => food.namaMakanan!.toLowerCase().contains(query.toLowerCase()))
          .toList();
      filteredMyOwnMenu = myOwnMenu
          .where((food) => food.namaMakanan!.toLowerCase().contains(query.toLowerCase()))
          .toList();
      filteredAddedMenu = getFilteredAddedMenu().where((food) {
        return food.namaMakanan!.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  List<Makanan> getFilteredAddedMenu() {
    return [
      ...makananList.where((food) => food.quantity! > 0),  // Hanya masukkan makanan dengan quantity > 0
      ...myOwnMenu.where((food) => food.quantity! > 0),
    ];
  }

  void addFoodQuantity(Makanan item) {
    setState(() {
      item.quantity = (item.quantity ?? 0) + 1; // Menambah 1 porsi
    });
  }

  void removeFoodQuantity(Makanan item) {
    setState(() {
      if (item.quantity! > 0) {
        item.quantity = item.quantity! - 1;  // Mengurangi 1 porsi
      }
      if (item.quantity == 0) {
        filteredAddedMenu.removeWhere((food) => food.namaMakanan == item.namaMakanan);
      }
    });
  }

  void addToAddedMenu() {
    if (selectedMakananItem != null && selectedMakananItem!.quantity! > 0) {
      setState(() {
        bool isItemAlreadyAdded = filteredAddedMenu.any((item) => item.namaMakanan == selectedMakananItem!.namaMakanan);

        if (isItemAlreadyAdded) {
          filteredAddedMenu = filteredAddedMenu.map((item) {
            if (item.namaMakanan == selectedMakananItem!.namaMakanan) {
              item.quantity = (item.quantity ?? 0) + selectedMakananItem!.quantity!;  // Update quantity
            }
            return item;
          }).toList();
        } else {
          filteredAddedMenu.add(selectedMakananItem!);
        }
        
        selectedMakananItem = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            SizedBox(height: 4),
            Text(
              'Sarapan',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
                fontSize: 25,
                color: Color(0xFF61CA3D),
              ),
            ),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'General/Default Menu'),
            //Tab(text: 'My Own Menu'),
            Tab(text: 'Added Menu'),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (query) {
                filterSearchResults(query);
              },
              cursorColor: Colors.black54,
              decoration: InputDecoration(
                labelText: 'Cari Makanan...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                prefixIcon: Icon(Icons.search, color: Color(0xFF000000)),
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                buildFoodList(filteredMakananList, isAddedMenu: false),
                buildFoodList(filteredMyOwnMenu, isAddedMenu: false),
                buildFoodList(filteredAddedMenu, isAddedMenu: true),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: (selectedMakananItem != null && selectedMakananItem!.quantity! > 0)
          ? FloatingActionButton.extended(
              onPressed: addToAddedMenu,
              label: Text('Tambah'),
              backgroundColor: Color(0xFF61CA3D),
              icon: Icon(Icons.add),
            )
          : null,
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
    );
  }

Widget buildFoodList(List<Makanan> foods, {bool isAddedMenu = false}) {
  return ListView.builder(
    itemCount: foods.length,
    itemBuilder: (context, index) {
      Makanan food = foods[index];
      return GestureDetector(
        onTap: () {
          setState(() {
            if (_tabController.index != 2) {
              selectedMakananItem = (selectedMakananItem == food) ? null : food;
            }
          });
        },
        child: Card(
          margin: EdgeInsets.all(8),
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: selectedMakananItem == food ? Color(0xFF61CA3D) : Colors.transparent,
              width: 2,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nama makanan
                      Text(food.namaMakanan ?? '', style: TextStyle(fontSize: 18)),
                      SizedBox(height: 5),
                      // Kalori per unit (dalam 100g)
                      Text('Kalori per unit: ${food.kaloriMakanan} kal/100gr'),
                      SizedBox(height: 5),
                      // Menampilkan jumlah porsi jika quantity lebih dari 0
                      if (food.quantity != null && food.quantity! > 0) ...[
                        Text('Jumlah: ${food.quantity}'),
                        // Total kalori dihitung berdasarkan quantity
                        Text('Total Kalori: ${food.kaloriMakanan! * food.quantity!} kal'),
                      ],
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      // Jika bukan menu yang sudah ditambahkan (Added Menu), tampilkan tombol add/remove
                      if (!isAddedMenu) ...[
                        IconButton(
                          icon: Icon(FluentIcons.add_square_48_filled, size: 40),
                          onPressed: () {
                            addFoodQuantity(food);  // Menambah porsi makanan
                          },
                        ),
                        // Tombol remove hanya muncul jika quantity lebih dari 0
                        if (food.quantity! > 0)
                          IconButton(
                            icon: Icon(FluentIcons.subtract_48_filled, size: 40),
                            onPressed: () {
                              removeFoodQuantity(food);  // Mengurangi porsi makanan
                            },
                          ),
                      ],
                      // Jika menu sudah ditambahkan, tampilkan tombol remove
                      if (isAddedMenu && food.quantity! > 0) ...[
                        IconButton(
                          icon: Icon(FluentIcons.delete_48_filled, size: 40),
                          onPressed: () {
                            removeFoodQuantity(food);  // Menghapus makanan dari Added Menu
                          },
                        ),
                      ],
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
}
}
