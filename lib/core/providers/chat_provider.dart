import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/chat_message.dart';
import '../models/chat_room.dart';
import '../constants/app_constants.dart';

class ChatProvider with ChangeNotifier {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  List<ChatRoom> _chatRooms = [];
  bool _isLoading = false;
  Timer? _debounceTimer;
  final bool _isRefreshing = false;
  final List<ChatMessage> _messages = [];
  String? _currentChatRoomId;
  StreamSubscription<QuerySnapshot>? _messagesSubscription;

  ChatProvider(this._auth, this._firestore);

  List<ChatRoom> get chatRooms => _chatRooms;
  bool get isLoading => _isLoading;

  String? get _currentUserId => _auth.currentUser?.uid;
  String? get currentUserId => _currentUserId;
  List<ChatMessage> get messages => _messages;
  String? get currentChatRoomId => _currentChatRoomId;

  Future<String> getOtherUserName(String chatRoomId) async {
    // First try to find in local chat rooms list
    final existingChatRoom =
        _chatRooms.where((room) => room.id == chatRoomId).firstOrNull;

    if (existingChatRoom != null) {
      return existingChatRoom.otherUserName;
    }

    // If not found locally, try to fetch from Firestore directly
    final doc =
        await _firestore
            .collection(AppConstants.chatRoomsCollection)
            .doc(chatRoomId)
            .get();

    if (doc.exists) {
      final data = doc.data() as Map<String, dynamic>;
      return data[AppConstants.chatRoomOtherUserName] ?? 'Chat';
    }

    return 'Chat';
  }

  Query<Map<String, dynamic>> _buildChatRoomsQuery(String? currentUserId) {
    return _firestore
        .collection(AppConstants.chatRoomsCollection)
        .where(AppConstants.chatRoomCurrentUserId, isEqualTo: currentUserId)
        .orderBy(AppConstants.chatRoomLastMessageTime, descending: true);
  }

  Future<void> loadChatRooms() async {
    if (_isLoading) return;

    _isLoading = true;
    notifyListeners();

    QuerySnapshot querySnapshot =
        await _buildChatRoomsQuery(_currentUserId).get();

    _chatRooms =
        querySnapshot.docs.map((doc) {
          return ChatRoom.fromFirestore(doc);
        }).toList();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> refreshChatRooms() async {
    if (_isRefreshing) return;

    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () async {
      await loadChatRooms();
    });
  }

  Future<String?> createOrFindChatRoom(
    String otherUserId,
    String otherUserName,
  ) async {
    if (currentUserId == null) return null;

    final existingRoom =
        _chatRooms.where((room) => room.otherUserId == otherUserId).firstOrNull;

    if (existingRoom != null) {
      return existingRoom.id;
    }

    // Create new chat room
    final chatRoomData = {
      AppConstants.chatRoomCurrentUserId: currentUserId!,
      AppConstants.chatRoomOtherUserId: otherUserId,
      AppConstants.chatRoomOtherUserName: otherUserName,
      AppConstants.chatRoomLastMessage: '',
      AppConstants.chatRoomLastMessageTime: DateTime.now(),
      AppConstants.chatRoomLastMessageSenderId: '',
      AppConstants.chatRoomUnreadCount: 0,
    };

    final docRef = await _firestore
        .collection(AppConstants.chatRoomsCollection)
        .add(chatRoomData);

    // Create a ChatRoom object and add it to the local list immediately
    final newChatRoom = ChatRoom(
      id: docRef.id,
      currentUserId: currentUserId!,
      otherUserId: otherUserId,
      otherUserName: otherUserName,
      lastMessage: '',
      lastMessageTime: DateTime.now(),
      lastMessageSenderId: '',
      unreadCount: 0,
    );

    _chatRooms.insert(0, newChatRoom);
    notifyListeners();

    return docRef.id;
  }

  Future<void> sendMessage(String message) async {
    if (currentUserId == null || _currentChatRoomId == null) return;

    final currentUserName = _auth.currentUser?.displayName ?? 'User';

    final messageData = ChatMessage.createForSending(
      senderId: currentUserId!,
      senderName: currentUserName,
      content: message,
    );

    final batch = _firestore.batch();
    final chatRoomRef = _firestore
        .collection(AppConstants.chatRoomsCollection)
        .doc(_currentChatRoomId!);

    final messageRef =
        chatRoomRef.collection(AppConstants.messagesCollection).doc();
    batch.set(messageRef, messageData.toMap());

    // Update chat room with last message info
    final updateData = ChatRoom.createLastMessageUpdateMap(
      message,
      currentUserId!,
      currentUserName,
    );

    batch.update(chatRoomRef, updateData);

    await batch.commit();
  }

  void setCurrentChatRoom(String chatRoomId) {
    _currentChatRoomId = chatRoomId;

    _messagesSubscription?.cancel();
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    if (_currentChatRoomId == null) {
      return;
    }

    _messagesSubscription = _firestore
        .collection(AppConstants.chatRoomsCollection)
        .doc(_currentChatRoomId!)
        .collection(AppConstants.messagesCollection)
        .orderBy(AppConstants.chatMessageTimestamp, descending: true)
        .snapshots()
        .listen((snapshot) {
          _messages.clear();
          _messages.addAll(
            snapshot.docs.map((doc) => ChatMessage.fromFirestore(doc)).toList(),
          );
          notifyListeners();
        });
  }

  @override
  void dispose() {
    _messagesSubscription?.cancel();
    super.dispose();
  }
}
