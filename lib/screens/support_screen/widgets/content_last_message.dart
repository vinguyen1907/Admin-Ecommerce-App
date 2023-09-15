import 'package:admin_ecommerce_app/constants/app_colors.dart';
import 'package:admin_ecommerce_app/constants/app_styles.dart';
import 'package:admin_ecommerce_app/constants/enums/message_type.dart';
import 'package:admin_ecommerce_app/models/message.dart';
import 'package:flutter/material.dart';

class ContentLastMessage extends StatelessWidget {
  const ContentLastMessage({super.key, required this.message});
  final Message message;
  @override
  Widget build(BuildContext context) {
    final style = AppStyles.bodyMedium.copyWith(
        fontSize: 12,
        fontWeight: message.isRead || message.senderId == 'admin'
            ? FontWeight.w400
            : FontWeight.w600,
        color: AppColors.primaryColor);
    String? content;
    switch (message.type) {
      case MessageType.text:
        content = message.content;
      case MessageType.image:
        content = 'Image message.';
      case MessageType.voice:
        content = 'Voice message.';
      default:
        content = '';
    }
    return Text(
      content,
      style: style,
      overflow: TextOverflow.ellipsis,
    );
  }
}
