import 'package:flutter/material.dart';

class PasswordVisibilityToggle extends StatelessWidget {
  final bool isObscured;
  final VoidCallback onToggle;

  const PasswordVisibilityToggle({
    super.key,
    required this.isObscured,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        isObscured ? Icons.visibility : Icons.visibility_off,
        color: Colors.grey[600],
      ),
      onPressed: onToggle,
    );
  }
}
