import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import '../../../core/theme/app_text_styles.dart';
import 'info_card.dart';

class UserInfoSection extends StatelessWidget {
  final firebase_auth.User user;

  const UserInfoSection({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Account Information',
          style: AppTextStyles.font16Gray600Regular.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        
        SizedBox(height: 16.h),
        
        InfoCard(
          title: 'Email',
          value: user.email ?? 'Not provided',
          icon: Icons.email_outlined,
        ),
        
        SizedBox(height: 16.h),
        
        InfoCard(
          title: 'Display Name',
          value: user.displayName ?? 'Not provided',
          icon: Icons.person_outline,
        ),
        
        SizedBox(height: 16.h),
        
        InfoCard(
          title: 'Account Created',
          value: user.metadata.creationTime != null
              ? _formatDate(user.metadata.creationTime!)
              : 'Unknown',
          icon: Icons.calendar_today_outlined,
        ),
        
        if (user.metadata.lastSignInTime != null) ...[
          SizedBox(height: 16.h),
          
          InfoCard(
            title: 'Last Sign In',
            value: _formatDate(user.metadata.lastSignInTime!),
            icon: Icons.access_time_outlined,
          ),
        ],
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} at ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
