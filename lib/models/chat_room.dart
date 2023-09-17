class ChatRoom {
  final String id;
  final String name;
  final String imgUrl;
  final String? userToken;
  final String? adminToken;
  final DateTime createdAt;
  final DateTime? lastMessageTime;
  final String userId;

  ChatRoom(
      {required this.id,
      required this.name,
      required this.imgUrl,
      required this.userToken,
      required this.adminToken,
      required this.createdAt,
      required this.userId,
      required this.lastMessageTime});

  factory ChatRoom.fromMap(Map<String, dynamic> data) {
    return ChatRoom(
      id: data['id'],
      name: data['name'] ?? '',
      imgUrl: data['imgUrl'],
      userToken: data['userToken'],
      adminToken: data['adminToken'],
      userId: data['userId'],
      createdAt: data['createdAt'].toDate(),
      lastMessageTime: data['lastMessageTime'].toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'id': id,
      'imgUrl': imgUrl,
      'userToken': userToken,
      'adminToken': adminToken,
      'userId': userId,
      'createdAt': createdAt,
      'lastMessageTime': lastMessageTime
    };
  }
}
