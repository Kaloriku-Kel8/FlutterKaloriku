import 'dart:convert';

enum KategoriResep {
  sarapan,
  makan_siang,
  makan_malam,
  cemilan }

class ResepMakanan {
  int? idResep;
  String? namaResep;
  String? deskripsi;
  String? gambar;
  double? kaloriMakanan;
  double? beratMakanan;
  KategoriResep? kategoriResep;

  ResepMakanan({
    this.idResep,
    this.namaResep,
    this.deskripsi,
    this.gambar,
    this.kaloriMakanan,
    this.beratMakanan,
    this.kategoriResep,
  });

  // Factory method to create an instance from JSON
  factory ResepMakanan.fromJson(Map<String, dynamic> json) {
    return ResepMakanan(
      idResep: json['id_resep'] != null
          ? int.tryParse(json['id_resep'].toString())
          : null,
      namaResep: json['nama_resep'],
      deskripsi: json['deskripsi'],
      gambar: json['gambar'],
      kaloriMakanan: json['kalori_makanan'] != null
          ? double.tryParse(json['kalori_makanan'].toString())
          : null,
      beratMakanan: json['berat_makanan'] != null
          ? double.tryParse(json['berat_makanan'].toString())
          : null,
      kategoriResep: json['kategori_resep'] != null
          ? KategoriResep.values.firstWhere(
              (e) => e.toString().split('.').last == json['kategori_resep'],
              orElse: () => KategoriResep.sarapan,
            )
          : null,
    );
  }

  // Method to convert instance back to JSON
  Map<String, dynamic> toJson() {
    return {
      'id_resep': idResep,
      'nama_resep': namaResep,
      'deskripsi': deskripsi,
      'gambar': gambar,
      'kalori_makanan': kaloriMakanan,
      'berat_makanan': beratMakanan,
      'kategori_resep': kategoriResep?.toString().split('.').last,
    };
  }
}

// // Example usage (optional)
// void main() {
//   // JSON data from API or database
//   String jsonString = '''
//     {
//       "id_resep": 1,
//       "nama_resep": "Ayam Goreng",
//       "deskripsi": "Ayam goreng dengan bumbu khas",
//       "gambar": "url_gambar.jpg",
//       "kalori_makanan": 250.0,
//       "berat_makanan": 200.0,
//       "kategori_resep": "makan_siang"
//     }
//   ''';

//   // Parse JSON into ResepMakanan object
//   Map<String, dynamic> jsonMap = jsonDecode(jsonString);
//   ResepMakanan resepMakanan = ResepMakanan.fromJson(jsonMap);

//   print("Nama Resep: ${resepMakanan.namaResep}");
//   print("Deskripsi: ${resepMakanan.deskripsi}");
//   print("Kalori: ${resepMakanan.kaloriMakanan} kkal");
//   print("Kategori Resep: ${resepMakanan.kategoriResep}");

//   // Convert back to JSON
//   String encodedJson = jsonEncode(resepMakanan.toJson());
//   print("Encoded JSON: $encodedJson");
// }
