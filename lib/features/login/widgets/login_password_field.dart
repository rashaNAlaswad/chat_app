import 'package:flutter/material.dart';

import '../../../core/common/app_text_form_field.dart';
import '../../../core/utils/validation_utils.dart';
import '../../../core/common/password_visibility_toggle.dart';

class LoginPasswordField extends StatefulWidget {
  final TextEditingController controller;

  const LoginPasswordField({
    super.key,
    required this.controller,
  });

  @override
  State<LoginPasswordField> createState() => _LoginPasswordFieldState();
}

class _LoginPasswordFieldState extends State<LoginPasswordField> {
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
