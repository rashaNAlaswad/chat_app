import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/auth_service.dart';
import '../services/user_profile_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final UserProfileService _userProfileService = UserProfileService();
  
  bool _isLoading = false;
  String? _errorMessage;
  User? _currentUser;
  
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  User? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;

  Future<bool> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _clearError();
    
    try {
      final user = await _authService.signInWithEmailAndPassword(
        email.trim(),
        password,
      );
      
      await _userProfileService.ensureUserProfileExists(user);
      await _userProfileService.setUserOnline();
      
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
    required String displayName,
  }) async {
    _setLoading(true);
    _clearError();
    
    try {
      final user = await _authService.createUserWithEmailAndPassword(
        email.trim(),
        password,
        displayName.trim(),
      );
      
      await _userProfileService.createUserProfile(user, displayName);
      
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
      await _userProfileService.setUserOffline();
      await _authService.signOut();
      _currentUser = null;
    } catch (e) {
      _handleGenericError(e);
    } finally {
      _setLoading(false);
    }
  }
  
  Future<bool> updateDisplayName(String displayName) async {
    _setLoading(true);
    _clearError();
    
    try {
      await _authService.updateUserDisplayName(displayName);
      await _userProfileService.updateUserDisplayName(displayName);
      _currentUser = _authService.currentUser;
      notifyListeners();
      _setLoading(false);
      return true;
    } catch (e) {
      _handleGenericError(e);
      return false;
    } finally {
      _setLoading(false);
    }
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
      case 'invalid-credential':
        message = 'Invalid credentials. Please check your email and password, or try registering first.';
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