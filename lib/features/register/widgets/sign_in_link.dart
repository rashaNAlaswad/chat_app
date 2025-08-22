import 'package:flutter/material.dart';

import '../../../core/theme/app_text_styles.dart';

class SignInLink extends StatelessWidget {
  const SignInLink({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Already have an account? ',
          style: AppTextStyles.font14Gray600Regular,
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Sign In',
            style: AppTextStyles.font14GreenPrimarySemiBold,
          ),
        ),
      ],
    );
  }
}
