import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/chat_room.dart';
import '../constants/app_constants.dart';

class ChatProvider with ChangeNotifier {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  List<ChatRoom> _chatRooms = [];
  bool _isLoading = false;
  Timer? _debounceTimer;
  bool _isRefreshing = false;

  ChatProvider(this._auth, this._firestore);

  List<ChatRoom> get chatRooms => _chatRooms;
  bool get isLoading => _isLoading;

  String? get _currentUserId => _auth.currentUser?.uid;
  String? get currentUserId => _currentUserId;

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

    try {
      QuerySnapshot querySnapshot =
          await _buildChatRoomsQuery(_currentUserId).get();

      _chatRooms =
          querySnapshot.docs.map((doc) {
            return ChatRoom.fromFirestore(doc);
          }).toList();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshChatRooms() async {
    if (_isRefreshing) return;

    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () async {
      await loadChatRooms();
    });
  }
}
