import 'dart:convert';

enum WaktuMakan { sarapan, makanSiang, makanMalam, cemilan }

class KonsumsiKalori {
  int? idKonsumsi;
  String? userUuid;
  int? idMakanan;
  int? idResep;
  String? namaMakanan;
  double? kaloriKonsumsi;
  double? kaloriTerpenuhi;
  double? kaloriTersisa;
  double? beratKonsumsi;
  WaktuMakan? waktuMakan;

  KonsumsiKalori({
    this.idKonsumsi,
    this.userUuid,
    this.idMakanan,
    this.idResep,
    this.namaMakanan,
    this.kaloriKonsumsi,
    this.kaloriTerpenuhi,
    this.kaloriTersisa,
    this.beratKonsumsi,
    this.waktuMakan,
  });

  // Factory method untuk membuat instance dari JSON
  factory KonsumsiKalori.fromJson(Map<String, dynamic> json) {
    return KonsumsiKalori(
      idKonsumsi: json['id_konsumsi'] != null
          ? int.tryParse(json['id_konsumsi'].toString())
          : null,
      userUuid: json['user_uuid'],
      idMakanan: json['id_makanan'] != null
          ? int.tryParse(json['id_makanan'].toString())
          : null,
      idResep: json['id_resep'] != null
          ? int.tryParse(json['id_resep'].toString())
          : null,
      namaMakanan: json['nama_makanan'],
      kaloriKonsumsi: json['kalori_konsumsi'] != null
          ? double.tryParse(json['kalori_konsumsi'].toString())
          : null,
      kaloriTerpenuhi: json['kalori_terpenuhi'] != null
          ? double.tryParse(json['kalori_terpenuhi'].toString())
          : null,
      kaloriTersisa: json['kalori_tersisa'] != null
          ? double.tryParse(json['kalori_tersisa'].toString())
          : null,
      beratKonsumsi: json['berat_konsumsi'] != null
          ? double.tryParse(json['berat_konsumsi'].toString())
          : null,
      waktuMakan: json['waktu_makan'] != null
          ? WaktuMakan.values.firstWhere(
              (e) => e.toString().split('.').last == json['waktu_makan'],
              orElse: () => WaktuMakan.sarapan,
            )
          : null,
    );
  }

  // Method untuk mengonversi instance menjadi JSON
  Map<String, dynamic> toJson() {
    return {
      'id_konsumsi': idKonsumsi,
      'user_uuid': userUuid,
      'id_makanan': idMakanan,
      'id_resep': idResep,
      'nama_makanan': namaMakanan,
      'kalori_konsumsi': kaloriKonsumsi,
      'kalori_terpenuhi': kaloriTerpenuhi,
      'kalori_tersisa': kaloriTersisa,
      'berat_konsumsi': beratKonsumsi,
      'waktu_makan': waktuMakan?.toString().split('.').last,
    };
  }
}

// // Contoh penggunaan
// void main() {
//   // JSON dari API atau database
//   String jsonString = '''
//     {
//       "id_konsumsi": 1,
//       "user_uuid": "12345-abcde",
//       "id_makanan": 2,
//       "id_resep": null,
//       "nama_makanan": "Nasi Goreng",
//       "kalori_konsumsi": 500.0,
//       "kalori_terpenuhi": 200.0,
//       "kalori_tersisa": 300.0,
//       "berat_konsumsi": 150.0,
//       "waktu_makan": "sarapan"
//     }
//   ''';

//   // Parsing JSON menjadi objek KonsumsiKalori
//   Map<String, dynamic> jsonMap = jsonDecode(jsonString);
//   KonsumsiKalori konsumsiKalori = KonsumsiKalori.fromJson(jsonMap);

//   print("Nama Makanan: ${konsumsiKalori.namaMakanan}");
//   print("Kalori Konsumsi: ${konsumsiKalori.kaloriKonsumsi} kkal");

//   // Mengonversi kembali ke JSON
//   String encodedJson = jsonEncode(konsumsiKalori.toJson());
//   print("Encoded JSON: $encodedJson");
// }
