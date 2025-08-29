import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'core/di/dependency_injection.dart';
import 'core/providers/auth_provider.dart';
import 'core/providers/chat_provider.dart';
import 'core/providers/user_provider.dart';
import 'core/router/app_router.dart';
import 'core/router/routes.dart';
import 'core/theme/app_theme.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  setupGetIt();

  runApp(MainApp(appRouter: AppRouter()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key, required this.appRouter});
  final AppRouter appRouter;

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: getIt<AuthProvider>()),
            ChangeNotifierProvider.value(value: getIt<UserProvider>()),
            ChangeNotifierProvider.value(value: getIt<ChatProvider>()),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Chat App',
            initialRoute: Routes.login,
            onGenerateRoute: appRouter.onGenerateRoute,
            theme: appTheme(),
          ),
        );
      },
    );
  }
}
