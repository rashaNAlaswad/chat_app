class AppConstants {
  // Firebase Collections
  static const String usersCollection = 'users';
  static const String chatRoomsCollection = 'chatRooms';
  static const String messagesCollection = 'messages';

  // User Model Fields
  static const String userIdField = 'id';
  static const String userEmailField = 'email';
  static const String userDisplayNameField = 'displayName';
  static const String userPhotoUrlField = 'photoUrl';
  static const String userCreatedAtField = 'createdAt';
  static const String userLastSeenField = 'lastSeen';
  static const String userIsOnlineField = 'isOnline';

  // Chat Room Fields
  static const String chatRoomId = 'id';
  static const String chatRoomCurrentUserId = 'currentUserId';
  static const String chatRoomOtherUserId = 'otherUserId';
  static const String chatRoomOtherUserName = 'otherUserName';
  static const String chatRoomLastMessage = 'lastMessage';
  static const String chatRoomLastMessageTime = 'lastMessageTime';
  static const String chatRoomLastMessageSenderId = 'lastMessageSenderId';
  static const String chatRoomUnreadCount = 'unreadCount';
  static const String chatRoomLastMessageSenderName = 'lastMessageSenderName';

  // Chat Message Fields
  static const String chatMessageId = 'id';
  static const String chatMessageSenderId = 'senderId';
  static const String chatMessageSenderName = 'senderName';
  static const String chatMessageContent = 'content';
  static const String chatMessageTimestamp = 'timestamp';
  static const String chatMessageIsRead = 'isRead';
  static const String chatMessageImageUrl = 'imageUrl';
}
