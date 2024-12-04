class Komentar {
  int? idKomentar;
  String? idQna;
  String? userUuid;
  String? userCommentName;
  String? isiKomentar;

  Komentar(
      {this.idKomentar,
      this.idQna,
      this.userUuid,
      this.userCommentName,
      this.isiKomentar});

  // Factory method untuk membuat instance dari JSON
  factory Komentar.fromJson(Map<String, dynamic> json) {
    return Komentar(
      idKomentar: json['id_komentar'] != null
          ? int.tryParse(json['id_komentar'].toString())
          : null,
      idQna: json['id_qna'],
      userUuid: json['user_uuid'],
      isiKomentar: json['isi_komentar'],
      userCommentName: json['user_name'],
    );
  }

  // Method untuk mengonversi instance menjadi JSON
  Map<String, dynamic> toJson() {
    return {
      'id_komentar': idKomentar,
      'id_qna': idQna,
      'user_uuid': userUuid,
      'isi_komentar': isiKomentar,
    };
  }
}

// // Contoh penggunaan
// void main() {
//   // JSON dari API atau database
//   String jsonString = '''
//     {
//       "id_komentar": 1,
//       "id_qna": "12345",
//       "user_uuid": "abcde-12345",
//       "isi_komentar": "Flutter sangat keren!"
//     }
//   ''';

//   // Parsing JSON menjadi objek Komentar
//   Map<String, dynamic> jsonMap = jsonDecode(jsonString);
//   Komentar komentar = Komentar.fromJson(jsonMap);

//   print("Isi Komentar: ${komentar.isiKomentar}");
//   print("ID QnA: ${komentar.idQna}");
//   print("User UUID: ${komentar.userUuid}");

//   // Mengonversi kembali ke JSON
//   String encodedJson = jsonEncode(komentar.toJson());
//   print("Encoded JSON: $encodedJson");
// }
