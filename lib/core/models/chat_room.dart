import 'package:cloud_firestore/cloud_firestore.dart';

import '../constants/app_constants.dart';

class ChatRoom {
  final String? id;
  final String currentUserId;
  final String otherUserId;
  final String otherUserName;
  final String lastMessage;
  final DateTime lastMessageTime;
  final String lastMessageSenderId;
  final int unreadCount;
  final String? lastMessageSenderName;

  const ChatRoom({
    this.id,
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
      id: map[AppConstants.chatRoomId],
      currentUserId: map[AppConstants.chatRoomCurrentUserId] ?? '',
      otherUserId: map[AppConstants.chatRoomOtherUserId] ?? '',
      otherUserName: map[AppConstants.chatRoomOtherUserName] ?? '',
      lastMessage: map[AppConstants.chatRoomLastMessage] ?? '',
      lastMessageTime: _parseTimestamp(
        map[AppConstants.chatRoomLastMessageTime],
      ),
      lastMessageSenderId: map[AppConstants.chatRoomLastMessageSenderId] ?? '',
      unreadCount: map[AppConstants.chatRoomUnreadCount] ?? 0,
      lastMessageSenderName: map[AppConstants.chatRoomLastMessageSenderName],
    );
  }

  factory ChatRoom.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ChatRoom(
      id: doc.id,
      currentUserId: data[AppConstants.chatRoomCurrentUserId] ?? '',
      otherUserId: data[AppConstants.chatRoomOtherUserId] ?? '',
      otherUserName: data[AppConstants.chatRoomOtherUserName] ?? '',
      lastMessage: data[AppConstants.chatRoomLastMessage] ?? '',
      lastMessageTime: _parseTimestamp(
        data[AppConstants.chatRoomLastMessageTime],
      ),
      lastMessageSenderId: data[AppConstants.chatRoomLastMessageSenderId] ?? '',
      unreadCount: data[AppConstants.chatRoomUnreadCount] ?? 0,
      lastMessageSenderName: data[AppConstants.chatRoomLastMessageSenderName],
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
      AppConstants.chatRoomCurrentUserId: currentUserId,
      AppConstants.chatRoomOtherUserId: otherUserId,
      AppConstants.chatRoomOtherUserName: otherUserName,
      AppConstants.chatRoomLastMessage: lastMessage,
      AppConstants.chatRoomLastMessageTime: lastMessageTime,
      AppConstants.chatRoomLastMessageSenderId: lastMessageSenderId,
      AppConstants.chatRoomUnreadCount: unreadCount,
    };

    if (id != null && id!.isNotEmpty) {
      map[AppConstants.chatRoomId] = id;
    }

    if (lastMessageSenderName != null) {
      map[AppConstants.chatRoomLastMessageSenderName] = lastMessageSenderName;
    }

    return map;
  }

  static Map<String, dynamic> createLastMessageUpdateMap(
    String message,
    String senderId,
    String senderName,
  ) {
    return {
      AppConstants.chatRoomLastMessage: message,
      AppConstants.chatRoomLastMessageTime: DateTime.now(),
      AppConstants.chatRoomLastMessageSenderId: senderId,
      AppConstants.chatRoomLastMessageSenderName: senderName,
      AppConstants.chatRoomUnreadCount: 0,
    };
  }

  static Map<String, dynamic> createUnreadCountUpdateMap() {
    return {AppConstants.chatRoomUnreadCount: FieldValue.increment(1)};
  }

  static Map<String, dynamic> createResetUnreadCountUpdateMap() {
    return {AppConstants.chatRoomUnreadCount: 0};
  }

  ChatRoom copyWith({
    String? id,
    String? currentUserId,
    String? otherUserId,
    String? otherUserName,
    String? lastMessage,
    DateTime? lastMessageTime,
    String? lastMessageSenderId,
    int? unreadCount,
    String? lastMessageSenderName,
  }) {
    return ChatRoom(
      id: id ?? this.id,
      currentUserId: currentUserId ?? this.currentUserId,
      otherUserId: otherUserId ?? this.otherUserId,
      otherUserName: otherUserName ?? this.otherUserName,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      lastMessageSenderId: lastMessageSenderId ?? this.lastMessageSenderId,
      unreadCount: unreadCount ?? this.unreadCount,
      lastMessageSenderName:
          lastMessageSenderName ?? this.lastMessageSenderName,
    );
  }

  ChatRoom withId(String newId) {
    return ChatRoom(
      id: newId,
      currentUserId: currentUserId,
      otherUserId: otherUserId,
      otherUserName: otherUserName,
      lastMessage: lastMessage,
      lastMessageTime: lastMessageTime,
      lastMessageSenderId: lastMessageSenderId,
      unreadCount: unreadCount,
      lastMessageSenderName: lastMessageSenderName,
    );
  }
}
