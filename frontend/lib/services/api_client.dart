import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import '../models/auth_models.dart';

/// API Client for communicating with the backend authentication API
class ApiClient {
  final String baseUrl;
  final http.Client _client;

  ApiClient({String? baseUrl, http.Client? client})
      : baseUrl = baseUrl ?? AppConfig.apiBaseUrl,
        _client = client ?? http.Client();

  /// Generic HTTP request handler with error handling
  Future<AuthResult<Map<String, dynamic>>> _makeRequest({
    required String method,
    required String endpoint,
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      final defaultHeaders = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

      if (headers != null) {
        defaultHeaders.addAll(headers);
      }

      http.Response response;

      switch (method.toUpperCase()) {
        case 'GET':
          response = await _client.get(url, headers: defaultHeaders);
          break;
        case 'POST':
          response = await _client.post(
            url,
            headers: defaultHeaders,
            body: body != null ? jsonEncode(body) : null,
          );
          break;
        case 'PUT':
          response = await _client.put(
            url,
            headers: defaultHeaders,
            body: body != null ? jsonEncode(body) : null,
          );
          break;
        case 'DELETE':
          response = await _client.delete(url, headers: defaultHeaders);
          break;
        default:
          return AuthResult.failure(
            AuthError(
              message: 'Unsupported HTTP method',
              code: 'invalid_method',
            ),
          );
      }

      return _handleResponse(response);
    } on SocketException {
      return AuthResult.failure(
        AuthError(
          message: 'No internet connection. Please check your network.',
          code: 'network_error',
        ),
      );
    } on HttpException {
      return AuthResult.failure(
        AuthError(
          message: 'Network error. Please try again.',
          code: 'network_error',
        ),
      );
    } on FormatException {
      return AuthResult.failure(
        AuthError(
          message: 'Invalid response format from server.',
          code: 'format_error',
        ),
      );
    } catch (e) {
      return AuthResult.failure(
        AuthError(
          message: 'An unexpected error occurred: ${e.toString()}',
          code: 'unknown_error',
        ),
      );
    }
  }

  /// Handle HTTP response and convert to AuthResult
  AuthResult<Map<String, dynamic>> _handleResponse(http.Response response) {
    try {
      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return AuthResult.success(data);
      } else {
        return AuthResult.failure(
          AuthError(
            message: data['message'] ?? data['error'] ?? 'Request failed',
            code: data['code'] ?? data['error'],
            statusCode: response.statusCode,
          ),
        );
      }
    } catch (e) {
      return AuthResult.failure(
        AuthError(
          message: 'Failed to parse server response',
          code: 'parse_error',
          statusCode: response.statusCode,
        ),
      );
    }
  }

  /// Make authenticated request with bearer token
  Future<AuthResult<Map<String, dynamic>>> makeAuthenticatedRequest({
    required String method,
    required String endpoint,
    required String accessToken,
    Map<String, dynamic>? body,
  }) async {
    return _makeRequest(
      method: method,
      endpoint: endpoint,
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
      body: body,
    );
  }

  /// Verify JWT token with backend
  Future<AuthResult<Map<String, dynamic>>> verifyToken(String accessToken) async {
    return makeAuthenticatedRequest(
      method: 'GET',
      endpoint: AppConfig.protectedEndpoint,
      accessToken: accessToken,
    );
  }

  /// Get user information from backend
  Future<AuthResult<AuthUser>> getUserInfo(String accessToken) async {
    final result = await makeAuthenticatedRequest(
      method: 'GET',
      endpoint: AppConfig.userEndpoint,
      accessToken: accessToken,
    );

    if (result.isSuccess && result.data != null) {
      try {
        final userData = result.data!['user'] ?? result.data;
        final user = AuthUser.fromJson(userData);
        return AuthResult.success(user);
      } catch (e) {
        return AuthResult.failure(
          AuthError(
            message: 'Failed to parse user information',
            code: 'parse_error',
          ),
        );
      }
    } else {
      return AuthResult.failure(result.error!);
    }
  }

  /// Test connection to backend
  Future<bool> testConnection() async {
    try {
      final result = await _makeRequest(
        method: 'GET',
        endpoint: '/',
      );
      return result.isSuccess;
    } catch (e) {
      return false;
    }
  }

  /// Dispose resources
  void dispose() {
    _client.close();
  }
}

