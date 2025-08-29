import 'package:cloud_firestore/cloud_firestore.dart' show FirebaseFirestore;
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:get_it/get_it.dart';

import '../providers/auth_provider.dart';
import '../providers/chat_provider.dart';
import '../providers/user_provider.dart';
import '../services/auth_service.dart';
import '../services/user_profile_service.dart';

final getIt = GetIt.instance;

void setupGetIt() {
  // Register Firebase instances
  getIt.registerSingleton<FirebaseAuth>(FirebaseAuth.instance);
  getIt.registerSingleton<FirebaseFirestore>(FirebaseFirestore.instance);

  // Register services
  getIt.registerLazySingleton<AuthService>(
    () => AuthService(getIt<FirebaseAuth>()),
  );

  getIt.registerLazySingleton<UserProfileService>(
    () => UserProfileService(getIt<FirebaseAuth>(), getIt<FirebaseFirestore>()),
  );

  // Register providers
  getIt.registerLazySingleton<AuthProvider>(
    () => AuthProvider(getIt<AuthService>(), getIt<UserProfileService>()),
  );

  getIt.registerLazySingleton<UserProvider>(
    () => UserProvider(getIt<FirebaseAuth>(), getIt<FirebaseFirestore>()),
  );

  getIt.registerLazySingleton<ChatProvider>(
    () => ChatProvider(getIt<FirebaseAuth>(), getIt<FirebaseFirestore>()),
  );
}
