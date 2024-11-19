import 'dart:convert';

enum KategoriMakanan {
  sarapan,
  makan_siang,
  makan_malam,
  cemilan
}

class Makanan {
  String? userUuid;
  String? namaMakanan;
  double? kaloriMakanan;
  double? beratMakanan;
  KategoriMakanan? kategoriMakanan; // Change to use enum

  Makanan({
    this.userUuid,
    this.namaMakanan,
    this.kaloriMakanan,
    this.beratMakanan,
    this.kategoriMakanan,
  });

  // Factory method to create an instance from JSON
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
      kategoriMakanan: json['kategori_makanan'] != null
          ? KategoriMakanan.values.firstWhere(
              (e) => e.toString().split('.').last == json['kategori_makanan'],
              orElse: () => KategoriMakanan.sarapan,
            )
          : null,
    );
  }

  // Method to convert instance back to JSON
  Map<String, dynamic> toJson() {
    return {
      'user_uuid': userUuid,
      'nama_makanan': namaMakanan,
      'kalori_makanan': kaloriMakanan,
      'berat_makanan': beratMakanan,
      'kategori_makanan': kategoriMakanan?.toString().split('.').last, // Serialize enum
    };
  }
}

// // Example usage
// void main() {
//   // JSON data from API or database
//   String jsonString = '''
//     {
//       "user_uuid": "12345-abcde",
//       "nama_makanan": "Nasi Goreng",
//       "kalori_makanan": 300.5,
//       "berat_makanan": 150.0,
//       "kategori_makanan": "makan_siang"
//     }
//   ''';

//   // Parse JSON into Makanan object
//   Map<String, dynamic> jsonMap = jsonDecode(jsonString);
//   Makanan makanan = Makanan.fromJson(jsonMap);

//   print("Nama Makanan: ${makanan.namaMakanan}");
//   print("Kalori: ${makanan.kaloriMakanan} kkal");
//   print("Kategori Makanan: ${makanan.kategoriMakanan}");

//   // Convert back to JSON
//   String encodedJson = jsonEncode(makanan.toJson());
//   print("Encoded JSON: $encodedJson");
// }
