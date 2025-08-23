import 'package:chat_app/core/helper/navigation_extensions.dart';
import 'package:flutter/material.dart';

import '../../core/router/routes.dart';
import '../../core/theme/app_colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.greenPrimary,
        foregroundColor: AppColors.white,
        title: Text(
          'Chat App',
        ),
        actions: [
          IconButton(
            onPressed: () {
              context.pushNamed(Routes.profile);
            },
            icon: const Icon(Icons.person),
          ),
        ],
      ),
      body: Text('Home'),
    );
  }
}
