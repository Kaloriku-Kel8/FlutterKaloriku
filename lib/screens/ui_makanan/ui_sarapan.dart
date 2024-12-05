import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:kaloriku/model/kaloriKonsumsi.dart';
import 'package:kaloriku/model/makanan.dart'; // Import model Makanan

import 'package:kaloriku/screens/Pertanyaan/pertanyaan.dart';
import 'package:kaloriku/screens/profil/profil.dart';
import 'package:kaloriku/screens/Home/home_menu.dart';
import 'package:kaloriku/service/makananService.dart'; // Import MakananService
import 'package:kaloriku/service/kaloriKonsumsiService.dart'; // Import KaloriKonsumsiService

void main() {
  runApp(Sarapan());
}

class Sarapan extends StatelessWidget {
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
  late MakananService _makananService;
  late KaloriKonsumsiService _kaloriKonsumsiService;

  List<Makanan> makananList = []; // Menu yang ditambahkan oleh pengguna
  List<Makanan> filteredMakananList = [];
  List<Makanan> myOwnMenu = [];
  List<Makanan> filteredMyOwnMenu = [];
  List<Makanan> filteredAddedMenu = [];
  Makanan? selectedMakananItem;

/* final TextEditingController _namaMakananController = TextEditingController();
final TextEditingController _kaloriController = TextEditingController();
final TextEditingController _beratMakananController = TextEditingController();

  // Fungsi untuk menampilkan dialog dan menambah menu custom
  void _showAddCustomMenuDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Tambahkan Makanan Custom'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _namaMakananController,
                decoration: InputDecoration(labelText: 'Nama Makanan'),
              ),
              TextField(
                controller: _kaloriController,
                decoration: InputDecoration(labelText: 'Kalori (kcal)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _beratMakananController,
                decoration: InputDecoration(labelText: 'Berat (gram)'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Ambil nilai dari input
                String namaMakanan = _namaMakananController.text;
                double kaloriMakanan = double.tryParse(_kaloriController.text) ?? 0.0;
                double beratMakanan = double.tryParse(_beratMakananController.text) ?? 0.0;

                if (namaMakanan.isNotEmpty && kaloriMakanan > 0 && beratMakanan > 0) {
                  setState(() {
                    // Tambahkan ke myOwnMenu
                    myOwnMenu.add(Makanan(
                      namaMakanan: namaMakanan,
                      kaloriMakanan: kaloriMakanan,
                      beratMakanan: beratMakanan,
                      quantity: 1, // Default quantity 1
                    ));
                  });
                  Navigator.pop(context); // Tutup dialog setelah menambahkannya
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Mohon lengkapi semua field dengan benar!'),
                  ));
                }
              },
              child: Text('Tambah'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Batal'),
            ),
          ],
        );
      },
    );
  }

  @override
void dispose() {
  _namaMakananController.dispose();
  _kaloriController.dispose();
  _beratMakananController.dispose();
  super.dispose();
}



 */

void _onItemTapped(int index) {
  setState(() {
    _selectedIndex = index;
  });
  
  switch (index) {
    case 0:
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
      break;
    case 1:
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => PertanyaanScreen()),
      );
      break;
    case 2:
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ProfilScreen()),
      );
      break;
  }
}

  @override
  void initState() {
    super.initState();
    _makananService = MakananService();
    _kaloriKonsumsiService = KaloriKonsumsiService();


    filteredMakananList = makananList; // Menampilkan semua item makanan di awal
    filteredMyOwnMenu = myOwnMenu;
    filteredAddedMenu = []; // Awalnya Added Menu kosong
    _tabController = TabController(length: 2, vsync: this);
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

  // Debugging: Menampilkan nilai quantity setelah diupdate
  print('Added Food - Quantity: ${item.quantity}');
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

  // Debugging: Menampilkan nilai quantity setelah diupdate
  print('Removed Food - Quantity: ${item.quantity}');
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


  Future<void> _createKaloriKonsumsi(Makanan selectedMakanan) async {
    if (selectedMakanan != null) {
      try {
        // Pastikan data yang diberikan bertipe int
        int? idMakanan = int.tryParse(selectedMakanan.idMakanan.toString()); // Convert to int
        double beratMakanan = selectedMakanan.beratMakanan! * (selectedMakanan.quantity ?? 1);
      // double kaloriMakanan = selectedMakanan.kaloriMakanan ?? 0.0;

         double totalKalori = selectedMakanan.kaloriMakanan! * (selectedMakanan.quantity ?? 1);


   //   Menghitung total kalori
    //  double kaloriTerpenuhi = kaloriMakanan  * ;

        // Membuat objek konsumsi kalori berdasarkan data yang dipilih
        KonsumsiKalori konsumsi = KonsumsiKalori(
          idMakanan: idMakanan ?? 0, // Jika null, set ke 0
          namaMakanan: selectedMakanan.namaMakanan ?? 'Makanan Tidak Dikenal',
          kaloriKonsumsi: totalKalori,
          beratKonsumsi: beratMakanan,
          waktuMakan: WaktuMakan.sarapan,  // Waktu makan bisa ditentukan dari UI
        );

        // Memanggil API untuk menyimpan konsumsi kalori
        KonsumsiKalori result = await _kaloriKonsumsiService.createKonsumsiKalori(konsumsi);

        // Menampilkan notifikasi jika berhasil
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Konsumsi kalori berhasil disimpan: ${result.namaMakanan}'),
        ));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Gagal menyimpan konsumsi kalori: $e'),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: Material(
          elevation: 2,
          color: const Color.fromRGBO(248, 248, 248, 1.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
               /*    IconButton(
                  icon: Icon(FluentIcons.arrow_left_12_regular),
                  onPressed: () {
                    Navigator.pop(context); // Cukup gunakan pop saja
                  },
                ), */

                const SizedBox(width: 16),
                Text(
                  'Sarapan',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF61CA3D)),
                ),
              ],
            ),
          ),
        ),
