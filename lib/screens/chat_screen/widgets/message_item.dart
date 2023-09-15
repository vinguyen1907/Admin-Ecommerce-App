import 'package:admin_ecommerce_app/constants/enums/message_type.dart';
import 'package:admin_ecommerce_app/models/chat_room.dart';
import 'package:admin_ecommerce_app/models/message.dart';
import 'package:admin_ecommerce_app/screens/chat_screen/widgets/image_message_item.dart';
import 'package:admin_ecommerce_app/screens/chat_screen/widgets/text_message_item.dart';
import 'package:admin_ecommerce_app/screens/chat_screen/widgets/voice_message_item.dart';
import 'package:flutter/material.dart';

class MessageItem extends StatelessWidget {
  const MessageItem({super.key, required this.message, required this.chatRoom});
  final Message message;
  final ChatRoom chatRoom;
  @override
  Widget build(BuildContext context) {
    switch (message.type) {
      case MessageType.text:
        return TextMessageItem(
          message: message,
          chatRoom: chatRoom,
        );
      case MessageType.image:
        return ImageMessageItem(
          message: message,
          chatRoom: chatRoom,
        );
      case MessageType.voice:
        return VoiceMessageItem(
          message: message,
          chatRoom: chatRoom,
        );
      default:
        return Container();
    }
  }
}
