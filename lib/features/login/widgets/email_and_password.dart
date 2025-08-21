import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart' show Provider;

import '../../../core/common/app_text_form_field.dart';
import '../../../core/helper/app_regex.dart';
import '../../../core/providers/auth_provider.dart';

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
      validator: _validateEmail,
    );
  }

  Widget _buildPasswordField(AuthProvider authProvider) {
    return AppTextFormField(
      controller: authProvider.passwordController,
      hintText: 'Password',
      isObscureText: _obscurePassword,
      suffixIcon: _buildPasswordVisibilityToggle(),
      validator: _validatePassword,
    );
  }

  Widget _buildPasswordVisibilityToggle() {
    return IconButton(
      icon: Icon(
        _obscurePassword ? Icons.visibility : Icons.visibility_off,
        color: Colors.grey[600],
      ),
      onPressed: () {
        _obscurePassword = !_obscurePassword;
        setState(() {});
      },
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your email';
    }

    if (!AppRegex.isEmailValid(value.trim())) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }

    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }

    return null;
  }
}
