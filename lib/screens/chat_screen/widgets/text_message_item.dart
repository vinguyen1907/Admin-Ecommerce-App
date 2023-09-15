import 'package:admin_ecommerce_app/constants/app_colors.dart';
import 'package:admin_ecommerce_app/constants/app_styles.dart';
import 'package:admin_ecommerce_app/extensions/date_time_extension.dart';
import 'package:admin_ecommerce_app/models/chat_room.dart';
import 'package:admin_ecommerce_app/models/message.dart';
import 'package:admin_ecommerce_app/services/chat_service.dart';
import 'package:flutter/material.dart';

class TextMessageItem extends StatefulWidget {
  const TextMessageItem({super.key, required this.message, required this.chatRoom});
  final Message message;
  final ChatRoom chatRoom;
  @override
  State<TextMessageItem> createState() => _TextMessageItemState();
}

class _TextMessageItemState extends State<TextMessageItem> {
  bool isShowTime = false;
  @override
  void initState() {
    _markMessageAsRead();
    super.initState();
  }

  void _markMessageAsRead() {
    const userId = 'admin';
    if (widget.message.senderId != userId) {
      ChatService().markMessageAsRead(widget.message.id, widget.chatRoom.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    const userId = 'admin';
    final isUser = widget.message.senderId == userId;
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => _showTime(),
      child: Container(
        alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              constraints: BoxConstraints(maxWidth: size.width * 0.6),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: isUser ? AppColors.greyColor : AppColors.primaryColor,
                  borderRadius: isUser
                      ? const BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                          bottomLeft: Radius.circular(15))
                      : const BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                          bottomRight: Radius.circular(15))),
              child: Text(
                widget.message.content,
                style: AppStyles.bodyLarge.copyWith(
                    color:
                        isUser ? AppColors.primaryColor : AppColors.whiteColor),
              ),
            ),
            !isShowTime
                ? const SizedBox()
                : Text(
                    widget.message.timestamp.formattedDateChat(),
                  )
          ],
        ),
      ),
    );
  }

  _showTime() {
    setState(() {
      isShowTime = !isShowTime;
    });
  }
}
