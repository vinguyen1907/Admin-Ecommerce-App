import 'package:admin_ecommerce_app/common_widgets/my_icon.dart';
import 'package:admin_ecommerce_app/common_widgets/my_icon_button.dart';
import 'package:admin_ecommerce_app/constants/app_assets.dart';
import 'package:admin_ecommerce_app/constants/app_colors.dart';
import 'package:admin_ecommerce_app/constants/app_styles.dart';
import 'package:admin_ecommerce_app/models/chat_room.dart';
import 'package:admin_ecommerce_app/screens/record_voice_screen/record_voice_screen.dart';
import 'package:admin_ecommerce_app/services/chat_service.dart';
import 'package:admin_ecommerce_app/utils/image_picker_utils.dart';
import 'package:flutter/material.dart';

class MessageInput extends StatefulWidget {
  const MessageInput({super.key, required this.chatRoom});
  final ChatRoom chatRoom;
  @override
  State<MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  final TextEditingController _messageController = TextEditingController();
  final String userId = 'admin';
  final FocusNode _textFocus = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Row(
        children: [
          Expanded(
            child: Container(
              constraints: const BoxConstraints(maxHeight: 35),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: AppColors.greyColor, width: 2)),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: InkWell(
                      onTap: () => _chooseImage(),
                      child: const MyIcon(
                        icon: AppAssets.icCamera,
                        height: 20,
                      ),
                    ),
                  ),
                  Container(
                    width: 2,
                    height: 40,
                    color: AppColors.greyColor,
                  ),
                  Expanded(
                    child: TextField(
                      focusNode: _textFocus,
                      controller: _messageController,
                      onSubmitted: (text) => _sendTextMessage(),
                      style: AppStyles.bodyMedium
                          .copyWith(color: AppColors.primaryColor),
                      decoration: const InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.only(left: 12),
                          border: InputBorder.none,
                          hintStyle: AppStyles.bodyMedium,
                          hintText: 'Type message...'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: InkWell(
                      onTap: () => _navigateRecordVoiceScreen(),
                      child: const MyIcon(
                        icon: AppAssets.icMic,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          MyIconButton(
              onPressed: () => _sendTextMessage(),
              icon: const MyIcon(
                icon: AppAssets.icSend,
              ),
              size: 35,
              color: AppColors.primaryColor)
        ],
      ),
    );
  }

  Future<void> _chooseImage() async {
    final image = await ImagePickerUtils.openFilePicker(context);
    await ChatService().sendImageMessage(image!, widget.chatRoom);
  }

  _sendTextMessage() async {
    if (_messageController.text.isNotEmpty) {
      final content = _messageController.text;
      _messageController.clear();
      _textFocus.requestFocus();
      await ChatService().sendTextMessage(content, widget.chatRoom);
    }
  }

  _navigateRecordVoiceScreen() async {
    if (!context.mounted) return;
    Navigator.pushNamed(context, RecordVoiceScreen.routeName,
        arguments: widget.chatRoom);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _messageController.dispose();
  }
}
