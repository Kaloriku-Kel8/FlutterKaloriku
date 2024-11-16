import 'dart:convert';

class ResepMakanan {
  int? idResep;
  String? namaMakanan;
  String? deskripsi;
  String? gambarResep;
  double? kaloriResep;
  double? beratResep;
  String? kategoriMakanan;

  ResepMakanan({
    this.idResep,
    this.namaMakanan,
    this.deskripsi,
    this.gambarResep,
    this.kaloriResep,
    this.beratResep,
    this.kategoriMakanan,
  });

  // Factory method untuk membuat instance dari JSON
  factory ResepMakanan.fromJson(Map<String, dynamic> json) {
    return ResepMakanan(
      idResep: json['id_resep'] != null ? int.tryParse(json['id_resep'].toString()) : null,
      namaMakanan: json['nama_makanan'],
      deskripsi: json['deskripsi'],
      gambarResep: json['gambar_resep'],
      kaloriResep: json['kalori_resep'] != null
          ? double.tryParse(json['kalori_resep'].toString())
          : null,
      beratResep: json['berat_resep'] != null
          ? double.tryParse(json['berat_resep'].toString())
          : null,
      kategoriMakanan: json['kategori_makanan'],
    );
  }

  // Method untuk mengonversi instance menjadi JSON
  Map<String, dynamic> toJson() {
    return {
      'id_resep': idResep,
      'nama_makanan': namaMakanan,
      'deskripsi': deskripsi,
      'gambar_resep': gambarResep,
      'kalori_resep': kaloriResep,
      'berat_resep': beratResep,
      'kategori_makanan': kategoriMakanan,
    };
  }
}

// // Contoh penggunaan
// void main() {
//   // JSON dari API atau database
//   String jsonString = '''
//     {
//       "id_resep": 1,
//       "nama_makanan": "Ayam Goreng",
//       "deskripsi": "Ayam goreng dengan bumbu khas",
//       "gambar_resep": "url_gambar.jpg",
//       "kalori_resep": 250.0,
//       "berat_resep": 200.0,
//       "kategori_makanan": "Protein"
//     }
//   ''';

//   // Parsing JSON menjadi objek ResepMakanan
//   Map<String, dynamic> jsonMap = jsonDecode(jsonString);
//   ResepMakanan resepMakanan = ResepMakanan.fromJson(jsonMap);

//   print("Nama Resep: ${resepMakanan.namaMakanan}");
//   print("Deskripsi: ${resepMakanan.deskripsi}");
//   print("Kalori: ${resepMakanan.kaloriResep} kkal");

//   // Mengonversi kembali ke JSON
//   String encodedJson = jsonEncode(resepMakanan.toJson());
//   print("Encoded JSON: $encodedJson");
// }
