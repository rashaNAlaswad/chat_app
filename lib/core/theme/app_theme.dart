import 'package:flutter/material.dart';

import 'app_colors.dart';

ThemeData appTheme() {
  return ThemeData(
    primaryColor: AppColors.greenPrimary,
    colorScheme: const ColorScheme.light(primary: AppColors.greenPrimary),
  );
}
