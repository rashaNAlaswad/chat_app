import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/providers/auth_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/helper/navigation_extensions.dart';
import '../../core/router/routes.dart';
import '../../core/theme/app_text_styles.dart';
import 'widgets/profile_header.dart';
import 'widgets/user_info_section.dart';
import 'widgets/sign_out_button.dart';
import 'widgets/sign_out_dialog.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: Text('Profile', style: AppTextStyles.font32Black100Bold.copyWith(fontSize: 20.sp)),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            final user = authProvider.currentUser;
            
            if (user == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return SingleChildScrollView(
              padding: EdgeInsets.all(24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProfileHeader(user: user),
                  SizedBox(height: 40.h),
                  UserInfoSection(user: user),
                  SizedBox(height: 40.h),
                  SignOutButton(
                    authProvider: authProvider,
                    onPressed: () => _showSignOutDialog(context, authProvider),
                  ),
                ],
              ),
            );
          },
        ),
    );
  }

  void _showSignOutDialog(BuildContext context, AuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SignOutDialog(
          onCancel: () => context.pop(),
          onConfirm: () async {
            context.pop();
            await _signOut(context, authProvider);
          },
        );
      },
    );
  }

  Future<void> _signOut(BuildContext context, AuthProvider authProvider) async {
    await authProvider.signOut();
    
    if (context.mounted) {
      context.pushNamedAndRemoveUntil(
        Routes.login,
        predicate: (route) => false,
      );
    }
  }
}
