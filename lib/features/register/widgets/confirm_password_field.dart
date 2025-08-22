import 'package:flutter/material.dart';

import '../../../core/common/app_text_form_field.dart';
import '../../../core/utils/validation_utils.dart';
import '../../../core/common/password_visibility_toggle.dart';

class ConfirmPasswordField extends StatefulWidget {
  final TextEditingController controller;
  final TextEditingController passwordController;

  const ConfirmPasswordField({
    super.key,
    required this.controller,
    required this.passwordController,
  });

  @override
  State<ConfirmPasswordField> createState() => _ConfirmPasswordFieldState();
}

class _ConfirmPasswordFieldState extends State<ConfirmPasswordField> {
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return AppTextFormField(
      controller: widget.controller,
      hintText: 'Confirm Password',
      isObscureText: _obscureConfirmPassword,
      suffixIcon: _buildPasswordVisibilityToggle(),
      validator: (value) => ValidationUtils.getConfirmPasswordValidationError(value, widget.passwordController.text),
    );
  }

  Widget _buildPasswordVisibilityToggle() {
    return PasswordVisibilityToggle(
      isObscured: _obscureConfirmPassword,
      onToggle: () {
        setState(() {
          _obscureConfirmPassword = !_obscureConfirmPassword;
        });
      },
    );
  }
}
