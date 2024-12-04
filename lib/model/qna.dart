import 'package:kaloriku/model/komentar.dart';
import 'package:kaloriku/model/like.dart';

class Qna {
  int? idQna;
  String? userUuid;
  String? userCommentName;
  String? judulQna;
  String? isiQna;
  List<Komentar>? komentar;
  List<Like>? likes; // Change to List<Like> to store Like objects
  int? komentarCount;
  int? likeCount;

  Qna({
    this.idQna,
    this.userUuid,
    this.userCommentName,
    this.judulQna,
    this.isiQna,
    this.komentar,
    this.likes,
    this.komentarCount,
    this.likeCount,
  });

  factory Qna.fromJson(Map<String, dynamic> json) {
    return Qna(
      idQna: json['id_qna'] != null
          ? int.tryParse(json['id_qna'].toString())
          : null,
      userUuid: json['user_uuid'],
      userCommentName: json['user_name'],
      judulQna: json['judul_qna'],
      isiQna: json['isi_qna'],
      komentarCount: json['komentar_count'],
      likeCount: json['like_count'],
      komentar: json['komentar'] != null
          ? (json['komentar'] as List).map((e) => Komentar.fromJson(e)).toList()
          : [],
      likes: json['likes'] != null
          ? (json['likes'] as List)
              .map((e) => Like.fromJson(e))
              .toList() // Map to Like objects
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_qna': idQna,
      'user_uuid': userUuid,
      'judul_qna': judulQna,
      'isi_qna': isiQna,
      'komentar': komentar?.map((e) => e.toJson()).toList(),
      'likes': likes
          ?.map((e) => e.toJson())
          .toList(), // Convert List<Like> back to JSON
      'komentar_count': komentarCount,
      'like_count': likeCount,
    };
  }
}
