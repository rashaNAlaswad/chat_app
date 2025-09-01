import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_model.dart';
import '../constants/app_constants.dart';

class UserProvider extends ChangeNotifier {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  UserProvider(this._auth, this._firestore);

  List<UserModel> _users = [];
  String _searchQuery = '';
  bool _isLoading = false;

  List<UserModel> get users => _users;
  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;

  List<UserModel> get filteredUsers {
    final currentUserId = _auth.currentUser?.uid;
    var filtered = _users.where((user) => user.id != currentUserId).toList();

    if (_searchQuery.isNotEmpty) {
      filtered =
          filtered.where((user) {
            final nameMatch = user.displayName.toLowerCase().contains(
              _searchQuery.toLowerCase(),
            );
            final emailMatch = user.email.toLowerCase().contains(
              _searchQuery.toLowerCase(),
            );
            return nameMatch || emailMatch;
          }).toList();
    }

    return filtered;
  }

  Future<void> loadUsers() async {
    _isLoading = true;
    notifyListeners();

    try {
      final querySnapshot =
          await _firestore
              .collection(AppConstants.usersCollection)
              .orderBy(AppConstants.userDisplayNameField)
              .get();

      _users =
          querySnapshot.docs.map((doc) {
            final data = {...doc.data(), AppConstants.userIdField: doc.id};
            return UserModel.fromMap(data);
          }).toList();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void searchUsers(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  UserModel? getUserById(String userId) {
    try {
      return _users.firstWhere((user) => user.id == userId);
    } catch (e) {
      return null;
    }
  }

  Future<void> updateOnlineStatus(bool isOnline) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return;

    await _firestore
        .collection(AppConstants.usersCollection)
        .doc(currentUser.uid)
        .update({
          AppConstants.userIsOnlineField: isOnline,
          AppConstants.userLastSeenField: FieldValue.serverTimestamp(),
        });
  }
}
