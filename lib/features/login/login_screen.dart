import 'package:chat_app/core/helper/navigation_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../core/providers/auth_provider.dart';
import '../../core/router/routes.dart';
import 'widgets/divider_section.dart';
import 'widgets/dont_have_account_text.dart';
import 'widgets/forget_password.dart';
import 'widgets/header_intro.dart';
import 'widgets/login_button.dart';
import 'widgets/login_email_field.dart';
import 'widgets/login_password_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _formKey.currentState?.reset();
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _formKey.currentState?.reset();
    super.dispose();
  }

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
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    LoginEmailField(controller: _emailController),
                    SizedBox(height: 16.h),
                    LoginPasswordField(controller: _passwordController),
                    SizedBox(height: 8.h),
                  ],
                ),    
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
      final success = await Provider.of<AuthProvider>(context, listen: false).signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      _handleAuthenticationResult(success);
    } catch (e) {
      _handleAuthenticationError(e);
    }
  }

  bool _validateForm() {
    final isValid = _formKey.currentState?.validate() ?? false;
    return isValid;
  }


  void _handleAuthenticationResult(bool success) {
    if (!mounted) return;

    if (success) {
      context.pushReplacementNamed(Routes.chatList);
    } else {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final errorMessage = authProvider.errorMessage ?? 'Invalid email or password. Please try again.';
      
      _showErrorSnackBar(
        message: errorMessage,
        backgroundColor: Colors.red,
      );
    }
  }

  void _handleAuthenticationError(dynamic error) {
    if (!mounted) return;
    
    _showErrorSnackBar(
      message: 'Authentication failed: ${error.toString()}',
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
