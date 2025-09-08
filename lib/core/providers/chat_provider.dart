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
