import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:kaloriku/model/makanan.dart'; // Import model Makanan


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
  int _selectedIndex = 0;
  final List<Makanan> makananList = [
    Makanan(namaMakanan: 'Nasi Goreng', kaloriMakanan: 100, beratMakanan: 100, kategoriMakanan: KategoriMakanan.sarapan),
    Makanan(namaMakanan: 'Ayam Bakar', kaloriMakanan: 200, beratMakanan: 150, kategoriMakanan: KategoriMakanan.makan_siang),
    Makanan(namaMakanan: 'Sayur Lodeh', kaloriMakanan: 50, beratMakanan: 200, kategoriMakanan: KategoriMakanan.sarapan),
    Makanan(namaMakanan: 'Sate Ayam', kaloriMakanan: 150, beratMakanan: 100, kategoriMakanan: KategoriMakanan.makan_siang),
    Makanan(namaMakanan: 'Mie Goreng', kaloriMakanan: 120, beratMakanan: 150, kategoriMakanan: KategoriMakanan.sarapan),
  ];

  List<Makanan> myOwnMenu = [];
  List<Makanan> filteredMakananList = [];
  List<Makanan> filteredMyOwnMenu = [];
  List<Makanan> filteredAddedMenu = [];
  Makanan? selectedMakananItem;
  
  // Controller untuk form input makanan
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _kaloriController = TextEditingController();
  final TextEditingController _beratController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredMakananList = makananList;
    filteredMyOwnMenu = myOwnMenu;
    filteredAddedMenu = [];
    _tabController = TabController(length: 3, vsync: this);
  }

  void addFoodQuantity(Makanan item) {
    setState(() {
      item.quantity = (item.quantity ?? 0) + 1;
    });
  }

  void removeFoodQuantity(Makanan item) {
    setState(() {
      if (item.quantity! > 0) {
        item.quantity = item.quantity! - 1;
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
              item.quantity = (item.quantity ?? 0) + selectedMakananItem!.quantity!;
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

  // Fungsi untuk menambah makanan ke "My Own Menu"
  void tambahMakanan() {
    setState(() {
      myOwnMenu.add(Makanan(
        namaMakanan: _namaController.text,
        kaloriMakanan: double.parse(_kaloriController.text),
        beratMakanan: double.parse(_beratController.text),
        quantity: int.parse(_quantityController.text),
      ));
    });
    _namaController.clear();
    _kaloriController.clear();
    _beratController.clear();
    _quantityController.clear();
  }

  // Fungsi untuk menampilkan dialog untuk menambah makanan baru
  void _showAddFoodDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Tambah Makanan Baru"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _namaController,
                decoration: InputDecoration(labelText: "Nama Makanan"),
              ),
              TextField(
                controller: _kaloriController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: "Kalori (per 100g)"),
              ),
              TextField(
                controller: _beratController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: "Berat (per porsi)"),
              ),
              TextField(
                controller: _quantityController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: "Jumlah Porsi"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Batal"),
            ),
            TextButton(
              onPressed: () {
                tambahMakanan();
                Navigator.pop(context); // Menutup dialog setelah menambah makanan
              },
              child: Text("Tambahkan"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            SizedBox(height: 4),
            Text(
              'Dummy',
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
                setState(() {
                  filteredMakananList = makananList
                      .where((food) => food.namaMakanan!.toLowerCase().contains(query.toLowerCase()))
                      .toList();
                  filteredMyOwnMenu = myOwnMenu
                      .where((food) => food.namaMakanan!.toLowerCase().contains(query.toLowerCase()))
                      .toList();
                  filteredAddedMenu = filteredAddedMenu
                      .where((food) => food.namaMakanan!.toLowerCase().contains(query.toLowerCase()))
                      .toList();
                });
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
      floatingActionButton: (_tabController.index == 0 || _tabController.index == 1) && selectedMakananItem != null && selectedMakananItem!.quantity! > 0
          ? FloatingActionButton.extended(
              onPressed: () {
                if (_tabController.index == 0) {
                  addToAddedMenu();
                } else if (_tabController.index == 1) {
                  _showAddFoodDialog();
                }
              },
              label: Text('Tambah'),
              backgroundColor: Color(0xFF61CA3D),
              icon: Icon(Icons.add),
            )
          : null,
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
