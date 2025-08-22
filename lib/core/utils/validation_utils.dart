import '../helper/app_regex.dart';

class ValidationUtils {
  static bool isValidEmail(String email) {
    return AppRegex.isEmailValid(email.trim());
  }

  static bool isValidPassword(String password) {
    return password.length >= 6;
  }

  static bool isValidName(String name) {
    return name.trim().length >= 2;
  }

  static String? getEmailValidationError(String? email) {
    if (email == null || email.trim().isEmpty) {
      return 'Please enter your email';
    }
    
    if (!isValidEmail(email)) {
      return 'Please enter a valid email address';
    }
    
    return null;
  }

  static String? getPasswordValidationError(String? password) {
    if (password == null || password.isEmpty) {
      return 'Please enter your password';
    }
    
    if (!isValidPassword(password)) {
      return 'Password must be at least 6 characters';
    }
    
    return null;
  }

  static String? getNameValidationError(String? name) {
    if (name == null || name.trim().isEmpty) {
      return 'Please enter your name';
    }
    
    if (!isValidName(name)) {
      return 'Name must be at least 2 characters';
    }
    
    return null;
  }

  static String? getConfirmPasswordValidationError(String? confirmPassword, String password) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return 'Please confirm your password';
    }
    
    if (confirmPassword != password) {
      return 'Passwords do not match';
    }
    
    return null;
  }
}
