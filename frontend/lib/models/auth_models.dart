/// Authentication Request Models

/// Request model for email/password login
class LoginRequest {
  final String email;
  final String password;

  LoginRequest({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}

/// Request model for user signup
class SignupRequest {
  final String username;
  final String name;
  final String email;
  final String password;

  SignupRequest({
    required this.username,
    required this.name,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'name': name,
      'email': email,
      'password': password,
    };
  }
}

/// Authentication Response Models

/// Response model for successful authentication
class AuthResponse {
  final String accessToken;
  final String? refreshToken;
  final String userId;
  final String email;
  final String? name;
  final DateTime expiresAt;

  AuthResponse({
    required this.accessToken,
    this.refreshToken,
    required this.userId,
    required this.email,
    this.name,
    required this.expiresAt,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      accessToken: json['access_token'] ?? json['accessToken'] ?? '',
      refreshToken: json['refresh_token'] ?? json['refreshToken'],
      userId: json['user_id'] ?? json['userId'] ?? json['sub'] ?? '',
      email: json['email'] ?? '',
      name: json['name'],
      expiresAt: json['expires_at'] != null
          ? DateTime.parse(json['expires_at'])
          : DateTime.now().add(const Duration(hours: 24)),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'user_id': userId,
      'email': email,
      'name': name,
      'expires_at': expiresAt.toIso8601String(),
    };
  }
}

/// User information model
class AuthUser {
  final String id;
  final String email;
  final String? name;
  final String? username;
  final String? picture;

  AuthUser({
    required this.id,
    required this.email,
    this.name,
    this.username,
    this.picture,
  });

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      id: json['sub'] ?? json['user_id'] ?? json['id'] ?? '',
      email: json['email'] ?? '',
      name: json['name'],
      username: json['username'] ?? json['nickname'],
      picture: json['picture'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'username': username,
      'picture': picture,
    };
  }
}

/// Error response model
class AuthError {
  final String message;
  final String? code;
  final int? statusCode;

  AuthError({
    required this.message,
    this.code,
    this.statusCode,
  });

  factory AuthError.fromJson(Map<String, dynamic> json) {
    return AuthError(
      message: json['message'] ?? json['error_description'] ?? 'An error occurred',
      code: json['code'] ?? json['error'],
      statusCode: json['statusCode'] ?? json['status_code'],
    );
  }

  /// Converts technical error messages to user-friendly messages
  String getUserFriendlyMessage() {
    if (code != null) {
      switch (code) {
        case 'invalid_grant':
        case 'invalid_credentials':
          return 'Invalid email or password. Please check your credentials and try again.';
        case 'unauthorized':
          return 'You are not authorized to perform this action.';
        case 'access_denied':
          return 'Access denied. Please try again.';
        case 'user_exists':
          return 'An account with this email already exists. Please login instead.';
        case 'invalid_signup':
          return 'Unable to create account. Please check your information and try again.';
        case 'network_error':
          return 'Network connection error. Please check your internet connection.';
        case 'server_error':
          return 'Server error. Please try again later.';
        case 'too_many_attempts':
          return 'Too many login attempts. Please try again after some time.';
        case 'password_too_weak':
          return 'Password is too weak. Please use a stronger password with at least 8 characters.';
        case 'invalid_email':
          return 'Please enter a valid email address.';
        default:
          return message;
      }
    }

    // Check status codes
    if (statusCode != null) {
      switch (statusCode) {
        case 400:
          return 'Invalid request. Please check your information.';
        case 401:
          return 'Invalid credentials. Please try again.';
        case 403:
          return 'Access forbidden. You do not have permission.';
        case 404:
          return 'Service not found. Please try again later.';
        case 409:
          return 'Account already exists with this email.';
        case 429:
          return 'Too many requests. Please wait a moment and try again.';
        case 500:
        case 502:
        case 503:
          return 'Server error. Please try again later.';
        default:
          return message;
      }
    }

    return message;
  }
}

/// Authentication result wrapper
class AuthResult<T> {
  final T? data;
  final AuthError? error;
  final bool isSuccess;

  AuthResult.success(this.data)
      : error = null,
        isSuccess = true;

  AuthResult.failure(this.error)
      : data = null,
        isSuccess = false;
}

