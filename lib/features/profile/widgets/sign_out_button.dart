import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/providers/auth_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class SignOutButton extends StatelessWidget {
  final AuthProvider authProvider;
  final VoidCallback onPressed;

  const SignOutButton({
    super.key,
    required this.authProvider,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56.h,
      child: ElevatedButton(
        onPressed: authProvider.isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.red,
          foregroundColor: AppColors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        child: authProvider.isLoading
            ? SizedBox(
                width: 24.w,
                height: 24.w,
                child: const CircularProgressIndicator(
                  color: AppColors.white,
                  strokeWidth: 2,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.logout_outlined,
                    size: 20.sp,
                    color: AppColors.white,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Sign Out',
                    style: AppTextStyles.font16WhiteSemiBold,
                  ),
                ],
              ),
      ),
    );
  }
}
