import 'package:admin_ecommerce_app/common_widgets/ava_widget.dart';
import 'package:admin_ecommerce_app/common_widgets/custom_loading_widget.dart';
import 'package:admin_ecommerce_app/common_widgets/my_icon.dart';
import 'package:admin_ecommerce_app/constants/app_assets.dart';
import 'package:admin_ecommerce_app/constants/app_colors.dart';
import 'package:admin_ecommerce_app/constants/app_dimensions.dart';
import 'package:admin_ecommerce_app/constants/app_styles.dart';
import 'package:admin_ecommerce_app/constants/firebase_constants.dart';
import 'package:admin_ecommerce_app/models/chat_room.dart';
import 'package:admin_ecommerce_app/models/message.dart';
import 'package:admin_ecommerce_app/responsive.dart';
import 'package:admin_ecommerce_app/screens/chat_screen/widgets/message_input.dart';
import 'package:admin_ecommerce_app/screens/chat_screen/widgets/message_item.dart';
import 'package:admin_ecommerce_app/services/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.chatRoom});
  final ChatRoom chatRoom;

  static const String routeName = '/chat-screen';

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    super.initState();
    checkAdminToken();
  }

  void checkAdminToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    String? token = await messaging.getToken(
        vapidKey:
            'BI8A5tJ0bumeXY8-9BLCU5WR6KpdNL9muf79NyoQ8saqwv-8kdW_vlZp3qFyH-2Lb7MssrDF3SBkkzIzFyPRQW0');
    if (widget.chatRoom.adminToken == null && token != null) {
      await chatRoomsRef.doc(widget.chatRoom.id).update({'adminToken': token});
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isSecondScreenPushed = ModalRoute.of(context)?.canPop ?? false;
    return Container(
      decoration: BoxDecoration(
        borderRadius: AppDimensions.defaultBorderRadius,
        color: AppColors.whiteColor,
      ),
      margin: !Responsive.isMobile(context)
          ? const EdgeInsets.only(bottom: 12)
          : null,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    isSecondScreenPushed
                        ? IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const MyIcon(
                              icon: AppAssets.icArrowLeft,
                            ))
                        : const SizedBox(),
                    AvaWidget(url: widget.chatRoom.imgUrl, radius: 20),
                    const SizedBox(
                      width: 4,
                    ),
                    Text(
                      widget.chatRoom.name,
                      style: AppStyles.labelMedium,
                    ),
                  ],
                ),
                !kIsWeb
                    ? Row(
                        children: [
                          ZegoSendCallInvitationButton(
                            iconSize: const Size(30, 30),
                            isVideoCall: true,
                            buttonSize: const Size(40, 40),
                            icon: ButtonIcon(
                                backgroundColor: Colors.transparent,
                                icon: const MyIcon(
                                  icon: AppAssets.icVideoCall,
                                  width: 20,
                                  height: 20,
                                )),
                            timeoutSeconds: 60,
                            invitees: [
                              ZegoUIKitUser(
                                id: widget.chatRoom.userId,
                                name: widget.chatRoom.name,
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          ZegoSendCallInvitationButton(
                            iconSize: const Size(30, 30),
                            buttonSize: const Size(40, 40),
                            icon: ButtonIcon(
                                backgroundColor: Colors.transparent,
                                icon: const MyIcon(
                                  icon: AppAssets.icVoiceCall,
                                )),
                            isVideoCall: false,
                            timeoutSeconds: 60,
                            invitees: [
                              ZegoUIKitUser(
                                id: widget.chatRoom.userId,
                                name: widget.chatRoom.name,
                              ),
                            ],
                          ),
                        ],
                      )
                    : const SizedBox()
              ],
            ),
          ),
          const Divider(
            thickness: 1,
            color: AppColors.greyColor,
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
                stream: ChatService().getMessages(widget.chatRoom.id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CustomLoadingWidget();
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(snapshot.error.toString()),
                    );
                  } else if (snapshot.hasData && snapshot.data!.size > 0) {
                    List<Message> messages = snapshot.data!.docs
                        .map((e) =>
                            Message.fromMap(e.data() as Map<String, dynamic>))
                        .toList();
                    return ListView.builder(
                      reverse: true,
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        return MessageItem(
                          message: messages[index],
                          chatRoom: widget.chatRoom,
                        );
                      },
                    );
                  } else {
                    return const Center(
                      child: Text('No message'),
                    );
                  }
                }),
          ),
          MessageInput(
            chatRoom: widget.chatRoom,
          ),
        ],
      ),
    );
  }
}
