import 'package:chat_app/core/helper/navigation_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../core/providers/auth_provider.dart';
import '../../core/router/routes.dart';
import 'widgets/confirm_password_field.dart';
import 'widgets/email_field.dart';
import 'widgets/header_intro.dart';
import 'widgets/name_field.dart';
import 'widgets/password_field.dart';
import 'widgets/register_button.dart';
import 'widgets/sign_in_link.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _formKey.currentState?.reset();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _formKey.currentState?.reset();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 40.h),
                const HeaderIntro(),
                SizedBox(height: 40.h),
                _buildFormFields(),
                SizedBox(height: 24.h),
                RegisterButton(onPressed: _handleRegister),
                SizedBox(height: 24.h),
                const SignInLink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormFields() {
    return Column(
      spacing: 16.h,
      children: [
        NameField(controller: _nameController),
        EmailField(controller: _emailController),
        PasswordField(controller: _passwordController),
        ConfirmPasswordField(
          controller: _confirmPasswordController,
          passwordController: _passwordController,
        ),
      ],
    );
  }

  Future<void> _handleRegister() async {
    if (!_validateForm()) return;

    try {
      final success =
          await Provider.of<AuthProvider>(
            context,
            listen: false,
          ).createUserWithEmailAndPassword(
            email: _emailController.text,
            password: _passwordController.text,
            displayName: _nameController.text,
          );
      _handleRegistrationResult(success);
    } catch (e) {
      _handleRegistrationError(e);
    }
  }

  bool _validateForm() {
    final isValid = _formKey.currentState?.validate() ?? false;

    return isValid;
  }

  void _handleRegistrationResult(bool success) {
    if (!mounted) return;

    if (success) {
      context.pushReplacementNamed(Routes.home);
    } else {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final errorMessage = authProvider.errorMessage ?? 'Registration failed. Please try again.';
      
      _showErrorSnackBar(
        message: errorMessage,
        backgroundColor: Colors.red,
      );
    }
  }

  void _handleRegistrationError(dynamic error) {
    if (!mounted) return;

    _showErrorSnackBar(
      message: 'Registration failed: ${error.toString()}',
      backgroundColor: Colors.red,
    );
  }

  void _showErrorSnackBar({
    required String message,
    required Color backgroundColor,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(16.w),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      ),
    );
  }
}
