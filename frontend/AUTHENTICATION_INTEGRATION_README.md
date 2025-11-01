`# Authentication Integration Guide

This document explains the Auth0 authentication integration in the AspireNet Flutter application.

## Overview

The authentication system uses **Auth0** for secure user authentication with support for:
- Email/password login and signup
- Social logins (Google, Apple, Facebook)
- Password reset functionality
- JWT token management
- Secure token storage

## Architecture

### Components

1. **AuthService** (`lib/services/auth_service.dart`)
   - Handles all Auth0 authentication operations
   - Manages social provider logins
   - Validates user input
   - Handles password reset

2. **ApiClient** (`lib/services/api_client.dart`)
   - Communicates with backend authentication API
   - Verifies JWT tokens
   - Handles HTTP requests with proper error handling

3. **AuthProvider** (`lib/providers/auth_provider.dart`)
   - Global state management for authentication
   - Provides authentication status to the entire app
   - Manages user session

4. **Auth Models** (`lib/models/auth_models.dart`)
   - Request/response models
   - User-friendly error message mapping
   - Type-safe authentication data structures

## Setup Instructions

### 1. Configure Auth0

1. Create an Auth0 account at [auth0.com](https://auth0.com)
2. Create a new application (Native/Mobile)
3. Enable the following connections in your Auth0 dashboard:
   - Username-Password-Authentication
   - Google OAuth2
   - Apple
   - Facebook

4. Note down your credentials:
   - Domain (e.g., `dev-xxxxx.us.auth0.com`)
   - Client ID
   - Audience (if using a custom API)

### 2. Update Configuration

Edit `lib/config/app_config.dart` with your Auth0 credentials:

```dart
class AppConfig {
  // Backend API Configuration
  static const String apiBaseUrl = 'http://YOUR_BACKEND_URL:3000';
  
  // Auth0 Configuration
  static const String auth0Domain = 'YOUR_AUTH0_DOMAIN';
  static const String auth0ClientId = 'YOUR_AUTH0_CLIENT_ID';
  static const String auth0Audience = 'YOUR_AUTH0_AUDIENCE'; // Optional
  
  // ... rest of config
}
```

### 3. Backend Configuration

Ensure your backend authentication API has a `.env` file with:

```env
PORT=3000
AUTH0_DOMAIN=https://YOUR_AUTH0_DOMAIN
AUTH0_AUDIENCE=YOUR_AUTH0_AUDIENCE
```

### 4. Install Flutter Dependencies

Run the following command in the `frontend` directory:

```bash
flutter pub get
```

### 5. Platform-Specific Setup

#### Android Setup

Add to `android/app/src/main/AndroidManifest.xml`:

```xml
<manifest ...>
  <application ...>
    <activity
      android:name="com.auth0.android.provider.RedirectActivity"
      android:exported="true">
      <intent-filter>
        <action android:name="android.intent.action.VIEW" />
        <category android:name="android.intent.category.DEFAULT" />
        <category android:name="android.intent.category.BROWSABLE" />
        <data
          android:scheme="https"
          android:host="YOUR_AUTH0_DOMAIN"
          android:pathPrefix="/android/YOUR_PACKAGE_NAME/callback" />
      </intent-filter>
    </activity>
  </application>
</manifest>
```

#### iOS Setup

Add to `ios/Runner/Info.plist`:

```xml
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleTypeRole</key>
    <string>Editor</string>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>YOUR_AUTH0_CLIENT_ID</string>
    </array>
  </dict>
