import 'package:chat_app/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HeaderIntro extends StatelessWidget {
  const HeaderIntro({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Create Account',
          style: AppTextStyles.font32Black100Bold,
        ),
        SizedBox(height: 8.h),
        Text(
          'Sign up to start chatting with friends',
          style: AppTextStyles.font16Gray600Regular,
        ),
      ],
    );
  }
}
