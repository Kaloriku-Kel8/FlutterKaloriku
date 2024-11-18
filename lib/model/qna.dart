import 'dart:convert';

class Qna {
  int? idQna;
  String? userUuid;
  String? judulQna;
  String? isiQna;

  Qna({
    this.idQna,
    this.userUuid,
    this.judulQna,
    this.isiQna,
  });

  // Factory method untuk membuat instance dari JSON
  factory Qna.fromJson(Map<String, dynamic> json) {
    return Qna(
      idQna: json['id_qna'] != null ? int.tryParse(json['id_qna'].toString()) : null,
      userUuid: json['user_uuid'],
      judulQna: json['judul_qna'],
      isiQna: json['isi_qna'],
    );
  }

  // Method untuk mengonversi instance menjadi JSON
  Map<String, dynamic> toJson() {
    return {
      'id_qna': idQna,
      'user_uuid': userUuid,
      'judul_qna': judulQna,
      'isi_qna': isiQna,
    };
  }
}

// // Contoh penggunaan
// void main() {
//   // JSON dari API atau database
//   String jsonString = '''
//     {
//       "id_qna": 1,
//       "user_uuid": "12345-abcde",
//       "judul_qna": "Apa itu Flutter?",
//       "isi_qna": "Flutter adalah framework untuk pengembangan aplikasi."
//     }
//   ''';

//   // Parsing JSON menjadi objek Qna
//   Map<String, dynamic> jsonMap = jsonDecode(jsonString);
//   Qna qna = Qna.fromJson(jsonMap);

//   print("Judul QnA: ${qna.judulQna}");
//   print("Isi QnA: ${qna.isiQna}");

//   // Mengonversi kembali ke JSON
//   String encodedJson = jsonEncode(qna.toJson());
//   print("Encoded JSON: $encodedJson");
// }
