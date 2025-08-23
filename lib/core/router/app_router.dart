import 'package:flutter/material.dart';

import '../../features/home/home_screen.dart';
import '../../features/login/login_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/register/register_screen.dart';
import 'routes.dart';

class AppRouter {
  Route? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.login:
        return MaterialPageRoute(builder: (context) => const LoginScreen());
      case Routes.register:
        return MaterialPageRoute(builder: (context) => const RegisterScreen());
      case Routes.home:
        return MaterialPageRoute(builder: (context) => const HomeScreen());
      case Routes.profile:
        return MaterialPageRoute(builder: (context) => const ProfileScreen());
      default:
        return MaterialPageRoute(builder: (context) => const LoginScreen());
    }
  }
}
