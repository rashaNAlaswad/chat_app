import 'package:flutter/material.dart';

import '../../../core/common/app_text_form_field.dart';
import '../../../core/utils/validation_utils.dart';

class NameField extends StatelessWidget {
  final TextEditingController controller;

  const NameField({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return AppTextFormField(
      controller: controller,
      hintText: 'Full Name',
      validator: (value) => ValidationUtils.getNameValidationError(value),
    );
  }
}
