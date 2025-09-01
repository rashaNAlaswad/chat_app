import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../constants/app_constants.dart';

class UserProfileService {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  UserProfileService(this._auth, this._firestore);

  Future<void> createUserProfile(User user, String displayName) async {
    final userModel = UserModel(
      id: user.uid,
      email: user.email ?? '',
      displayName: displayName,
      photoUrl: user.photoURL,
      createdAt: DateTime.now(),
      lastSeen: DateTime.now(),
      isOnline: true,
    );

    await _firestore
        .collection(AppConstants.usersCollection)
        .doc(user.uid)
        .set(userModel.toMapForFirestore());
  }

  Future<void> ensureUserProfileExists(User user) async {
    final userDoc =
        await _firestore
            .collection(AppConstants.usersCollection)
            .doc(user.uid)
            .get();

    if (!userDoc.exists) {
      final displayName =
          user.displayName ?? user.email?.split('@')[0] ?? 'User';
      await createUserProfile(user, displayName);
    }
  }

  Future<void> updateUserDisplayName(String displayName) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(user.uid)
          .update({AppConstants.userDisplayNameField: displayName});
    }
  }

  Future<void> setUserOnline() async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(user.uid)
          .update({
            AppConstants.userIsOnlineField: true,
            AppConstants.userLastSeenField: FieldValue.serverTimestamp(),
          });
    }
  }

  Future<void> setUserOffline() async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(user.uid)
          .update({
            AppConstants.userIsOnlineField: false,
            AppConstants.userLastSeenField: FieldValue.serverTimestamp(),
          });
    }
  }

  Future<void> initializeUserProfile() async {
    final user = _auth.currentUser;
    if (user != null) {
      await ensureUserProfileExists(user);
      await setUserOnline();
    }
  }
}