</array>
```

## Authentication Flow

### Login Flow

1. User enters email and password
2. `LoginScreen` calls `AuthProvider.loginWithEmailPassword()`
3. `AuthProvider` calls `AuthService.loginWithEmailPassword()`
4. `AuthService` authenticates with Auth0
5. On success:
   - Access token is stored securely
   - User is redirected to HomeScreen
   - Success message is shown
6. On failure:
   - User-friendly error message is displayed
   - User can retry

### Signup Flow

1. User enters username, name, email, password, and confirms password
2. Form validation checks:
   - All fields are filled
   - Email is valid format
   - Password meets minimum requirements (8+ characters)
   - Passwords match
   - Terms and conditions are accepted
3. `SignUpScreen` calls `AuthProvider.signupWithEmailPassword()`
4. `AuthProvider` calls `AuthService.signupWithEmailPassword()`
5. `AuthService` creates account with Auth0
6. On success:
   - Account is created
   - User is automatically logged in
   - Redirected to onboarding
7. On failure:
   - User-friendly error message is displayed

### Social Login Flow

1. User clicks on social login button (Google/Apple/Facebook)
2. `LoginScreen` calls appropriate method (e.g., `AuthProvider.loginWithGoogle()`)
3. Auth0 web authentication opens in browser/system dialog
4. User authenticates with social provider
5. On success:
   - Access token is stored
   - User is redirected to HomeScreen
6. On cancellation or failure:
   - Appropriate message is shown

## Error Handling

The system provides user-friendly error messages for common scenarios:

- **Invalid credentials**: "Invalid email or password. Please check your credentials and try again."
- **User already exists**: "An account with this email already exists. Please login instead."
- **Weak password**: "Password is too weak. Please use a stronger password with at least 8 characters."
- **Network error**: "Network connection error. Please check your internet connection."
- **Server error**: "Server error. Please try again later."

All technical errors are mapped to user-friendly messages in `AuthError.getUserFriendlyMessage()`.

## Security Features

1. **Secure Storage**: Tokens are stored using `flutter_secure_storage`
2. **JWT Verification**: Backend verifies tokens with Auth0
3. **HTTPS Only**: All communication uses HTTPS
4. **Token Expiration**: Tokens are checked for expiration
5. **Input Validation**: All user input is validated before submission

## Backend Middleware

The backend uses the existing JWT middleware (`JWTcheck`) to protect routes:

```typescript
import { JWTcheck } from "./middleware/JWTcheck.js";

app.get("/protected", JWTcheck, (req, res) => {
  // Only authenticated users can access this route
  res.json({ message: "Authenticated!" });
});
```

## Testing the Integration

### 1. Start Backend Server

```bash
cd backend/authentication-api
npm install
npm run dev
```

Backend should run on `http://localhost:3000`

### 2. Run Flutter App

```bash
cd frontend
flutter pub get
flutter run
```

### 3. Test Scenarios

1. **Sign Up**:
   - Create a new account
   - Verify validation works
   - Check onboarding navigation

2. **Login**:
   - Login with created account
   - Verify token is stored
   - Check navigation to home screen

3. **Forgot Password**:
   - Enter email
   - Check Auth0 email is received

4. **Social Login** (if configured):
   - Test Google/Apple/Facebook login
   - Verify account creation

## Troubleshooting

### Common Issues

1. **"Auth0 configuration error"**
   - Verify Auth0 credentials in `app_config.dart`
   - Check Auth0 application settings

2. **"Network error"**
   - Ensure backend is running
   - Check `apiBaseUrl` in `app_config.dart`
   - Verify firewall/network settings

3. **"Invalid credentials"**
   - Check Auth0 connection is enabled
   - Verify user exists in Auth0 dashboard

4. **Social login not working**
   - Verify social connections are enabled in Auth0
   - Check callback URLs are configured correctly
   - Ensure platform-specific setup is complete

## API Endpoints

The backend exposes the following endpoints:

- `GET /` - Health check
- `GET /protected` - Protected route (requires JWT)
- `GET /user` - Get user information (requires JWT)

## Next Steps

1. Configure your Auth0 account
2. Update `app_config.dart` with your credentials
3. Set up `.env` file in backend
4. Run the backend server
5. Test the authentication flow

## Support

For issues or questions:
- Check Auth0 documentation: https://auth0.com/docs
- Review Flutter Auth0 plugin docs: https://pub.dev/packages/auth0_flutter
- Check backend logs for API errors

## Notes

- The UI/UX has not been changed - only authentication logic was added
- All existing backend code remains unchanged
- The middleware integration is seamless with existing routes
- Error messages are user-friendly and non-technical

