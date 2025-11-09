import 'package:flutter/foundation.dart';
import '../models/auth_models.dart';
import '../services/auth_service.dart';

/// Authentication state management provider
class AuthProvider extends ChangeNotifier {
  final AuthService _authService;

  AuthUser? _currentUser;
  bool _isAuthenticated = false;
  bool _isLoading = false;
  AuthError? _error;

  AuthProvider({AuthService? authService})
      : _authService = authService ?? AuthService();

  // Getters
  AuthUser? get currentUser => _currentUser;
  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  AuthError? get error => _error;

  /// Initialize auth state (check if user is already logged in)
  Future<void> initializeAuth() async {
    _setLoading(true);
    _isAuthenticated = await _authService.isAuthenticated();

    if (_isAuthenticated) {
      await _loadCurrentUser();
    }

    _setLoading(false);
  }

  /// Login with email and password
  Future<AuthResult<AuthResponse>> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _clearError();

    final result = await _authService.loginWithEmailPassword(
      email: email,
      password: password,
    );

    if (result.isSuccess) {
      _isAuthenticated = true;
      await _loadCurrentUser();
    } else {
      _setError(result.error!);
    }

    _setLoading(false);
    return result;
  }

  /// Sign up with email and password
  Future<AuthResult<AuthResponse>> signupWithEmailPassword({
    required String email,
    required String password,
    required String username,
    required String name,
  }) async {
    _setLoading(true);
    _clearError();

    final result = await _authService.signupWithEmailPassword(
      email: email,
      password: password,
      username: username,
      name: name,
    );

    if (result.isSuccess) {
      _isAuthenticated = true;
      await _loadCurrentUser();
    } else {
      _setError(result.error!);
    }

    _setLoading(false);
    return result;
  }

  /// Login with Google
  Future<AuthResult<AuthResponse>> loginWithGoogle() async {
    return _loginWithSocialProvider(_authService.loginWithGoogle);
  }

  /// Login with Apple
  Future<AuthResult<AuthResponse>> loginWithApple() async {
    return _loginWithSocialProvider(_authService.loginWithApple);
  }

  /// Login with Facebook
  Future<AuthResult<AuthResponse>> loginWithFacebook() async {
    return _loginWithSocialProvider(_authService.loginWithFacebook);
  }

  /// Generic social provider login handler
  Future<AuthResult<AuthResponse>> _loginWithSocialProvider(
    Future<AuthResult<AuthResponse>> Function() loginFunction,
  ) async {
    _setLoading(true);
    _clearError();

    final result = await loginFunction();

    if (result.isSuccess) {
      _isAuthenticated = true;
      await _loadCurrentUser();
    } else {
      // Don't set error if user cancelled
      if (result.error?.code != 'cancelled') {
        _setError(result.error!);
      }
    }

    _setLoading(false);
    return result;
  }

  /// Logout
  Future<void> logout() async {
    _setLoading(true);
    _clearError();

    final result = await _authService.logout();

    if (result.isSuccess) {
      _isAuthenticated = false;
      _currentUser = null;
    } else {
      _setError(result.error!);
    }

    _setLoading(false);
  }

  /// Reset password (forgot password)
  Future<AuthResult<void>> resetPassword(String email) async {
    _setLoading(true);
    _clearError();

    final result = await _authService.resetPassword(email: email);

    if (!result.isSuccess) {
      _setError(result.error!);
    }

    _setLoading(false);
    return result;
  }

  /// Load current user information
  Future<void> _loadCurrentUser() async {
    final result = await _authService.getCurrentUser();

    if (result.isSuccess && result.data != null) {
      _currentUser = result.data;
      notifyListeners();
    }
  }

  /// Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// Set error
  void _setError(AuthError error) {
    _error = error;
    notifyListeners();
  }

  /// Clear error
  void clearError() {
    _clearError();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }

  /// Get user-friendly error message
  String? getUserFriendlyErrorMessage() {
    return _error?.getUserFriendlyMessage();
  }
}

