import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'core/providers/auth_provider.dart';
import 'core/router/app_router.dart';
import 'core/router/routes.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

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
        return ChangeNotifierProvider(
          create: (context) => AuthProvider(),
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Chat App',
            initialRoute: Routes.login,
            onGenerateRoute: appRouter.onGenerateRoute,
            theme: ThemeData(primarySwatch: Colors.green),
          ),
        );
      },
    );
  }
}
