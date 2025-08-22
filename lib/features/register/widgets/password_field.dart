import 'package:flutter/material.dart';

import '../../../core/common/app_text_form_field.dart';
import '../../../core/utils/validation_utils.dart';
import '../../../core/common/password_visibility_toggle.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController controller;

  const PasswordField({
    super.key,
    required this.controller,
  });

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return AppTextFormField(
      controller: widget.controller,
      hintText: 'Password',
      isObscureText: _obscurePassword,
      suffixIcon: _buildPasswordVisibilityToggle(),
      validator: (value) => ValidationUtils.getPasswordValidationError(value),
    );
  }

  Widget _buildPasswordVisibilityToggle() {
    return PasswordVisibilityToggle(
      isObscured: _obscurePassword,
      onToggle: () {
        setState(() {
          _obscurePassword = !_obscurePassword;
        });
      },
    );
  }
}
