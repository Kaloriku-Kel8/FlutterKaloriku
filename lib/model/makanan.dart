import 'dart:convert';

class Makanan {
  String? userUuid;
  String? namaMakanan;
  double? kaloriMakanan;
  double? beratMakanan;
  String? kategoriMakanan;

  Makanan({
    this.userUuid,
    this.namaMakanan,
    this.kaloriMakanan,
    this.beratMakanan,
    this.kategoriMakanan,
  });

  // Factory method untuk membuat instance dari JSON
  factory Makanan.fromJson(Map<String, dynamic> json) {
    return Makanan(
      userUuid: json['user_uuid'],
      namaMakanan: json['nama_makanan'],
      kaloriMakanan: json['kalori_makanan'] != null
          ? double.tryParse(json['kalori_makanan'].toString())
          : null,
      beratMakanan: json['berat_makanan'] != null
          ? double.tryParse(json['berat_makanan'].toString())
          : null,
      kategoriMakanan: json['kategori_makanan'],
    );
  }

  // Method untuk mengonversi instance menjadi JSON
  Map<String, dynamic> toJson() {
    return {
      'user_uuid': userUuid,
      'nama_makanan': namaMakanan,
      'kalori_makanan': kaloriMakanan,
      'berat_makanan': beratMakanan,
      'kategori_makanan': kategoriMakanan,
    };
  }
}

// // Contoh penggunaan
// void main() {
//   // JSON dari API atau database
//   String jsonString = '''
//     {
//       "user_uuid": "12345-abcde",
//       "nama_makanan": "Nasi Goreng",
//       "kalori_makanan": 300.5,
//       "berat_makanan": 150.0,
//       "kategori_makanan": "Karbohidrat"
//     }
//   ''';

//   // Parsing JSON menjadi objek Makanan
//   Map<String, dynamic> jsonMap = jsonDecode(jsonString);
//   Makanan makanan = Makanan.fromJson(jsonMap);

//   print("Nama Makanan: ${makanan.namaMakanan}");
//   print("Kalori: ${makanan.kaloriMakanan} kkal");

//   // Mengonversi kembali ke JSON
//   String encodedJson = jsonEncode(makanan.toJson());
//   print("Encoded JSON: $encodedJson");
// }
