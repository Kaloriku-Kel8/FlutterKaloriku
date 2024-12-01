import 'package:flutter/material.dart';
import 'package:flutter'; // Model Makanan yang sudah Anda buat

class FoodProvider with ChangeNotifier {
  List<Makanan> _foodList = [];
  KategoriMakanan _selectedCategory = KategoriMakanan.sarapan;

  // Getter untuk mendapatkan daftar makanan yang disesuaikan dengan kategori
  List<Makanan> get foodList => _foodList
      .where((food) => food.kategoriMakanan == _selectedCategory)
      .toList();

  // Getter untuk mendapatkan kategori yang dipilih
  KategoriMakanan get selectedCategory => _selectedCategory;

  // Fungsi untuk menambah makanan ke dalam daftar
  void addFood(Makanan food) {
    _foodList.add(food);
    notifyListeners();
  }

  // Fungsi untuk mengubah kategori yang dipilih
  void setCategory(KategoriMakanan category) {
    _selectedCategory = category;
    notifyListeners();
  }

  // Fungsi untuk menambah atau mengurangi quantity
  void updateFoodQuantity(Makanan food, int quantity) {
    int index = _foodList.indexWhere((item) => item.idMakanan == food.idMakanan);
    if (index != -1) {
      _foodList[index].quantity = quantity;
      notifyListeners();
    }
  }
}
