import 'package:flutter/material.dart';

import '../../features/chat/chat_list_screen.dart';
import '../../features/login/login_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/register/register_screen.dart';
import '../../features/chat/chat_detail_screen.dart';
import '../../features/users/user_list_screen.dart';
import 'routes.dart';

class AppRouter {
  Route? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.login:
        return MaterialPageRoute(builder: (context) => const LoginScreen());
      case Routes.register:
        return MaterialPageRoute(builder: (context) => const RegisterScreen());
      case Routes.chatList:
        return MaterialPageRoute(builder: (context) => const ChatListScreen());
      case Routes.profile:
        return MaterialPageRoute(builder: (context) => const ProfileScreen());
      case Routes.chatDetail:
        final chatRoomId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (context) => ChatDetailScreen(chatRoomId: chatRoomId),
        );
      case Routes.userList:
        return MaterialPageRoute(builder: (context) => const UserListScreen());
      default:
        return MaterialPageRoute(builder: (context) => const LoginScreen());
    }
  }
}
