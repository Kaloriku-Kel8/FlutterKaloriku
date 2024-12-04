import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:kaloriku/model/kaloriKonsumsi.dart';
import 'package:kaloriku/model/resepMakanan.dart';
import 'package:kaloriku/service/kaloriKonsumsiService.dart';
import 'menu_makanan.dart';
import '../home_menu.dart';
import 'package:kaloriku/screens/profil/profil.dart';

class TambahMenuScreen extends StatefulWidget {
  final ResepMakanan? resep;

  const TambahMenuScreen({Key? key, this.resep}) : super(key: key);

  @override
  _TambahMenuScreenState createState() => _TambahMenuScreenState();
}

class _TambahMenuScreenState extends State<TambahMenuScreen> {
  WaktuMakan? selectedCategory;
  final TextEditingController _beratController = TextEditingController();
  final List<WaktuMakan> foodCategories = WaktuMakan.values;

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeMenuScreen()),
        );
        break;
      case 1:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Navigasi ke Pertanyaan belum diimplementasi")),
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

  Future<void> _tambahKonsumsiKalori() async {
    if (selectedCategory == null || _beratController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pastikan semua data sudah diisi!')),
      );
      return;
    }

    double beratKonsumsi = double.tryParse(_beratController.text) ?? 0.0;
    if (beratKonsumsi <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Berat konsumsi harus lebih dari 0!')),
      );
      return;
    }

    double kaloriKonsumsi =
        (widget.resep?.kaloriMakanan ?? 0.0) * (beratKonsumsi / 100.0);

    KonsumsiKalori konsumsi = KonsumsiKalori(
      idResep: widget.resep?.idResep,
      namaMakanan: widget.resep?.namaResep,
      kaloriKonsumsi: kaloriKonsumsi,
      beratKonsumsi: beratKonsumsi,
      waktuMakan: selectedCategory,
    );

    try {
      final KaloriKonsumsiService service = KaloriKonsumsiService();
      await service.createKonsumsiKalori(konsumsi);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Berhasil menambahkan ${widget.resep?.namaResep ?? 'makanan'}')),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeMenuScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menambahkan makanan: $e')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.resep != null) {
      _beratController.text = '100';
    }
  }

  @override
  void dispose() {
    _beratController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text(
        'Tambah Konsumsi',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: const Icon(
          FluentIcons.arrow_left_12_regular,
          color: Colors.black,
        ),
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeMenuScreen()),
          );
        },
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.resep != null) _buildResepDetails(),
                const SizedBox(height: 16),
                _buildDropdown(),
                const SizedBox(height: 16),
                _buildBeratInput(),
                const SizedBox(height: 24),
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResepDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.resep!.namaResep ?? 'Nama Resep',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          'Kalori: ${widget.resep!.kaloriMakanan?.toStringAsFixed(0) ?? '0'} Cal/100g',
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildDropdown() {
    return DropdownButtonFormField<WaktuMakan>(
      value: selectedCategory,
      items: foodCategories.map((WaktuMakan category) {
        return DropdownMenuItem<WaktuMakan>(
          value: category,
          child: Text(_getWaktuMakanString(category)),
        );
      }).toList(),
      onChanged: (WaktuMakan? newValue) {
        setState(() {
          selectedCategory = newValue;
        });
      },
      decoration: InputDecoration(
        labelText: 'Waktu Makan',
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildBeratInput() {
    return TextField(
      controller: _beratController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Berat Konsumsi (gram)',
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: _tambahKonsumsiKalori,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        minimumSize: const Size(double.infinity, 50),
      ),
      child: const Text(
        'Tambah Konsumsi',
        style: TextStyle(fontSize: 16),
      ),
    );
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
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
      selectedItemColor: Colors.green,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      backgroundColor: Colors.white,
    );
  }

  String _getWaktuMakanString(WaktuMakan waktuMakan) {
    switch (waktuMakan) {
      case WaktuMakan.sarapan:
        return 'Sarapan';
      case WaktuMakan.makan_siang:
        return 'Makan Siang';
      case WaktuMakan.makan_malam:
        return 'Makan Malam';
      case WaktuMakan.cemilan:
        return 'Cemilan';
      default:
        return 'Tidak Diketahui';
    }
  }
}
