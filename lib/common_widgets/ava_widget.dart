import 'package:flutter/material.dart';

class AvaWidget extends StatelessWidget {
  const AvaWidget({super.key, required this.url, required this.radius});
  final String url;
  final double radius;
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundImage: url.isNotEmpty
          ? NetworkImage(url)
          : const NetworkImage(
              'https://firebasestorage.googleapis.com/v0/b/ecommerce-app-b5380.appspot.com/o/avatar_img%2Fblank_avatar.jpg?alt=media&token=597f6f9f-0fce-4385-8b99-06b72d0b93fe'),
    );
  }
}
