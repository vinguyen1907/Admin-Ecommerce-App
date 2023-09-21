import 'package:admin_ecommerce_app/constants/firebase_constants.dart';
import 'package:admin_ecommerce_app/models/chat_room.dart';
import 'package:admin_ecommerce_app/models/message.dart';

class ChatRoomRepository {
  Stream<List<ChatRoom>> fetchChatRooms() {
    return chatRoomsRef
        .where('lastMessageTime', isNull: false)
        .orderBy('lastMessageTime', descending: true)
        .snapshots()
        .map((querySnapshot) {
      print(querySnapshot.docs.length);
      return querySnapshot.docs
          .map((e) => ChatRoom.fromMap(e.data() as Map<String, dynamic>))
          .toList();
    });
  }

  Stream<Message> fetchLastMessage(String chatRoomId) {
    return chatRoomsRef
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs
            .map((e) => Message.fromMap(e.data()))
            .toList()
            .first);
  }
}
