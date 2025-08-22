import 'package:flutter/material.dart';

import '../../../core/common/app_text_form_field.dart';
import '../../../core/utils/validation_utils.dart';

class EmailField extends StatelessWidget {
  final TextEditingController controller;

  const EmailField({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return AppTextFormField(
      controller: controller,
      hintText: 'Email Address',
      keyboardType: TextInputType.emailAddress,
      validator: (value) => ValidationUtils.getEmailValidationError(value),
    );
  }
}
