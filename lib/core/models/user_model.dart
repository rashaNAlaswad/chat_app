import 'package:cloud_firestore/cloud_firestore.dart';
import '../constants/app_constants.dart';

class UserModel {
  final String id;
  final String email;
  final String displayName;
  final String? photoUrl;
  final DateTime createdAt;
  final DateTime lastSeen;
  final bool isOnline;

  UserModel({
    required this.id,
    required this.email,
    required this.displayName,
    this.photoUrl,
    required this.createdAt,
    required this.lastSeen,
    this.isOnline = false,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map[AppConstants.userIdField] ?? '',
      email: map[AppConstants.userEmailField] ?? '',
      displayName: map[AppConstants.userDisplayNameField] ?? '',
      photoUrl: map[AppConstants.userPhotoUrlField],
      createdAt: map[AppConstants.userCreatedAtField] != null 
          ? (map[AppConstants.userCreatedAtField] as Timestamp).toDate()
          : DateTime.now(),
      lastSeen: map[AppConstants.userLastSeenField] != null 
          ? (map[AppConstants.userLastSeenField] as Timestamp).toDate()
          : DateTime.now(),
      isOnline: map[AppConstants.userIsOnlineField] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      AppConstants.userIdField: id,
      AppConstants.userEmailField: email,
      AppConstants.userDisplayNameField: displayName,
      AppConstants.userPhotoUrlField: photoUrl,
      AppConstants.userCreatedAtField: createdAt,
      AppConstants.userLastSeenField: lastSeen,
      AppConstants.userIsOnlineField: isOnline,
    };
  }

  Map<String, dynamic> toMapForFirestore() {
    return {
      AppConstants.userIdField: id,
      AppConstants.userEmailField: email,
      AppConstants.userDisplayNameField: displayName,
      AppConstants.userPhotoUrlField: photoUrl,
      AppConstants.userCreatedAtField: FieldValue.serverTimestamp(),
      AppConstants.userLastSeenField: FieldValue.serverTimestamp(),
      AppConstants.userIsOnlineField: isOnline,
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? displayName,
    String? photoUrl,
    DateTime? createdAt,
    DateTime? lastSeen,
    bool? isOnline,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt ?? this.createdAt,
      lastSeen: lastSeen ?? this.lastSeen,
      isOnline: isOnline ?? this.isOnline,
    );
  }
}
