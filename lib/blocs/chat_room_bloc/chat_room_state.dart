part of 'chat_room_bloc.dart';

abstract class ChatRoomState extends Equatable {
  const ChatRoomState();
}

class ChatRoomInitial extends ChatRoomState {
  @override
  List<Object> get props => [];
}

class ChatRoomLoading extends ChatRoomState {
  @override
  List<Object> get props => [];
}

class ChatRoomLoaded extends ChatRoomState {
  final List<ChatRoom> chatRooms;
  final ChatRoom? chatRoom;
  const ChatRoomLoaded({
    required this.chatRooms,
    required this.chatRoom,
  });
  @override
  List<Object> get props => [
        chatRooms,
      ];
}
