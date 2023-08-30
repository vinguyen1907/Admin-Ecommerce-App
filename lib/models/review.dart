import 'dart:convert';

class Review {
  final String id;
  final String userId;
  final String nameUser;
  final String avaUrl;
  final int rate;
  final String content;
  final DateTime createdAt;

  const Review(
      {required this.id,
      required this.userId,
      required this.nameUser,
      required this.avaUrl,
      required this.rate,
      required this.content,
      required this.createdAt});

  factory Review.fromMap(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      userId: json['userId'],
      nameUser: json['nameUser'],
      avaUrl: json['avaUrl'],
      rate: json['rate'].toInt(),
      content: json['content'],
      createdAt: json['createdAt'].toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'nameUser': nameUser,
      'avaUrl': avaUrl,
      'rate': rate,
      'content': content,
      'createdAt': createdAt,
    };
  }

  String toJson() => json.encode(toMap());

  factory Review.fromJson(String source) =>
      Review.fromMap(json.decode(source) as Map<String, dynamic>);
}
