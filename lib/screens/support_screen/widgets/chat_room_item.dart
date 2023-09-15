import 'package:admin_ecommerce_app/blocs/chat_room_bloc/chat_room_bloc.dart';
import 'package:admin_ecommerce_app/common_widgets/custom_loading_widget.dart';
import 'package:admin_ecommerce_app/constants/app_colors.dart';
import 'package:admin_ecommerce_app/constants/app_dimensions.dart';
import 'package:admin_ecommerce_app/constants/app_styles.dart';
import 'package:admin_ecommerce_app/constants/enums/message_type.dart';
import 'package:admin_ecommerce_app/extensions/date_time_extension.dart';
import 'package:admin_ecommerce_app/models/chat_room.dart';
import 'package:admin_ecommerce_app/models/message.dart';
import 'package:admin_ecommerce_app/repositories/chat_room_repository.dart';
import 'package:admin_ecommerce_app/responsive.dart';
import 'package:admin_ecommerce_app/screens/chat_screen/chat_screen.dart';
import 'package:admin_ecommerce_app/screens/support_screen/widgets/content_last_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatRoomItem extends StatelessWidget {
  const ChatRoomItem({super.key, required this.chatRoom});
  final ChatRoom chatRoom;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<ChatRoomBloc>().add(ChooseChatRoom(chatRoom: chatRoom));
        if (Responsive.isMobile(context)) {
          Navigator.pushNamed(context, ChatScreen.routeName,
              arguments: chatRoom);
        }
      },
      child: Container(
          decoration: BoxDecoration(
              borderRadius: AppDimensions.defaultBorderRadius,
              color: AppColors.whiteColor),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage(chatRoom.imgUrl),
                ),
              ),
              StreamBuilder<Message>(
                stream: ChatRoomRepository().fetchLastMessage(chatRoom.id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CustomLoadingWidget();
                  } else if (snapshot.hasData) {
                    return Expanded(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                chatRoom.name,
                                style: AppStyles.labelMedium,
                                overflow: TextOverflow.ellipsis,
                              ),
                              ContentLastMessage(message: snapshot!.data!)
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            snapshot.data!.timestamp.formattedDateChat(),
                            style: AppStyles.bodySmall.copyWith(
                                color: AppColors.primaryColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w400),
                          ),
                        )
                      ],
                    ));
                  } else {
                    return const SizedBox();
                  }
                },
              )
            ],
          )),
    );
  }
}
