import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_colors.dart';
import 'app_font_weight.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextStyle font32Black100Bold = TextStyle(
    fontSize: 32.sp,
    fontWeight: AppFontWeight.bold,
    color: AppColors.black100,
  );

  static TextStyle font16Gray600Regular = TextStyle(
    fontSize: 16.sp,
    fontWeight: AppFontWeight.regular,
    color: AppColors.gray60,
  );

  static TextStyle font12GreenRegular = TextStyle(
    fontSize: 12.sp,
    fontWeight: AppFontWeight.regular,
    color: AppColors.greenPrimary,
  );

  static TextStyle font16WhiteSemiBold = TextStyle(
    fontSize: 16.sp,
    fontWeight: AppFontWeight.semiBold,
    color: AppColors.white,
  );

  static TextStyle font14Gray600Regular = TextStyle(
    fontSize: 14.sp,
    fontWeight: AppFontWeight.regular,
    color: AppColors.gray60,
  );

  static TextStyle font14GreenSemiBold = TextStyle(
    fontSize: 14.sp,
    fontWeight: AppFontWeight.semiBold,
    color: AppColors.greenPrimary,
  );
}