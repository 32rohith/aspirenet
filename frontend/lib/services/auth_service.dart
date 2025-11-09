import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/app_config.dart';
import '../models/auth_models.dart';

/// Authentication Service with Auth0 integration
/// Uses Universal Login - the ONLY officially supported method for mobile apps
class AuthService {
  late final Auth0 _auth0;
  final FlutterSecureStorage _secureStorage;

  AuthService({
    FlutterSecureStorage? secureStorage,
  })  : _secureStorage = secureStorage ?? const FlutterSecureStorage() {
    _auth0 = Auth0(AppConfig.auth0Domain, AppConfig.auth0ClientId);
  }

  /// Login with email and password using Auth0 Universal Login
  /// Opens Auth0's secure login page (required for mobile apps per Auth0 docs)
  Future<AuthResult<AuthResponse>> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      print('============ Auth0 Universal Login ============');
      print('Domain: ${AppConfig.auth0Domain}');
      print('Client ID: ${AppConfig.auth0ClientId}');
      print('Pre-filling email: $email');
      print('Using Universal Login (Auth0 required method for mobile)');
      print('================================================');
      
      // Universal Login - Auth0's ONLY supported method for mobile apps
      // This opens a secure browser view with Auth0's login page
      final credentials = await _auth0
          .webAuthentication(scheme: 'https')
          .login(
            parameters: {
              'login_hint': email, // Pre-fills the email field
            },
            audience: AppConfig.auth0Audience,
            scopes: {'openid', 'profile', 'email', 'offline_access'},
          );

      print('✅ Login successful!');
      print('User ID: ${credentials.user.sub}');
      print('Access Token received: ${credentials.accessToken.substring(0, 20)}...');
      
