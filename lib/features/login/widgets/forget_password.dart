import 'package:flutter/material.dart';

import '../../../../core/theme/app_text_styles.dart';

class ForgetPassword extends StatelessWidget {
  const ForgetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Forgot password feature coming soon!')),
        );
      },
      child: Text('Forgot Password?', style: AppTextStyles.font12GreenRegular),
    );
  }
}
