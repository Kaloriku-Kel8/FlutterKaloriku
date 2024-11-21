import 'dart:convert';

enum KategoriMakanan { sarapan, makan_siang, makan_malam, cemilan }

class Makanan {
  int? idMakanan;
  String? userUuid;
  String? namaMakanan;
  double? kaloriMakanan;
  double? beratMakanan;
  KategoriMakanan? kategoriMakanan;

  Makanan({
    this.idMakanan,
    this.userUuid,
    this.namaMakanan,
    this.kaloriMakanan,
    this.beratMakanan,
    this.kategoriMakanan,
  });

  // Factory method to create an instance from JSON
  factory Makanan.fromJson(Map<String, dynamic> json) {
    return Makanan(
      idMakanan: json['id_makanan'] != null
          ? int.tryParse(json['id_makanan'].toString())
          : null,
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
      'id_makanan': idMakanan,
      'user_uuid': userUuid,
      'nama_makanan': namaMakanan,
      'kalori_makanan': kaloriMakanan,
      'berat_makanan': beratMakanan,
      'kategori_makanan': kategoriMakanan?.toString().split('.').last,
    };
  }
}
