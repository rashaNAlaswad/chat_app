import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class SignOutDialog extends StatelessWidget {
  final VoidCallback onCancel;
  final VoidCallback onConfirm;

  const SignOutDialog({
    super.key,
    required this.onCancel,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      title: Text(
        'Sign Out',
        style: AppTextStyles.font32Black100Bold.copyWith(
          fontSize: 20.sp,
        ),
      ),
      content: Text(
        'Are you sure you want to sign out?',
        style: AppTextStyles.font16Gray600Regular,
      ),
      actions: [
        TextButton(
          onPressed: onCancel,
          child: Text(
            'Cancel',
            style: AppTextStyles.font14GreenSemiBold,
          ),
        ),
        ElevatedButton(
          onPressed: onConfirm,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.red,
            foregroundColor: AppColors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          child: Text(
            'Sign Out',
            style: AppTextStyles.font14GreenSemiBold.copyWith(
              color: AppColors.white,
            ),
          ),
        ),
      ],
    );
  }
}
