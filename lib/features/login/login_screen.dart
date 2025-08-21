import 'package:chat_app/core/helper/navigation_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../core/providers/auth_provider.dart';
import '../../core/router/routes.dart';
import 'widgets/divider_section.dart';
import 'widgets/dont_have_account_text.dart';
import 'widgets/email_and_password.dart';
import 'widgets/forget_password.dart';
import 'widgets/header_intro.dart';
import 'widgets/login_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GlobalKey<FormState>? _formKey;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 60.h),
              HeaderIntro(),
              SizedBox(height: 40.h),
              EmailAndPassword(
                onFormKeyCreated: (formKey) {
                  _formKey = formKey;
                },
              ),
              Align(alignment: Alignment.centerRight, child: ForgetPassword()),
              SizedBox(height: 24.h),
              LoginButton(
                onPressed: _handleLogin,
              ),
              SizedBox(height: 24.h),
              DividerSection(),
              SizedBox(height: 24.h),
              DontHaveAccountText(),
            ],
          ),
        ),
      ),
    );
  }


  Future<void> _handleLogin() async {
    if (!_validateForm()) return;

    try {
      final success = await Provider.of<AuthProvider>(context, listen: false).signInWithEmailAndPassword();
      _handleAuthenticationResult(success);
    } catch (e) {
      _handleAuthenticationError(e);
    }
  }

  bool _validateForm() {
    final isValid = _formKey?.currentState?.validate() ?? false;
    return isValid;
  }


  void _handleAuthenticationResult(bool success) {
    if (!mounted) return;

    if (success) {
    context.pushReplacementNamed(Routes.home);
    } else {
      _showAuthenticationError();
    }
  }

  void _handleAuthenticationError(dynamic error) {
    if (!mounted) return;
    
    _showErrorSnackBar(
      message: 'Authentication failed: ${error.toString()}',
      backgroundColor: Colors.red,
    );
  }


  void _showAuthenticationError() {
    _showErrorSnackBar(
      message: 'Invalid email or password. Please try again.',
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
    );
  }
}
