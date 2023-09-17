import 'package:admin_ecommerce_app/constants/firebase_constants.dart';
import 'package:admin_ecommerce_app/models/chat_room.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'chat_room_event.dart';
part 'chat_room_state.dart';

class ChatRoomBloc extends Bloc<ChatRoomEvent, ChatRoomState> {
  ChatRoomBloc() : super(ChatRoomInitial()) {
    on<LoadChatRooms>(_onLoadChatRooms);
    on<SearchUser>(_onSearchUser);
    on<ChooseChatRoom>(_onChooseChatRoom);
  }

  Future<void> _onLoadChatRooms(
      LoadChatRooms event, Emitter<ChatRoomState> emit) async {
    emit(ChatRoomLoading());
    emit(const ChatRoomLoaded(chatRooms: [], chatRoom: null));
  }

  Future<void> _onSearchUser(
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

  Future<void> _onChooseChatRoom(
      ChooseChatRoom event, Emitter<ChatRoomState> emit) async {
    final currentState = state as ChatRoomLoaded;
    emit(ChatRoomLoading());
    emit(ChatRoomLoaded(
        chatRooms: currentState.chatRooms, chatRoom: event.chatRoom));
  }
}
