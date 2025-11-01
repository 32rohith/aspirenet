/// Application configuration for API endpoints and Auth0 settings
class AppConfig {
  // Backend API Configuration
  static const String apiBaseUrl = 'http://localhost:3000'; // Change this to your backend URL
  
  // Auth0 Configuration
  // TODO: Replace these with your actual Auth0 credentials
  static const String auth0Domain = 'dev-bt6psmdagwduake7.us.auth0.com'; // e.g., 'dev-xxxxx.us.auth0.com'
  static const String auth0ClientId = 'yMEPXUr5NCQxRuLvP2fjJfeKQ8PgjYQY';
  static const String auth0Audience = 'https://aspirenet-api'; // Optional, use if you have a custom API
  
  // Auth0 connection names for social logins
  static const String googleConnection = 'google-oauth2';
  static const String appleConnection = 'apple';
  static const String facebookConnection = 'facebook';
  
  // API Endpoints
  static const String loginEndpoint = '/auth/login';
  static const String signupEndpoint = '/auth/signup';
  static const String protectedEndpoint = '/protected';
  static const String userEndpoint = '/user';
  
  // Token storage keys
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userIdKey = 'user_id';
  static const String userEmailKey = 'user_email';
}

