import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

void main() {
  runApp(MyApp());
}

class FoodItem {
  final String name;
  final int caloriePerUnit;
  int quantity;

  FoodItem({required this.name, required this.caloriePerUnit, this.quantity = 0});
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
  final List<FoodItem> foodItems = [
    FoodItem(name: 'Nasi Goreng', caloriePerUnit: 100),
    FoodItem(name: 'Ayam Bakar', caloriePerUnit: 200),
    FoodItem(name: 'Sayur Lodeh', caloriePerUnit: 50),
    FoodItem(name: 'Sate Ayam', caloriePerUnit: 150),
    FoodItem(name: 'Mie Goreng', caloriePerUnit: 120),
  ];

  List<FoodItem> myOwnMenu = []; // Menu yang ditambahkan oleh pengguna
  List<FoodItem> filteredFoodItems = [];
  List<FoodItem> filteredMyOwnMenu = [];
  List<FoodItem> filteredAddedMenu = [];
  FoodItem? selectedFoodItem;

  @override
  void initState() {
    super.initState();
    filteredFoodItems = foodItems; // Menampilkan semua item makanan di awal
    filteredMyOwnMenu = myOwnMenu;
    filteredAddedMenu = getFilteredAddedMenu();
    _tabController = TabController(length: 3, vsync: this);
  }

  // Fungsi untuk memfilter item berdasarkan pencarian
  void filterSearchResults(String query) {
    setState(() {
      // Filter untuk Default Menu
      filteredFoodItems = foodItems
          .where((food) => food.name.toLowerCase().contains(query.toLowerCase()))
          .toList();

      // Filter untuk My Own Menu
      filteredMyOwnMenu = myOwnMenu
          .where((food) => food.name.toLowerCase().contains(query.toLowerCase()))
          .toList();

      // Filter untuk Added Menu (mengambil dari foodItems dan myOwnMenu yang memiliki quantity > 0)
      filteredAddedMenu = getFilteredAddedMenu().where((food) {
        return food.name.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  // Fungsi untuk memfilter item yang memiliki quantity > 0
  List<FoodItem> getFilteredAddedMenu() {
    return [
      ...foodItems.where((food) => food.quantity > 0),
      ...myOwnMenu.where((food) => food.quantity > 0),
    ];
  }

  // Fungsi untuk menambah kuantitas makanan pada menu
  void addFoodQuantity(FoodItem item) {
    setState(() {
      item.quantity++;
      filteredAddedMenu = getFilteredAddedMenu(); // Update filteredAddedMenu
    });
  }

  // Fungsi untuk mengurangi kuantitas makanan pada menu
  void removeFoodQuantity(FoodItem item) {
    setState(() {
      if (item.quantity > 0) {
        item.quantity--;
      }
      filteredAddedMenu = getFilteredAddedMenu(); // Update filteredAddedMenu
    });
  }

  // Fungsi untuk menambahkan item ke Added Menu
  void addToAddedMenu() {
    if (selectedFoodItem != null) {
      setState(() {
        selectedFoodItem!.quantity++;
        filteredAddedMenu = getFilteredAddedMenu(); // Update filteredAddedMenu
        selectedFoodItem = null; // Reset selected item setelah ditambahkan
      });
    }
  }

  // Fungsi untuk menangani perubahan tab pada BottomNavigationBar
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Update index yang dipilih
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
                filterSearchResults(query); // Memanggil pencarian saat user mengetik
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
                buildFoodList(filteredFoodItems, isAddedMenu: false), // General/Default Menu
                buildFoodList(filteredMyOwnMenu, isAddedMenu: false), // My Own Menu
                buildFoodList(filteredAddedMenu, isAddedMenu: true), // Added Menu
              ],
            ),
          ),
        ],
      ),

// Menampilkan tombol 'Tambah' hanya jika ada item yang dipilih
     floatingActionButton: (selectedFoodItem != null || filteredAddedMenu.isNotEmpty)
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

  // Membuat widget yang menampilkan daftar makanan
  Widget buildFoodList(List<FoodItem> foodList, {required bool isAddedMenu}) {
    return ListView.builder(
      itemCount: foodList.length,
      itemBuilder: (context, index) {
        FoodItem item = foodList[index];
        int totalCalories = item.caloriePerUnit * item.quantity;
         return GestureDetector(
      onTap: () {
        setState(() {
          // Toggle selection if tapped item is not from Added Menu
          if (_tabController.index != 2) {
            selectedFoodItem = (selectedFoodItem == item) ? null : item;
          }
        });
      },
      child: Card(
          margin: EdgeInsets.all(8),
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: selectedFoodItem == item
                  ? Color(0xFF61CA3D) // Border hijau jika item dipilih
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
                      Text(item.name, style: TextStyle(fontSize: 18)),
                      SizedBox(height: 5),
                      Text('Kalori per unit: ${item.caloriePerUnit} kal/100gr'),
                      SizedBox(height: 5),
                      if (item.quantity > 0) ...[
                        Text('Jumlah: ${item.quantity}'),
                        Text('Total Kalori: ${totalCalories} kal'),
                      ],
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      // Menampilkan ikon tambah (+) atau minus (-) di Default dan My Own Menu
                      if (_tabController.index == 0 || _tabController.index == 1) ...[
                        IconButton(
                          icon: Icon(FluentIcons.add_square_48_filled, size: 40),
                          onPressed: () => addFoodQuantity(item),
                        ),
                        if (item.quantity > 0)
                          IconButton(
                            icon: Icon(FluentIcons.subtract_48_filled, size: 40),
                            onPressed: () => removeFoodQuantity(item),
                          ),
                      ],
                      // Menampilkan ikon delete (sampah) di Added Menu
                      if (_tabController.index == 2 && item.quantity > 0) ...[
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
        )
         );
      },
    );
  }
}
