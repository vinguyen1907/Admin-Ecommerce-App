import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:admin_ecommerce_app/constants/app_constant.dart';
import 'package:admin_ecommerce_app/constants/enums/message_type.dart';
import 'package:admin_ecommerce_app/constants/firebase_constants.dart';
import 'package:admin_ecommerce_app/models/chat_room.dart';
import 'package:admin_ecommerce_app/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:universal_html/html.dart' as html;

class ChatService {
  final String userId = AppConstants.adminId;
  final dio = Dio();

  Future<void> sendTextMessage(String content, ChatRoom chatRoom) async {
    final String messageId =
        userId + DateTime.now().millisecondsSinceEpoch.toString();
    Message message = Message(
        id: messageId,
        senderId: userId,
        content: content.trim(),
        imageUrl: '',
        audioUrl: '',
        isRead: false,
        type: MessageType.text,
        timestamp: DateTime.now());

    await sendNotificationToToken(chatRoom.userToken!, content);
    await chatRoomsRef
        .doc(chatRoom.id)
        .collection('messages')
        .doc(messageId)
        .set(message.toMap());
  }

  Future<void> sendImageMessage(Uint8List image, ChatRoom chatRoom) async {
    final String info =
        userId + DateTime.now().millisecondsSinceEpoch.toString();
    try {
      final storageRef = FirebaseStorage.instance.ref().child('chat/chat_img');
      final task = await storageRef
          .child(
              '${userId + DateTime.now().millisecondsSinceEpoch.toString()}.jpg')
          .putData(image);
      final linkImage = await task.ref.getDownloadURL();
      Message message = Message(
          id: info,
          senderId: userId,
          content: '',
          imageUrl: linkImage,
          audioUrl: '',
          isRead: false,
          type: MessageType.image,
          timestamp: DateTime.now());
      await sendNotificationToToken(chatRoom.userToken!, 'Image message.');
      await chatRoomsRef
          .doc(chatRoom.id)
          .collection('messages')
          .doc(info)
          .set(message.toMap());
    } catch (e) {
      log(e.toString());
    }
  }

  // Future<void> sendVoiceMessage(String filePath) async {
  //   final String messageId =
  //       userId + DateTime.now().millisecondsSinceEpoch.toString();
  //   try {
  //     final storageRef =
  //         FirebaseStorage.instance.ref().child('chat/chat_voice');
  //     final task = await storageRef
  //         .child(
  //             '$userId${DateTime.now().millisecondsSinceEpoch.toString()}.mp3')
  //         .putFile(File(filePath));
  //     final linkAudio = await task.ref.getDownloadURL();
  //     Message message = Message(
  //         id: messageId,
  //         senderId: userId,
  //         content: '',
  //         imageUrl: '',
  //         audioUrl: linkAudio,
  //         isRead: false,
  //         type: MessageType.voice,
  //         timestamp: DateTime.now());
  //     await chatRoomsRef
  //         .doc(chatRoomId)
  //         .collection('messages')
  //         .doc(messageId)
  //         .set(message.toMap());
  //   } catch (e) {
  //     log(e.toString());
  //   }
  // }