      // Store tokens and create auth response
      final authResponse = await _handleSuccessfulAuth(credentials);
      return AuthResult.success(authResponse);
    } on WebAuthenticationException catch (e) {
      print('============ Auth0 Login Error ============');
      print('Message: ${e.message}');
      print('Code: ${e.code}');
      print('Details: ${e.details}');
      print('==========================================');
      
      return AuthResult.failure(_handleWebAuthError(e));
    } catch (e, stackTrace) {
      print('Login Error: $e');
      print('Stack Trace: $stackTrace');
      return AuthResult.failure(
        AuthError(
          message: 'Login failed. Please try again.',
          code: 'login_error',
        ),
      );
    }
  }

  /// Sign up with email and password using Auth0 Universal Login
  /// Opens Auth0's secure signup page (required for mobile apps per Auth0 docs)
  Future<AuthResult<AuthResponse>> signupWithEmailPassword({
    required String email,
    required String password,
    required String username,
    required String name,
  }) async {
    try {
      print('============ Auth0 Universal Signup ============');
      print('Domain: ${AppConfig.auth0Domain}');
      print('Client ID: ${AppConfig.auth0ClientId}');
      print('Pre-filling email: $email');
      print('Using Universal Login with signup screen');
      print('===============================================');
      
      // Universal Login with signup screen - Auth0's ONLY supported method
      // This opens a secure browser view with Auth0's signup page
      final credentials = await _auth0
          .webAuthentication(scheme: 'https')
          .login(
            parameters: {
              'screen_hint': 'signup', // Shows signup form instead of login
              'login_hint': email, // Pre-fills the email field
            },
            audience: AppConfig.auth0Audience,
            scopes: {'openid', 'profile', 'email', 'offline_access'},
          );

      print('✅ Signup successful!');
      print('User ID: ${credentials.user.sub}');
      
      // Store tokens and create auth response
      final authResponse = await _handleSuccessfulAuth(credentials);
      return AuthResult.success(authResponse);
    } on WebAuthenticationException catch (e) {
      print('============ Auth0 Signup Error ============');
      print('Message: ${e.message}');
      print('Code: ${e.code}');
      print('Details: ${e.details}');
      print('==========================================');
      
      return AuthResult.failure(_handleWebAuthError(e));
    } catch (e, stackTrace) {
      print('Signup Error: $e');
      print('Stack Trace: $stackTrace');
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
    print('============ Auth0 Google Login ============');
    print('Provider: google-oauth2');
    print('===========================================');
    return _loginWithSocialProvider(AppConfig.googleConnection);
  }

  /// Login with Apple using Auth0
  Future<AuthResult<AuthResponse>> loginWithApple() async {
    print('============ Auth0 Apple Login ============');
    print('Provider: apple');
    print('==========================================');
    return _loginWithSocialProvider(AppConfig.appleConnection);
  }

  /// Login with Facebook using Auth0
  Future<AuthResult<AuthResponse>> loginWithFacebook() async {
    print('============ Auth0 Facebook Login ============');
    print('Provider: facebook');
    print('=============================================');
    return _loginWithSocialProvider(AppConfig.facebookConnection);
  }

  /// Generic social provider login using Universal Login
  Future<AuthResult<AuthResponse>> _loginWithSocialProvider(
    String connection,
  ) async {
    try {
      final credentials = await _auth0
          .webAuthentication(scheme: 'https')
          .login(
            parameters: {
              'connection': connection,
            },
            audience: AppConfig.auth0Audience,
            scopes: {'openid', 'profile', 'email', 'offline_access'},
          );

      print('✅ Social login successful!');
      print('User ID: ${credentials.user.sub}');
      
      final authResponse = await _handleSuccessfulAuth(credentials);
      return AuthResult.success(authResponse);
    } on WebAuthenticationException catch (e) {
      print('Auth0 Social Login Error: ${e.message}');
      print('Auth0 Error Code: ${e.code}');
      
      return AuthResult.failure(_handleWebAuthError(e));
    } catch (e) {
      print('Social Login Error: $e');
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
      key: 'auth0_access_token',
      value: credentials.accessToken,
    );

    await _secureStorage.write(
      key: 'auth0_refresh_token',
      value: credentials.refreshToken,
    );

    await _secureStorage.write(
      key: 'auth0_id_token',
      value: credentials.idToken,
    );

    // Store user info
    await _secureStorage.write(
      key: 'auth0_user_id',
      value: credentials.user.sub,
    );

    // Store user email
    await _secureStorage.write(
      key: 'auth0_user_email',
      value: credentials.user.email ?? '',
    );

    // Store user name
    await _secureStorage.write(
      key: 'auth0_user_name',
      value: credentials.user.name ?? '',
    );

    // Create AuthResponse from credentials
    return AuthResponse(
      accessToken: credentials.accessToken,
      refreshToken: credentials.refreshToken,
      userId: credentials.user.sub,
      email: credentials.user.email ?? '',
      name: credentials.user.name,
      expiresAt: credentials.expiresAt,
    );
  }

  /// Handle WebAuthenticationException errors
  AuthError _handleWebAuthError(WebAuthenticationException exception) {
    final message = exception.message.toLowerCase();
    final code = exception.code;

    // User cancelled authentication
    if (code == 'a0.session.user_cancelled' || 
        code == 'user_cancelled' ||
        message.contains('cancel')) {
      return AuthError(
        message: 'Login cancelled.',
        code: 'cancelled',
      );
    }

    // Network errors
    if (message.contains('network') || 
        message.contains('connection') ||
        message.contains('timeout')) {
      return AuthError(
        message: 'Network error. Please check your internet connection.',
        code: 'network_error',
      );
    }

    // Configuration errors
    if (message.contains('not found') || 
        message.contains('callback') ||
        message.contains('redirect')) {
      return AuthError(
        message: 'Authentication configuration error.\n\n'
                'Please check:\n'
                '1. Callback URLs are configured in Auth0\n'
                '2. Application is properly set up\n\n'
                'See AUTH0_SETUP_COMPLETE.md for details.',
        code: 'config_error',
      );
    }

    // Invalid credentials
    if (message.contains('invalid') || 
        message.contains('unauthorized') ||
        message.contains('wrong')) {
      return AuthError(
        message: 'Invalid credentials. Please try again.',
        code: 'invalid_credentials',
      );
    }

    // Access denied
    if (message.contains('access') && message.contains('denied')) {
      return AuthError(
        message: 'Access denied. Please check your permissions.',
        code: 'access_denied',
      );
    }

    // Default error
    return AuthError(
      message: exception.message,
      code: code,
    );
  }

  /// Logout from Auth0 and clear local tokens
  Future<AuthResult<void>> logout() async {
    try {
      print('============ Auth0 Logout ============');
      
      // Logout from Auth0
      await _auth0.webAuthentication(scheme: 'https').logout();

      // Clear stored tokens and user info
      await _secureStorage.delete(key: 'auth0_access_token');
      await _secureStorage.delete(key: 'auth0_refresh_token');
      await _secureStorage.delete(key: 'auth0_id_token');
      await _secureStorage.delete(key: 'auth0_user_id');
      await _secureStorage.delete(key: 'auth0_user_email');
      await _secureStorage.delete(key: 'auth0_user_name');

      print('✅ Logout successful!');
      return AuthResult.success(null);
    } on WebAuthenticationException catch (e) {
      print('Logout Error: ${e.message}');
      
      // Even if web logout fails, clear local tokens
      await _secureStorage.deleteAll();
      
      return AuthResult.failure(
        AuthError(
          message: 'Logout completed with warnings.',
          code: 'logout_warning',
        ),
      );
    } catch (e) {
      print('Logout Error: $e');
      
      // Clear local tokens anyway
      await _secureStorage.deleteAll();
      
      return AuthResult.failure(
        AuthError(
          message: 'Logout failed but local session cleared.',
          code: 'logout_error',
        ),
      );
    }
  }

  /// Check if user is authenticated
  Future<bool> isAuthenticated() async {
    final accessToken = await _secureStorage.read(key: 'auth0_access_token');
    return accessToken != null && accessToken.isNotEmpty;
  }

  /// Get stored access token
  Future<String?> getAccessToken() async {
    return await _secureStorage.read(key: 'auth0_access_token');
  }

  /// Get stored user ID
  Future<String?> getUserId() async {
    return await _secureStorage.read(key: 'auth0_user_id');
  }

  /// Get current user information from stored tokens
  Future<AuthResult<AuthUser>> getCurrentUser() async {
    try {
      final userId = await getUserId();
      final email = await _secureStorage.read(key: 'auth0_user_email');
      final name = await _secureStorage.read(key: 'auth0_user_name');

      if (userId == null || email == null) {
        return AuthResult.failure(
          AuthError(
            message: 'Not authenticated',
            code: 'not_authenticated',
          ),
        );
      }

      final user = AuthUser(
        id: userId,
        email: email,
        name: name,
      );

      return AuthResult.success(user);
    } catch (e) {
      print('Get User Error: $e');
      return AuthResult.failure(
        AuthError(
          message: 'Failed to get user information.',
          code: 'get_user_error',
        ),
      );
    }
  }

  /// Refresh access token using refresh token
  Future<AuthResult<String>> refreshAccessToken() async {
    try {
      final refreshToken = await _secureStorage.read(key: 'auth0_refresh_token');
      
      if (refreshToken == null) {
        return AuthResult.failure(
          AuthError(
            message: 'No refresh token available.',
            code: 'no_refresh_token',
          ),
        );
      }

      // Renew credentials using refresh token
      final credentials = await _auth0.api.renewCredentials(
        refreshToken: refreshToken,
      );

      // Store new tokens
      await _secureStorage.write(
        key: 'auth0_access_token',
        value: credentials.accessToken,
      );

      await _secureStorage.write(
        key: 'auth0_id_token',
        value: credentials.idToken,
      );

      print('✅ Token refreshed successfully!');
      return AuthResult.success(credentials.accessToken);
    } catch (e) {
      print('Refresh Token Error: $e');
      return AuthResult.failure(
        AuthError(
          message: 'Failed to refresh token. Please log in again.',
          code: 'refresh_error',
        ),
      );
    }
  }

  /// Reset password using Auth0
  Future<AuthResult<void>> resetPassword({required String email}) async {
    try {
      print('============ Auth0 Password Reset ============');
      print('Email: $email');
      print('Connection: Username-Password-Authentication');
      print('==============================================');

      await _auth0.api.resetPassword(
        email: email,
        connection: 'Username-Password-Authentication',
      );

      print('✅ Password reset email sent!');
      return AuthResult.success(null);
    } on ApiException catch (e) {
      print('Password Reset Error: ${e.message}');
      
      final errorMsg = e.message.toLowerCase();
      
      if (errorMsg.contains('not found') || errorMsg.contains('user')) {
        return AuthResult.failure(
          AuthError(
            message: 'No account found with this email address.',
            code: 'user_not_found',
          ),
        );
      }
      
      return AuthResult.failure(
        AuthError(
          message: e.message,
          code: 'reset_error',
          statusCode: e.statusCode,
        ),
      );
    } catch (e) {
      print('Password Reset Error: $e');
      return AuthResult.failure(
        AuthError(
          message: 'Failed to send password reset email.',
          code: 'reset_error',
        ),
      );
    }
  }
}