/*         actions: [
          IconButton(
            icon: Icon(Icons.add),
           onPressed: _showAddCustomMenuDialog, // Fungsi untuk membuka dialog 
          ),
        ], */
      ),

floatingActionButton: (selectedMakananItem != null && selectedMakananItem!.quantity! > 0)
    ? FloatingActionButton.extended(
        onPressed: () async {
          //added menu pertama
/*                     print("Menambahkan item ke Added Menu...");
                    addToAddedMenu(); */

          // Tunggu hingga _createKaloriKonsumsi selesai diproses sebelum melanjutkan

          if (selectedMakananItem != null) {
            print("Mencoba untuk menyimpan konsumsi kalori...");
            // Tunggu hingga _createKaloriKonsumsi selesai
           await  _createKaloriKonsumsi(selectedMakananItem!);
            print("Konsumsi kalori berhasil disimpan.");

            // Setelah itu, panggil addToAddedMenu
            print("Menambahkan item ke Added Menu...");
            addToAddedMenu();

          }
        },
        label: Text('Tambah ke Menu Saya'),
        backgroundColor: Color(0xFF61CA3D),
        icon: Icon(Icons.add),
      )
    : null,  // Tombol hanya tampil jika ada makanan yang dipilih dan quantity > 0


      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: _selectedIndex == 0
                ? Icon(FluentIcons.home_12_filled)
                : Icon(FluentIcons.home_12_regular),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: _selectedIndex == 1
                ? Icon(FluentIcons.chat_12_filled)
                : Icon(FluentIcons.chat_12_regular),
            label: 'Pertanyaan',
          ),
          BottomNavigationBarItem(
            icon: _selectedIndex == 2
                ? Icon(FluentIcons.person_12_filled)
                : Icon(FluentIcons.person_12_regular),
            label: 'Profil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
          onTap: _onItemTapped // Gunakan metode _onItemTapped yang sudah diperbaiki
      ),
      
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              onChanged: filterSearchResults,
              decoration: InputDecoration(
                labelText: 'Cari Makanan',
                prefixIcon: Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 16),
            TabBar(
              controller: _tabController,
              tabs: [
            Tab(text: 'General/Default Menu'),
            Tab(text: 'Added Menu'),
          ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                buildFoodList(filteredMakananList, isAddedMenu: false),
           //     buildFoodList(filteredMyOwnMenu, isAddedMenu: false),
                buildFoodList(filteredAddedMenu, isAddedMenu: true),
            
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildFoodList(List<Makanan> makananList,{required bool isAddedMenu}) {
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
 // Debugging: Menampilkan nilai selectedMakananItem dan quantity
    print('selectedMakananItem: $selectedMakananItem');
    print('Quantity: ${selectedMakananItem?.quantity}');

          },
          child: Card(
            margin: EdgeInsets.all(8),
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: selectedMakananItem == item ? Color(0xFF61CA3D) : Colors.transparent,
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
                        Text(item.namaMakanan ?? '', style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        Text('Kalori per unit: ${item.kaloriMakanan} kcal / ${item.beratMakanan} gram', style: TextStyle(color: Colors.green)),
                        SizedBox(height: 5),
                        if (item.quantity > 0) ...[
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

/*   Widget buildKaloriList() {
    return ListView.builder(
      itemCount: myOwnMenu.length,
      itemBuilder: (context, index) {
        Makanan item = myOwnMenu[index];
        return ListTile(
          title: Text(item.namaMakanan ?? ''),
          subtitle: Text('Kalori: ${item.kaloriMakanan} kcal'),
          trailing: IconButton(
            icon: Icon(FluentIcons.checkmark_12_regular),
            onPressed: () => _createKaloriKonsumsi(item),
          ),
        );
      },
    );
  } */
}
