import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/app_config.dart';
import '../models/auth_models.dart';
import 'api_client.dart';

/// Authentication Service with Auth0 integration
class AuthService {
  late final Auth0 _auth0;
  final FlutterSecureStorage _secureStorage;
  final ApiClient _apiClient;

  AuthService({
    FlutterSecureStorage? secureStorage,
    ApiClient? apiClient,
  })  : _secureStorage = secureStorage ?? const FlutterSecureStorage(),
        _apiClient = apiClient ?? ApiClient() {
    _auth0 = Auth0(AppConfig.auth0Domain, AppConfig.auth0ClientId);
  }

  /// Login with email and password using Auth0
  Future<AuthResult<AuthResponse>> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      // Validate input
      final validationError = _validateEmailPassword(email, password);
      if (validationError != null) {
        return AuthResult.failure(validationError);
      }

      // Authenticate with Auth0
      final credentials = await _auth0.api.login(
        usernameOrEmail: email,
        password: password,
        connectionOrRealm: 'Username-Password-Authentication',
      );

      // Store tokens and create auth response
      final authResponse = await _handleSuccessfulAuth(credentials);
      return AuthResult.success(authResponse);
    } on ApiException catch (e) {
      return AuthResult.failure(
        _handleAuth0Error(e),
      );
    } catch (e) {
      return AuthResult.failure(
        AuthError(
          message: 'Login failed. Please try again.',
          code: 'login_error',
        ),
      );
    }
  }

  /// Sign up with email and password using Auth0
  Future<AuthResult<AuthResponse>> signupWithEmailPassword({
    required String email,
    required String password,
    required String username,
    required String name,
  }) async {
    try {
      // Validate input
      final validationError = _validateSignup(email, password, username, name);
      if (validationError != null) {
        return AuthResult.failure(validationError);
      }

      // Sign up with Auth0
      await _auth0.api.signup(
        email: email,
        password: password,
        connection: 'Username-Password-Authentication',
        userMetadata: {
          'username': username,
          'name': name,
        },
      );

      // After signup, log the user in to get credentials
      final credentials = await _auth0.api.login(
        usernameOrEmail: email,
        password: password,
        connectionOrRealm: 'Username-Password-Authentication',
      );

      // Store tokens and create auth response
      final authResponse = await _handleSuccessfulAuth(credentials);
      return AuthResult.success(authResponse);
    } on ApiException catch (e) {
      return AuthResult.failure(
        _handleAuth0Error(e),
      );
    } catch (e) {
      return AuthResult.failure(
        AuthError(
          message: 'Sign up failed. Please try again.',
          code: 'signup_error',
        ),
      );
    }
  }

  /// Login with Google using Auth0
  Future<AuthResult<AuthResponse>> loginWithGoogle() async {
    return _loginWithSocialProvider(AppConfig.googleConnection);
  }

  /// Login with Apple using Auth0
  Future<AuthResult<AuthResponse>> loginWithApple() async {
    return _loginWithSocialProvider(AppConfig.appleConnection);
  }

  /// Login with Facebook using Auth0
  Future<AuthResult<AuthResponse>> loginWithFacebook() async {
    return _loginWithSocialProvider(AppConfig.facebookConnection);
  }

  /// Generic social provider login
  Future<AuthResult<AuthResponse>> _loginWithSocialProvider(
    String connection,
  ) async {
    try {
      final credentials = await _auth0.webAuthentication().login(
            parameters: {
              'connection': connection,
            },
          );

      final authResponse = await _handleSuccessfulAuth(credentials);
      return AuthResult.success(authResponse);
    } on WebAuthenticationException catch (e) {
      if (e.code == 'a0.session.user_cancelled') {
        return AuthResult.failure(
          AuthError(
            message: 'Login cancelled by user.',
            code: 'cancelled',
          ),
        );
      }
      return AuthResult.failure(
        AuthError(
          message: 'Social login failed. Please try again.',
          code: 'social_login_error',
        ),
      );
    } catch (e) {
      return AuthResult.failure(
        AuthError(
          message: 'Social login failed. Please try again.',
          code: 'social_login_error',
        ),
      );
    }
  }

  /// Handle successful authentication and store tokens
  Future<AuthResponse> _handleSuccessfulAuth(Credentials credentials) async {
    // Store tokens securely
    await _secureStorage.write(
      key: AppConfig.accessTokenKey,
      value: credentials.accessToken,
    );

    if (credentials.refreshToken != null) {
      await _secureStorage.write(
        key: AppConfig.refreshTokenKey,
        value: credentials.refreshToken,
      );
    }

    // Extract user info from ID token or user info
    final userId = credentials.user.sub;
    final email = credentials.user.email ?? '';
    final name = credentials.user.name;

    await _secureStorage.write(key: AppConfig.userIdKey, value: userId);
    await _secureStorage.write(key: AppConfig.userEmailKey, value: email);

    // Create auth response
    return AuthResponse(
      accessToken: credentials.accessToken,
      refreshToken: credentials.refreshToken,
      userId: userId,
      email: email,
      name: name,
      expiresAt: credentials.expiresAt,
    );
  }

  /// Logout user
  Future<AuthResult<void>> logout() async {
    try {
      // Logout from Auth0
      await _auth0.webAuthentication().logout();

      // Clear stored tokens
      await _secureStorage.delete(key: AppConfig.accessTokenKey);
      await _secureStorage.delete(key: AppConfig.refreshTokenKey);
      await _secureStorage.delete(key: AppConfig.userIdKey);
      await _secureStorage.delete(key: AppConfig.userEmailKey);

      return AuthResult.success(null);
    } catch (e) {
      return AuthResult.failure(
        AuthError(
          message: 'Logout failed. Please try again.',
          code: 'logout_error',
        ),
      );
    }
  }

  /// Check if user is authenticated
  Future<bool> isAuthenticated() async {
    final accessToken = await _secureStorage.read(key: AppConfig.accessTokenKey);
    if (accessToken == null || accessToken.isEmpty) {
      return false;
    }

    // Verify token with backend
    final result = await _apiClient.verifyToken(accessToken);
    return result.isSuccess;
  }

  /// Get stored access token
  Future<String?> getAccessToken() async {
    return await _secureStorage.read(key: AppConfig.accessTokenKey);
  }

  /// Get current user information
  Future<AuthResult<AuthUser>> getCurrentUser() async {
    final accessToken = await getAccessToken();
    if (accessToken == null) {
      return AuthResult.failure(
        AuthError(
          message: 'No authenticated user found.',
          code: 'not_authenticated',
        ),
      );
    }

    return await _apiClient.getUserInfo(accessToken);
  }

  /// Reset password (forgot password)
  Future<AuthResult<void>> resetPassword(String email) async {
    try {
      final validationError = _validateEmail(email);
      if (validationError != null) {
        return AuthResult.failure(validationError);
      }

      await _auth0.api.resetPassword(
        email: email,
        connection: 'Username-Password-Authentication',
      );

      return AuthResult.success(null);
    } on ApiException catch (e) {
      return AuthResult.failure(
        _handleAuth0Error(e),
      );
    } catch (e) {
      return AuthResult.failure(
        AuthError(
          message: 'Password reset failed. Please try again.',
          code: 'reset_password_error',
        ),
      );
    }
  }

  /// Validate email format
  AuthError? _validateEmail(String email) {
    if (email.isEmpty) {
      return AuthError(
        message: 'Email cannot be empty.',
        code: 'invalid_email',
      );
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(email)) {
      return AuthError(
        message: 'Please enter a valid email address.',
        code: 'invalid_email',
      );
    }

    return null;
  }

  /// Validate email and password
  AuthError? _validateEmailPassword(String email, String password) {
    final emailError = _validateEmail(email);
    if (emailError != null) {
      return emailError;
    }

    if (password.isEmpty) {
      return AuthError(
        message: 'Password cannot be empty.',
        code: 'invalid_password',
      );
    }

    return null;
  }

  /// Validate signup information
  AuthError? _validateSignup(
    String email,
    String password,
    String username,
    String name,
  ) {
    final emailPasswordError = _validateEmailPassword(email, password);
    if (emailPasswordError != null) {
      return emailPasswordError;
    }

    if (username.isEmpty) {
      return AuthError(
        message: 'Username cannot be empty.',
        code: 'invalid_username',
      );
    }

    if (username.length < 3) {
      return AuthError(
        message: 'Username must be at least 3 characters long.',
        code: 'invalid_username',
      );
    }

    if (name.isEmpty) {
      return AuthError(
        message: 'Name cannot be empty.',
        code: 'invalid_name',
      );
    }

    if (password.length < 8) {
      return AuthError(
        message: 'Password must be at least 8 characters long.',
        code: 'password_too_weak',
      );
    }

    return null;
  }

  /// Handle Auth0 API exceptions
  AuthError _handleAuth0Error(ApiException exception) {
    final message = exception.message;
    final code = exception.statusCode.toString();

    // Map common Auth0 errors to user-friendly messages
    if (message.toLowerCase().contains('invalid') ||
        message.toLowerCase().contains('credentials')) {
      return AuthError(
        message: 'Invalid credentials. Please check your email and password.',
        code: 'invalid_credentials',
        statusCode: exception.statusCode,
      );
    } else if (message.toLowerCase().contains('exist')) {
      return AuthError(
        message: 'An account with this email already exists.',
        code: 'user_exists',
        statusCode: exception.statusCode,
      );
    } else if (message.toLowerCase().contains('password')) {
      return AuthError(
        message: 'Password does not meet requirements. Use at least 8 characters.',
        code: 'password_too_weak',
        statusCode: exception.statusCode,
      );
    } else if (message.toLowerCase().contains('network')) {
      return AuthError(
        message: 'Network error. Please check your connection.',
        code: 'network_error',
        statusCode: exception.statusCode,
      );
    }

    return AuthError(
      message: message,
      code: code,
      statusCode: exception.statusCode,
    );
  }
}

