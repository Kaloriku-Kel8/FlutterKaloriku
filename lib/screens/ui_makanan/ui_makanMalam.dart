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
    Makanan(namaMakanan: 'Ikan bakar dengan salad hijau', kaloriMakanan: 100, beratMakanan: 100, kategoriMakanan: KategoriMakanan.makan_malam),
    Makanan(namaMakanan: 'Grilled chicken breast dengan broccoli', kaloriMakanan: 200, beratMakanan: 150, kategoriMakanan: KategoriMakanan.makan_malam),
    Makanan(namaMakanan: 'Tumis tahu dan sayuran', kaloriMakanan: 50, beratMakanan: 200, kategoriMakanan: KategoriMakanan.makan_malam),
    Makanan(namaMakanan: 'Sup miso ', kaloriMakanan: 150, beratMakanan: 100, kategoriMakanan: KategoriMakanan.makan_malam),
    Makanan(namaMakanan: 'Nasi Merah dan Ayam', kaloriMakanan: 120, beratMakanan: 150, kategoriMakanan: KategoriMakanan.makan_malam),
  ];

  List<Makanan> myOwnMenu = []; // Menu yang ditambahkan oleh pengguna
  List<Makanan> filteredMakananList = [];
  List<Makanan> filteredMyOwnMenu = [];
  List<Makanan> filteredAddedMenu = [];
  Makanan? selectedMakananItem;  // Menyimpan makanan yang sedang dipilih

  @override
  void initState() {
    super.initState();
    filteredMakananList = makananList; // Menampilkan semua item makanan di awal
    filteredMyOwnMenu = myOwnMenu;
    filteredAddedMenu = []; // Awalnya Added Menu kosong
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
    // Mengurangi jumlah porsi sebanyak 1, hanya jika jumlah porsi > 0
    if (item.quantity! > 0) {
      item.quantity = item.quantity! - 1;  // Mengurangi 1 porsi
    }
    // Jika quantity = 0, hapus item dari filteredAddedMenu
    if (item.quantity == 0) {
      filteredAddedMenu.removeWhere((food) => food.namaMakanan == item.namaMakanan);
    }
  });
}

 void addToAddedMenu() {
  if (selectedMakananItem != null && selectedMakananItem!.quantity! > 0) {
    setState(() {
      // Cek apakah item sudah ada di Added Menu
      bool isItemAlreadyAdded = filteredAddedMenu.any((item) => item.namaMakanan == selectedMakananItem!.namaMakanan);
      
      if (isItemAlreadyAdded) {
        // Jika sudah ada, update quantity item tersebut
        filteredAddedMenu = filteredAddedMenu.map((item) {
          if (item.namaMakanan == selectedMakananItem!.namaMakanan) {
            item.quantity = (item.quantity ?? 0) + selectedMakananItem!.quantity!;  // Menambahkan quantity yang baru
          }
          return item;
        }).toList();
      } else {
        // Jika belum ada, tambahkan item ke Added Menu
        filteredAddedMenu.add(selectedMakananItem!);
      }

      // Reset selected item setelah ditambahkan
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
              'Makan Malam',
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
      floatingActionButton: (selectedMakananItem != null && selectedMakananItem!.quantity! > 0)
          ? FloatingActionButton.extended(
              onPressed: addToAddedMenu,
              label: Text('Tambah'),
              backgroundColor: Color(0xFF61CA3D),
              icon: Icon(Icons.add),
            )
          : null,  // Tombol hanya tampil jika ada item yang dipilih dan quantity > 0
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
                        if (item.quantity! > 0) ...[
                          Text('Jumlah: ${item.quantity}'),
                          Text('Total Kalori: ${item.kaloriMakanan! * item.quantity} kal'),
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
                          if (item.quantity! > 0)
                            IconButton(
                              icon: Icon(FluentIcons.subtract_48_filled, size: 40),
                              onPressed: () => removeFoodQuantity(item),
                            ),
                        ],
                        if (_tabController.index == 2 && item.quantity! > 0) ...[
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
