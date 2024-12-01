import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:kaloriku/model/makanan.dart'; // Import model Makanan

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
  int _selectedIndex = 0; // State untuk mengatur BottomNavigationBar
  final List<Makanan> makananList = [
    Makanan(namaMakanan: 'Nasi Goreng', kaloriMakanan: 100, beratMakanan: 100, kategoriMakanan: KategoriMakanan.sarapan),
    Makanan(namaMakanan: 'Ayam Bakar', kaloriMakanan: 200, beratMakanan: 150, kategoriMakanan: KategoriMakanan.makan_siang),
    Makanan(namaMakanan: 'Sayur Lodeh', kaloriMakanan: 50, beratMakanan: 200, kategoriMakanan: KategoriMakanan.sarapan),
    Makanan(namaMakanan: 'Sate Ayam', kaloriMakanan: 150, beratMakanan: 100, kategoriMakanan: KategoriMakanan.makan_siang),
    Makanan(namaMakanan: 'Mie Goreng', kaloriMakanan: 120, beratMakanan: 150, kategoriMakanan: KategoriMakanan.sarapan),
  ];

  List<Makanan> myOwnMenu = []; // Menu yang ditambahkan oleh pengguna
  List<Makanan> filteredMakananList = [];
  List<Makanan> filteredMyOwnMenu = [];
  List<Makanan> filteredAddedMenu = [];
  Makanan? selectedMakananItem;

  @override
  void initState() {
    super.initState();
    filteredMakananList = makananList; // Menampilkan semua item makanan di awal
    filteredMyOwnMenu = myOwnMenu;
    filteredAddedMenu = getFilteredAddedMenu();
    _tabController = TabController(length: 3, vsync: this);
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
      ...makananList.where((food) => food.beratMakanan! > 0),
      ...myOwnMenu.where((food) => food.beratMakanan! > 0),
    ];
  }

  void addFoodQuantity(Makanan item) {
    setState(() {
      item.beratMakanan = (item.beratMakanan! + 100); // Menambah berat untuk simulasi kuantitas
      filteredAddedMenu = getFilteredAddedMenu();
    });
  }

  void removeFoodQuantity(Makanan item) {
    setState(() {
      if (item.beratMakanan! > 0) {
        item.beratMakanan = (item.beratMakanan! - 100);
      }
      filteredAddedMenu = getFilteredAddedMenu();
    });
  }

  void addToAddedMenu() {
    if (selectedMakananItem != null) {
      setState(() {
        selectedMakananItem!.beratMakanan = (selectedMakananItem!.beratMakanan! + 100);
        filteredAddedMenu = getFilteredAddedMenu();
        selectedMakananItem = null;
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
            Tab(text: 'My Own Menu'),
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
      floatingActionButton: (selectedMakananItem != null || filteredAddedMenu.isNotEmpty)
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
        unselectedItemColor: Colors.black,
        onTap: _onItemTapped,
        showUnselectedLabels: true,
        backgroundColor: Colors.white,
      ),
    );
  }

  Widget buildFoodList(List<Makanan> makananList, {required bool isAddedMenu}) {
    return ListView.builder(
      itemCount: makananList.length,
      itemBuilder: (context, index) {
        Makanan item = makananList[index];
        return GestureDetector(
          onTap: () {
            setState(() {
              if (_tabController.index != 2) {
                selectedMakananItem = (selectedMakananItem == item) ? null : item;
              }
            });
          },
          child: Card(
            margin: EdgeInsets.all(8),
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: selectedMakananItem == item
                    ? Color(0xFF61CA3D)
                    : Colors.transparent,
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
                        Text(item.namaMakanan ?? '', style: TextStyle(fontSize: 18)),
                        SizedBox(height: 5),
                        Text('Kalori per unit: ${item.kaloriMakanan} kal/100gr'),
                        SizedBox(height: 5),
                        if (item.beratMakanan! > 0) ...[
                          Text('Jumlah: ${item.beratMakanan}'),
                          Text('Total Kalori: ${item.kaloriMakanan! * item.beratMakanan!} kal'),
                        ],
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        if (_tabController.index == 0 || _tabController.index == 1) ...[
                          IconButton(
                            icon: Icon(FluentIcons.add_square_48_filled, size: 40),
                            onPressed: () => addFoodQuantity(item),
                          ),
                          if (item.beratMakanan! > 0)
                            IconButton(
                              icon: Icon(FluentIcons.subtract_48_filled, size: 40),
                              onPressed: () => removeFoodQuantity(item),
                            ),
                        ],
                        if (_tabController.index == 2 && item.beratMakanan! > 0) ...[
                          IconButton(
                            icon: Icon(FluentIcons.delete_48_filled, size: 40),
                            onPressed: () => removeFoodQuantity(item),
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
