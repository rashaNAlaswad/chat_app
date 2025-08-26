import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/chat_message.dart';
import '../models/chat_room.dart';

class ChatProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  List<ChatRoom> _chatRooms = [];
  List<ChatMessage> _messages = [];
  bool _isLoading = false;
  String? _currentChatRoomId;

  List<ChatRoom> get chatRooms => _chatRooms;
  List<ChatMessage> get messages => _messages;
  bool get isLoading => _isLoading;
  String? get currentChatRoomId => _currentChatRoomId;

  Future<void> loadChatRooms() async {
    _isLoading = true;
    notifyListeners();

    try {
      final currentUserId = _auth.currentUser?.uid;
      if (currentUserId == null) return;

      final querySnapshot = await _firestore
          .collection('chatRooms')
          .where('currentUserId', isEqualTo: currentUserId)
          .orderBy('lastMessageTime', descending: true)
          .get();

      _chatRooms = querySnapshot.docs
          .map((doc) => ChatRoom.fromMap({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      print('Error loading chat rooms: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
