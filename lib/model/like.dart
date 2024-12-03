class Like {
  int? idLike;
  String? idQna;
  String? userUuid;

  Like({
    this.idLike,
    this.idQna,
    this.userUuid,
  });

  // Factory method to create an instance from JSON
  factory Like.fromJson(Map<String, dynamic> json) {
    return Like(
      idLike: json['id_like'] != null
          ? int.tryParse(json['id_like'].toString())
          : null,
      idQna: json['id_qna'],
      userUuid: json['user_uuid'],
    );
  }

  // Method to convert the instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id_like': idLike,
      'id_qna': idQna,
      'user_uuid': userUuid,
    };
  }
}
