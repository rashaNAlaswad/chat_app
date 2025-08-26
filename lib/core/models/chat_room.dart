import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoom {
  final String id;
  final String currentUserId;
  final String otherUserId;
  final String otherUserName;
  final String lastMessage;
  final DateTime lastMessageTime;
  final String lastMessageSenderId;
  final int unreadCount;
  final String? lastMessageSenderName;

  ChatRoom({
    required this.id,
    required this.currentUserId,
    required this.otherUserId,
    required this.otherUserName,
    this.lastMessage = '',
    required this.lastMessageTime,
    this.lastMessageSenderId = '',
    this.unreadCount = 0,
    this.lastMessageSenderName,
  });

  factory ChatRoom.fromMap(Map<String, dynamic> map) {
    return ChatRoom(
      id: map['id'] ?? '',
      currentUserId: map['currentUserId'] ?? '',
      otherUserId: map['otherUserId'] ?? '',
      otherUserName: map['otherUserName'] ?? '',
      lastMessage: map['lastMessage'] ?? '',
      lastMessageTime: map['lastMessageTime'] != null 
          ? (map['lastMessageTime'] as Timestamp).toDate()
          : DateTime.now(),
      lastMessageSenderId: map['lastMessageSenderId'] ?? '',
      unreadCount: map['unreadCount'] ?? 0,
      lastMessageSenderName: map['lastMessageSenderName'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'currentUserId': currentUserId,
      'otherUserId': otherUserId,
      'otherUserName': otherUserName,
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime,
      'lastMessageSenderId': lastMessageSenderId,
      'unreadCount': unreadCount,
      'lastMessageSenderName': lastMessageSenderName,
    };
  }
}
