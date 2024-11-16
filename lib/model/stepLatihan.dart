import 'dart:convert';

class StepLatihan {
  int? idStep;
  String? idLatihan;
  String? namaStep;
  String? gambarStep;
  String? deskripsiStep;

  StepLatihan({
    this.idStep,
    this.idLatihan,
    this.namaStep,
    this.gambarStep,
    this.deskripsiStep,
  });

  // Factory method untuk membuat instance dari JSON
  factory StepLatihan.fromJson(Map<String, dynamic> json) {
    return StepLatihan(
      idStep: json['id_step'] != null ? int.tryParse(json['id_step'].toString()) : null,
      idLatihan: json['id_latihan'],
      namaStep: json['nama_step'],
      gambarStep: json['gambar_step'],
      deskripsiStep: json['deskripsi_step'],
    );
  }

  // Method untuk mengonversi instance menjadi JSON
  Map<String, dynamic> toJson() {
    return {
      'id_step': idStep,
      'id_latihan': idLatihan,
      'nama_step': namaStep,
      'gambar_step': gambarStep,
      'deskripsi_step': deskripsiStep,
    };
  }
}

// // Contoh penggunaan
// void main() {
//   // JSON dari API atau database
//   String jsonString = '''
//     {
//       "id_step": 1,
//       "id_latihan": "12345",
//       "nama_step": "Push Up Step 1",
//       "gambar_step": "push_up_step1_image_url",
//       "deskripsi_step": "Langkah pertama dalam push up."
//     }
//   ''';

//   // Parsing JSON menjadi objek StepLatihan
//   Map<String, dynamic> jsonMap = jsonDecode(jsonString);
//   StepLatihan stepLatihan = StepLatihan.fromJson(jsonMap);

//   print("Nama Step: ${stepLatihan.namaStep}");
//   print("Deskripsi Step: ${stepLatihan.deskripsiStep}");
//   print("Gambar Step: ${stepLatihan.gambarStep}");

//   // Mengonversi kembali ke JSON
//   String encodedJson = jsonEncode(stepLatihan.toJson());
//   print("Encoded JSON: $encodedJson");
// }
