import 'dart:convert';

class Latihan {
  int? idLatihan;
  String? namaLatihan;
  String? gambarLatihan;

  Latihan({
    this.idLatihan,
    this.namaLatihan,
    this.gambarLatihan,
  });

  // Factory method untuk membuat instance dari JSON
  factory Latihan.fromJson(Map<String, dynamic> json) {
    return Latihan(
      idLatihan: json['id_latihan'] != null ? int.tryParse(json['id_latihan'].toString()) : null,
      namaLatihan: json['nama_latihan'],
      gambarLatihan: json['gambar_latihan'],
    );
  }

  // Method untuk mengonversi instance menjadi JSON
  Map<String, dynamic> toJson() {
    return {
      'id_latihan': idLatihan,
      'nama_latihan': namaLatihan,
      'gambar_latihan': gambarLatihan,
    };
  }
}

// // Contoh penggunaan
// void main() {
//   // JSON dari API atau database
//   String jsonString = '''
//     {
//       "id_latihan": 1,
//       "nama_latihan": "Push Up",
//       "gambar_latihan": "pushup_image_url"
//     }
//   ''';

//   // Parsing JSON menjadi objek Latihan
//   Map<String, dynamic> jsonMap = jsonDecode(jsonString);
//   Latihan latihan = Latihan.fromJson(jsonMap);

//   print("Nama Latihan: ${latihan.namaLatihan}");
//   print("Gambar Latihan: ${latihan.gambarLatihan}");

//   // Mengonversi kembali ke JSON
//   String encodedJson = jsonEncode(latihan.toJson());
//   print("Encoded JSON: $encodedJson");
// }
