part of 'chat_room_bloc.dart';

abstract class ChatRoomEvent extends Equatable {
  const ChatRoomEvent();
}

class LoadChatRooms extends ChatRoomEvent {
  const LoadChatRooms();

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class SearchUser extends ChatRoomEvent {
  const SearchUser({required this.query});
  final String query;
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class ChooseChatRoom extends ChatRoomEvent {
  const ChooseChatRoom({required this.chatRoom});
  final ChatRoom chatRoom;
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
