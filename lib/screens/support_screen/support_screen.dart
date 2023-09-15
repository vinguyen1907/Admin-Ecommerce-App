import 'package:admin_ecommerce_app/blocs/chat_room_bloc/chat_room_bloc.dart';
import 'package:admin_ecommerce_app/common_widgets/custom_loading_widget.dart';
import 'package:admin_ecommerce_app/common_widgets/screen_horizontal_padding_widget.dart';
import 'package:admin_ecommerce_app/common_widgets/screen_name_section.dart';
import 'package:admin_ecommerce_app/common_widgets/search_widget.dart';
import 'package:admin_ecommerce_app/constants/app_colors.dart';
import 'package:admin_ecommerce_app/constants/app_dimensions.dart';
import 'package:admin_ecommerce_app/constants/app_styles.dart';
import 'package:admin_ecommerce_app/models/chat_room.dart';
import 'package:admin_ecommerce_app/repositories/chat_room_repository.dart';
import 'package:admin_ecommerce_app/responsive.dart';
import 'package:admin_ecommerce_app/screens/chat_screen/chat_screen.dart';
import 'package:admin_ecommerce_app/screens/support_screen/widgets/chat_room_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});
  static const String routeName = "/support-screen";

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  final TextEditingController _controller = TextEditingController();
  final chat = ChatRoomRepository();
  final chatRooms = StreamBuilder<List<ChatRoom>>(
    stream: ChatRoomRepository().fetchChatRooms(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const CustomLoadingWidget();
      }
      if (snapshot.hasData) {
        return ListView.separated(
            itemBuilder: (context, index) {
              return ChatRoomItem(chatRoom: snapshot.data![index]);
            },
            separatorBuilder: (context, index) => const SizedBox(
                  height: 10,
                ),
            itemCount: snapshot.data!.length);
      }
      return const SizedBox();
    },
  );
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocBuilder<ChatRoomBloc, ChatRoomState>(
      builder: (context, state) {
        if (state is ChatRoomLoading) {
          return const CustomLoadingWidget();
        } else if (state is ChatRoomLoaded) {
          return SafeArea(
              child: ScreenHorizontalPaddingWidget(
            child: Column(
              children: [
                const ScreenNameSection("Support"),
                Expanded(
                    child: Row(
                  children: [
                    Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Container(
                                  constraints:
                                      const BoxConstraints(minHeight: 50),
                                  decoration: BoxDecoration(
                                      color: AppColors.whiteColor,
                                      borderRadius:
                                          AppDimensions.defaultBorderRadius),
                                  child: Center(
                                    child: TextField(
                                        controller: _controller,
                                        style: AppStyles.titleSmall,
                                        onSubmitted: (value) {
                                          context
                                              .read<ChatRoomBloc>()
                                              .add(SearchUser(query: value));
                                        },
                                        decoration: InputDecoration(
                                          constraints: const BoxConstraints(
                                            minHeight: 40,
                                          ),
                                          // suffixIcon: suffixIcon,
                                          isDense: true,
                                          contentPadding:
                                              const EdgeInsets.all(12),
                                          hintText: 'Search',
                                          hintStyle: AppStyles.titleSmall
                                              .copyWith(
                                                  color:
                                                      AppColors.greyTextColor),
                                          border: InputBorder.none,
                                        )),
                                  )),
                            ),
                            Expanded(
                              child: state.chatRooms.isNotEmpty
                                  ? ListView.separated(
                                      itemBuilder: (context, index) {
                                        return ChatRoomItem(
                                            chatRoom: state.chatRooms[index]);
                                      },
                                      separatorBuilder: (context, index) =>
                                          const SizedBox(
                                            height: 10,
                                          ),
                                      itemCount: state.chatRooms.length)
                                  : chatRooms,
                            ),
                          ],
                        )),
                    SizedBox(
                      width: size.width * 0.01,
                    ),
                    Responsive.isDesktop(context)
                        ? Expanded(
                            flex: 4,
                            child: state.chatRoom != null
                                ? ChatScreen(
                                    chatRoom: state.chatRoom!,
                                  )
                                : const SizedBox())
                        : const SizedBox()
                  ],
                ))
              ],
            ),
          ));
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
