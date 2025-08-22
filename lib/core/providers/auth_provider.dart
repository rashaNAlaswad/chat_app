import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  
  bool _isLoading = false;
  String? _errorMessage;
  User? _currentUser;
  
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  User? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
  
  Future<bool> signInWithEmailAndPassword() async {
    _setLoading(true);
    _clearError();
    
    try {
      final user = await _authService.signInWithEmailAndPassword(
        emailController.text.trim(),
        passwordController.text,
      );
      
      _currentUser = user;
      _setLoading(false);
      return true;
    } on FirebaseAuthException catch (e) {
      _handleFirebaseAuthException(e);
      return false;
    } catch (e) {
      _handleGenericError(e);
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _clearError();
    
    try {
      final user = await _authService.createUserWithEmailAndPassword(
        email.trim(),
        password,
      );
      
      _currentUser = user;
      _setLoading(false);
      return true;
    } on FirebaseAuthException catch (e) {
      _handleFirebaseAuthException(e);
      return false;
    } catch (e) {
      _handleGenericError(e);
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  Future<void> signOut() async {
    _setLoading(true);
    
    try {
      await _authService.signOut();
      _currentUser = null;
      _clearControllers();
    } catch (e) {
      _handleGenericError(e);
    } finally {
      _setLoading(false);
    }
  }
  
  void clearForm() {
    _clearControllers();
    _clearError();
  }
  
  
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
  
  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }
  
  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }
  
  void _clearControllers() {
    emailController.clear();
    passwordController.clear();
  }
  
  void _handleFirebaseAuthException(FirebaseAuthException e) {
    String message;
    
    switch (e.code) {
      case 'user-not-found':
        message = 'No user found with this email address.';
        break;
      case 'wrong-password':
        message = 'Incorrect password. Please try again.';
        break;
      case 'invalid-email':
        message = 'Please enter a valid email address.';
        break;
      case 'user-disabled':
        message = 'This account has been disabled.';
        break;
      case 'too-many-requests':
        message = 'Too many failed attempts. Please try again later.';
        break;
      case 'network-request-failed':
        message = 'Network error. Please check your connection.';
        break;
      case 'email-already-in-use':
        message = 'An account with this email already exists.';
        break;
      case 'weak-password':
        message = 'Password is too weak. Please choose a stronger password.';
        break;
      case 'operation-not-allowed':
        message = 'Email/password accounts are not enabled.';
        break;
      default:
        message = 'Authentication failed. Please try again.';
    }
    
    _setError(message);
  }
  
  void _handleGenericError(dynamic error) {
    _setError('An unexpected error occurred. Please try again.');
  }
}