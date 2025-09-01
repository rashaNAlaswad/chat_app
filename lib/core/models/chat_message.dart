import 'package:cloud_firestore/cloud_firestore.dart';

import '../constants/app_constants.dart';

class ChatMessage {
  final String? id;
  final String senderId;
  final String senderName;
  final String content;
  final DateTime timestamp;
  final bool isRead;
  final String? imageUrl;

  const ChatMessage({
    this.id,
    required this.senderId,
    required this.senderName,
    required this.content,
    required this.timestamp,
    this.isRead = false,
    this.imageUrl,
  });

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      id: map[AppConstants.chatMessageId],
      senderId: map[AppConstants.chatMessageSenderId] ?? '',
      senderName: map[AppConstants.chatMessageSenderName] ?? '',
      content: map[AppConstants.chatMessageContent] ?? '',
      timestamp: _parseTimestamp(map[AppConstants.chatMessageTimestamp]),
      isRead: map[AppConstants.chatMessageIsRead] ?? false,
      imageUrl: map[AppConstants.chatMessageImageUrl],
    );
  }

  factory ChatMessage.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ChatMessage(
      id: doc.id,
      senderId: data[AppConstants.chatMessageSenderId] ?? '',
      senderName: data[AppConstants.chatMessageSenderName] ?? '',
      content: data[AppConstants.chatMessageContent] ?? '',
      timestamp: _parseTimestamp(data[AppConstants.chatMessageTimestamp]),
      isRead: data[AppConstants.chatMessageIsRead] ?? false,
      imageUrl: data[AppConstants.chatMessageImageUrl],
    );
  }

  static DateTime _parseTimestamp(dynamic timestamp) {
    if (timestamp != null && timestamp is Timestamp) {
      return timestamp.toDate();
    }
    return DateTime.now();
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = {
      AppConstants.chatMessageSenderId: senderId,
      AppConstants.chatMessageSenderName: senderName,
      AppConstants.chatMessageContent: content,
      AppConstants.chatMessageTimestamp: timestamp,
      AppConstants.chatMessageIsRead: isRead,
    };

    if (id != null && id!.isNotEmpty) {
      map[AppConstants.chatMessageId] = id!;
    }

    if (imageUrl != null) {
      map[AppConstants.chatMessageImageUrl] = imageUrl;
    }

    return map;
  }

  static Map<String, dynamic> toReadUpdateMap() {
    return {AppConstants.chatMessageIsRead: true};
  }

  static ChatMessage createForSending({
    required String senderId,
    required String senderName,
    required String content,
    String? imageUrl,
  }) {
    return ChatMessage(
      senderId: senderId,
      senderName: senderName,
      content: content,
      timestamp: DateTime.now(),
      imageUrl: imageUrl,
    );
  }
}
