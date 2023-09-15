import 'package:admin_ecommerce_app/extensions/date_time_extension.dart';
import 'package:admin_ecommerce_app/models/chat_room.dart';
import 'package:admin_ecommerce_app/models/message.dart';
import 'package:admin_ecommerce_app/services/chat_service.dart';
import 'package:flutter/material.dart';

class ImageMessageItem extends StatefulWidget {
  const ImageMessageItem(
      {super.key, required this.message, required this.chatRoom});
  final Message message;
  final ChatRoom chatRoom;
  @override
  State<ImageMessageItem> createState() => _ImageMessageItemState();
}

class _ImageMessageItemState extends State<ImageMessageItem> {
  @override
  void initState() {
    ChatService().markMessageAsRead(widget.message.id, widget.chatRoom.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const userId = 'admin';
    final isUser = widget.message.senderId == userId;
    Size size = MediaQuery.of(context).size;
    return Container(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                widget.message.imageUrl,
                width: size.width * 0.18,
                fit: BoxFit.cover,
              )),
          Text(
            widget.message.timestamp.formattedDateChat(),
          )
        ],
      ),
    );
  }
}