  Stream<QuerySnapshot> getMessages(String chatRoomId) {
    return chatRoomsRef
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future<html.File> getFileFromBlobPath(String blobPath) async {
    final html.HttpRequest request =
        await html.HttpRequest.request(blobPath, responseType: 'blob');

    final blob = request.response as html.Blob;
    final blobType = blob.type;
    final blobSize = blob.size;

    final html.FileReader reader = html.FileReader();

    reader.readAsArrayBuffer(blob);

    await reader.onLoad.first; // Wait for the reader to load

    final Uint8List blobData = reader.result as Uint8List;

    // Create a file from the blob data
    final html.File file = html.File([blobData], blobPath.split('/').last,
        {'type': blobType, 'size': blobSize});

    return file;
  }

  Future<Uint8List> blobToUint8List(html.Blob blob) async {
    final html.FileReader reader = html.FileReader();
    final Completer<Uint8List> completer = Completer<Uint8List>();

    reader.onLoad.listen((html.Event event) {
      final html.FileReader reader = event.target as html.FileReader;
      final Uint8List uint8List =
          Uint8List.fromList(reader.result as List<int>);
      completer.complete(uint8List);
    });

    reader.readAsArrayBuffer(blob);

    return completer.future;
  }

  Future<void> sendVoiceMessageInWeb(String filePath, ChatRoom chatRoom) async {
    final String messageId =
        userId + DateTime.now().millisecondsSinceEpoch.toString();
    try {
      final html.HttpRequest request =
          await html.HttpRequest.request(filePath, responseType: 'blob');

      final blob = request.response as html.Blob;
      final data = await blobToUint8List(blob);
      final storageRef =
          FirebaseStorage.instance.ref().child('chat/chat_voice');
      final task = await storageRef
          .child(
              '$userId${DateTime.now().millisecondsSinceEpoch.toString()}.m4a')
          .putData(
            data,
            SettableMetadata(contentType: 'audio/mpeg'),
          );
      final linkAudio = await task.ref.getDownloadURL();
      Message message = Message(
          id: messageId,
          senderId: userId,
          content: '',
          imageUrl: '',
          audioUrl: linkAudio,
          isRead: false,
          type: MessageType.voice,
          timestamp: DateTime.now());
      await sendNotificationToToken(chatRoom.userToken!, 'Voice message.');
      await chatRoomsRef
          .doc(chatRoom.id)
          .collection('messages')
          .doc(messageId)
          .set(message.toMap());
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> sendVoiceMessageInMobile(
      String filePath, ChatRoom chatRoom) async {
    final String messageId =
        userId + DateTime.now().millisecondsSinceEpoch.toString();
    try {
      final data = File(filePath);
      final storageRef =
          FirebaseStorage.instance.ref().child('chat/chat_voice');
      final task = await storageRef
          .child(
              '$userId${DateTime.now().millisecondsSinceEpoch.toString()}.m4a')
          .putFile(
            data,
            SettableMetadata(contentType: 'audio/mpeg'),
          );
      final linkAudio = await task.ref.getDownloadURL();
      Message message = Message(
          id: messageId,
          senderId: userId,
          content: '',
          imageUrl: '',
          audioUrl: linkAudio,
          isRead: false,
          type: MessageType.voice,
          timestamp: DateTime.now());
      await sendNotificationToToken(chatRoom.userToken!, 'Voice message.');
      await chatRoomsRef
          .doc(chatRoom.id)
          .collection('messages')
          .doc(messageId)
          .set(message.toMap());
    } catch (e) {
      log(e.toString());
    }
  }

  void markMessageAsRead(String messageId, String chatRoomId) {
    final messageRef =
        chatRoomsRef.doc(chatRoomId).collection('messages').doc(messageId);
    messageRef.update({
      'isRead': true,
    });
  }

  Future<void> sendNotificationToToken(String fcmToken, String body) async {
    const url = 'https://fcm.googleapis.com/fcm/send';
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'key=${AppConstants.serverFirebaseKey}',
    };

    final bodyData = {
      'to': fcmToken,
      'notification': {
        'title': 'Support',
        'body': body,
      },
      'data': {'type': 'chat'}
    };

    // final response = await http.post(
    //   url,
    //   headers: headers,
    //   body: json.encode(bodyData),
    // );

    await dio.post(url,
        data: bodyData,
        options: Options(
          headers: headers,
        ));

    // if (response.statusCode == 200) {
    //   print(
    //       'Thành công: Thông báo đã được gửi đến thiết bị có FCM Token: $fcmToken');
    // } else {
    //   print(
    //       'Lỗi: Không thể gửi thông báo. Mã lỗi: ${response.statusCode}, Lỗi: ${response.body}');
    // }
  }
}
