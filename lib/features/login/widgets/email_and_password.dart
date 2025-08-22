import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart' show Provider;

import '../../../core/common/app_text_form_field.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/utils/validation_utils.dart';
import '../../../core/common/password_visibility_toggle.dart';

class EmailAndPassword extends StatefulWidget {
  final Function(GlobalKey<FormState>) onFormKeyCreated;

  const EmailAndPassword({super.key, required this.onFormKeyCreated});

  @override
  State<EmailAndPassword> createState() => _EmailAndPasswordState();
}

class _EmailAndPasswordState extends State<EmailAndPassword> {
  bool _obscurePassword = true;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    widget.onFormKeyCreated(_formKey);
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildEmailField(authProvider),
          SizedBox(height: 16.h),
          _buildPasswordField(authProvider),
          SizedBox(height: 8.h),
        ],
      ),
    );
  }

  Widget _buildEmailField(AuthProvider authProvider) {
    return AppTextFormField(
      controller: authProvider.emailController,
      hintText: 'Email Address',
      keyboardType: TextInputType.emailAddress,
      validator: (value) => ValidationUtils.getEmailValidationError(value),
    );
  }

  Widget _buildPasswordField(AuthProvider authProvider) {
    return AppTextFormField(
      controller: authProvider.passwordController,
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
