import 'package:admin_ecommerce_app/constants/enums/message_type.dart';
import 'package:admin_ecommerce_app/extensions/string_extensions.dart';

class Message {
  final String id;
  final String senderId;
  final String content;
  final String imageUrl;
  final String audioUrl;
  final bool isRead;
  final MessageType type;
  final DateTime timestamp;

  Message({
    required this.id,
    required this.senderId,
    required this.isRead,
    required this.content,
    required this.imageUrl,
    required this.audioUrl,
    required this.type,
    required this.timestamp,
  });

  factory Message.fromMap(Map<String, dynamic> json) {
    MessageType temp;
    switch ((json['type'] as String).toMessageType()) {
      case MessageType.text:
        temp = MessageType.text;
      case MessageType.image:
        temp = MessageType.image;
      case MessageType.voice:
        temp = MessageType.voice;
      default:
        temp = MessageType.text;
    }
    return Message(
      id: json['id'],
      isRead: json['isRead'],
      senderId: json['senderId'],
      content: json['content'],
      imageUrl: json['imageUrl'],
      audioUrl: json['audioUrl'],
      type: temp,
      timestamp: json['timestamp'].toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'senderId': senderId,
      'content': content,
      'imageUrl': imageUrl,
      'isRead': isRead,
      'audioUrl': audioUrl,
      'type': type.name,
      'timestamp': timestamp,
    };
  }

  Message copyWith({
    String? id,
    String? senderId,
    String? content,
    String? imageUrl,
    String? audioUrl,
    bool? isRead,
    MessageType? type,
    DateTime? timestamp,
  }) {
    return Message(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      audioUrl: audioUrl ?? this.audioUrl,
      isRead: isRead ?? this.isRead,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
