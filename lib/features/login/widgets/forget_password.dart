import 'package:flutter/material.dart';

import '../../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/utils.dart';

class ForgetPassword extends StatelessWidget {
  const ForgetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Utils.showErrorSnackBar(
          message: 'Forgot password feature coming soon!',
          backgroundColor: AppColors.gray60,
          context: context,
        );
      },
      child: Text('Forgot Password?', style: AppTextStyles.font12GreenRegular),
    );
  }
}
