import 'dart:async';

import 'package:admin_ecommerce_app/constants/firebase_constants.dart';
import 'package:admin_ecommerce_app/models/chat_room.dart';
import 'package:admin_ecommerce_app/repositories/chat_room_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'chat_room_event.dart';
part 'chat_room_state.dart';

class ChatRoomBloc extends Bloc<ChatRoomEvent, ChatRoomState> {
  ChatRoomBloc() : super(ChatRoomInitial()) {
    on<LoadChatRooms>(_onLoadChatRooms);
    on<SearchUser>(_onSearchUser);
    on<ChooseChatRoom>(_onChooseChatRoom);
  }

  FutureOr<void> _onLoadChatRooms(
      LoadChatRooms event, Emitter<ChatRoomState> emit) {
    emit(ChatRoomLoading());
    emit(const ChatRoomLoaded(chatRooms: [], chatRoom: null));
  }

  FutureOr<void> _onSearchUser(
      SearchUser event, Emitter<ChatRoomState> emit) async {
    final currentState = state as ChatRoomLoaded;
    List<ChatRoom> chatRooms = [];
    await chatRoomsRef
        .where('name', isEqualTo: event.query)
        .get()
        .then((value) {
      chatRooms.addAll(value.docs
          .map((e) => ChatRoom.fromMap(e.data() as Map<String, dynamic>)));
    });
    emit(ChatRoomLoading());
    emit(ChatRoomLoaded(chatRooms: chatRooms, chatRoom: currentState.chatRoom));
  }

  FutureOr<void> _onChooseChatRoom(
      ChooseChatRoom event, Emitter<ChatRoomState> emit) {
    final currentState = state as ChatRoomLoaded;
    emit(ChatRoomLoading());
    emit(ChatRoomLoaded(
        chatRooms: currentState.chatRooms, chatRoom: event.chatRoom));
  }
}
