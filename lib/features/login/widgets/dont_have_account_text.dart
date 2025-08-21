import 'package:chat_app/core/helper/navigation_extensions.dart';
import 'package:flutter/material.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/app_text_styles.dart';

class DontHaveAccountText extends StatelessWidget {
  const DontHaveAccountText({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Don\'t have an account? ',
          style: AppTextStyles.font14Gray600Regular,
        ),
        TextButton(
          onPressed: () {
            context.pushNamed(Routes.register);
          },
          child: Text('Sign Up', style: AppTextStyles.font14GreenSemiBold),
        ),
      ],
    );
  }
}
