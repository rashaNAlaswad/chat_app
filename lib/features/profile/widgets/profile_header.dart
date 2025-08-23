import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import '../../../core/theme/app_colors.dart';

class ProfileHeader extends StatelessWidget {
  final firebase_auth.User user;

  const ProfileHeader({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            width: 100.w,
            height: 100.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.greenPrimary,
            ),
            child: Center(
              child: Text(
                user.displayName?.isNotEmpty == true
                    ? user.displayName![0].toUpperCase()
                    : user.email![0].toUpperCase(),
                style: TextStyle(
                  fontSize: 40.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
