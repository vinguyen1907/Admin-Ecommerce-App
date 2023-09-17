import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final String id;
  final String name;
  final String imgUrl;

  const Category({
    required this.id,
    required this.name,
    required this.imgUrl,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      imgUrl: json['imgUrl'],
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
        id,
        name,
        imgUrl,
      ];
}
