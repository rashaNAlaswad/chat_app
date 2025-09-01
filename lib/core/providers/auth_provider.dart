import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/auth_service.dart';
import '../services/user_profile_service.dart';

enum AuthState { initial, loading, authenticated, unauthenticated, error }

class AuthProvider extends ChangeNotifier {
  final AuthService _authService;
  final UserProfileService _userProfileService;

  AuthProvider(this._authService, this._userProfileService) {
    _initializeAuthState();
  }

  AuthState _authState = AuthState.initial;
  String? _errorMessage;
  User? _currentUser;
  bool _isLoading = false;

  AuthState get authState => _authState;
  String? get errorMessage => _errorMessage;
  User? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isLoading => _isLoading;

  void _initializeAuthState() {
    _authService.authStateChanges.listen(
      (User? user) {
        _currentUser = user;
        _authState =
            user != null ? AuthState.authenticated : AuthState.unauthenticated;
        notifyListeners();
      },
      onError: (error) {
        _authState = AuthState.error;
        _errorMessage = 'Authentication state error: $error';
        notifyListeners();
      },
    );
  }

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
      _authState = AuthState.authenticated;
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
      _authState = AuthState.authenticated;
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
      _authState = AuthState.unauthenticated;
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

      return true;
    } catch (e) {
      _handleGenericError(e);
      return false;
    } finally {
      _setLoading(false);
    }
  }

  void reset() {
    _authState = AuthState.initial;
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    _authState = loading ? AuthState.loading : _authState;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    if (_authState == AuthState.error) {
      _authState =
          _currentUser != null
              ? AuthState.authenticated
              : AuthState.unauthenticated;
    }
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    _authState = AuthState.error;
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
        message =
            'Invalid credentials. Please check your email and password, or try registering first.';
        break;
      case 'user-token-expired':
        message = 'Your session has expired. Please sign in again.';
        break;
      case 'requires-recent-login':
        message =
            'This operation requires recent authentication. Please sign in again.';
        break;
      default:
        message = 'Authentication failed: ${e.message ?? 'Unknown error'}.';
    }

    _setError(message);
  }

  void _handleGenericError(dynamic error) {
    final errorMessage = error is String ? error : error.toString();
    _setError('An unexpected error occurred: $errorMessage');
  }
}
