# Auth0 Integration Setup Checklist

Follow this checklist to get your authentication system up and running.

## Prerequisites

- [ ] Node.js (v16+) installed
- [ ] Flutter SDK installed
- [ ] Auth0 account created at [auth0.com](https://auth0.com)

## Auth0 Configuration

### 1. Create Auth0 API
- [ ] Log in to [Auth0 Dashboard](https://manage.auth0.com)
- [ ] Go to **Applications > APIs**
- [ ] Click **Create API**
- [ ] Enter details:
  - Name: `AspireNet API`
  - Identifier: `https://aspirenet-api` (or your choice)
  - Signing Algorithm: `RS256`
- [ ] Click **Create**
- [ ] **Copy the Identifier** (this is your `AUTH0_AUDIENCE`)

### 2. Create Auth0 Application
- [ ] Go to **Applications > Applications**
- [ ] Click **Create Application**
- [ ] Enter details:
  - Name: `AspireNet Mobile`
  - Type: `Native`
- [ ] Click **Create**
- [ ] Go to **Settings** tab
- [ ] **Copy Domain** (e.g., `dev-xxxxx.us.auth0.com`)
- [ ] **Copy Client ID**
- [ ] Scroll down to **Application URIs**
- [ ] Add allowed callback URLs:
  - `YOUR_PACKAGE_NAME://YOUR_AUTH0_DOMAIN/ios/YOUR_PACKAGE_NAME/callback`
  - `YOUR_PACKAGE_NAME://YOUR_AUTH0_DOMAIN/android/YOUR_PACKAGE_NAME/callback`
- [ ] Click **Save Changes**

### 3. Enable Database Connection
- [ ] Go to **Authentication > Database**
- [ ] Ensure **Username-Password-Authentication** is enabled
- [ ] Click on it to configure
- [ ] Go to **Applications** tab
- [ ] Enable your application
- [ ] Click **Save**

### 4. Enable Social Connections (Optional)
- [ ] Go to **Authentication > Social**
- [ ] Enable desired providers:
  - [ ] Google OAuth2
  - [ ] Apple
  - [ ] Facebook
- [ ] Configure each with their credentials
- [ ] Enable your application for each connection

## Backend Configuration

### 1. Install Dependencies
```bash
cd backend/authentication-api
npm install
```
- [ ] Dependencies installed successfully

### 2. Create Environment File
```bash
# Copy the example file
cp env.example .env
```
- [ ] `.env` file created

### 3. Configure Environment Variables
Edit `backend/authentication-api/.env`:

```env
PORT=3000
AUTH0_DOMAIN=https://YOUR_AUTH0_DOMAIN.auth0.com
AUTH0_AUDIENCE=YOUR_AUTH0_API_IDENTIFIER
```

Replace:
- [ ] `YOUR_AUTH0_DOMAIN` with your Auth0 domain (from step 2.2)
- [ ] `YOUR_AUTH0_API_IDENTIFIER` with your API identifier (from step 1.1)

### 4. Build and Start Backend
```bash
npm run build
npm run dev
```
- [ ] Backend builds without errors
- [ ] Server starts on http://localhost:3000
- [ ] Console shows Auth0 domain (for verification)

### 5. Test Backend
```bash
# In a new terminal
curl http://localhost:3000/
```
Expected response: `{"message":"hello world"}`
- [ ] Health check endpoint works

## Frontend Configuration

### 1. Install Dependencies
```bash
cd frontend
flutter pub get
```
- [ ] Flutter dependencies installed

### 2. Configure Auth0 Settings
Edit `frontend/lib/config/app_config.dart`:

```dart
class AppConfig {
  static const String apiBaseUrl = 'http://localhost:3000';
  static const String auth0Domain = 'YOUR_AUTH0_DOMAIN';
  static const String auth0ClientId = 'YOUR_AUTH0_CLIENT_ID';
  static const String auth0Audience = 'YOUR_AUTH0_AUDIENCE';
  // ...
}
```

Replace:
- [ ] `YOUR_AUTH0_DOMAIN` with domain from Auth0 (without https://)
- [ ] `YOUR_AUTH0_CLIENT_ID` with Client ID from Auth0
- [ ] `YOUR_AUTH0_AUDIENCE` with API identifier from Auth0

### 3. Platform-Specific Setup

#### Android
Edit `android/app/src/main/AndroidManifest.xml`:
- [ ] Add Auth0 RedirectActivity (see AUTHENTICATION_INTEGRATION_README.md)
- [ ] Update package name and domain in the intent filter

#### iOS
Edit `ios/Runner/Info.plist`:
- [ ] Add CFBundleURLTypes configuration (see AUTHENTICATION_INTEGRATION_README.md)
- [ ] Use your Auth0 Client ID as the URL scheme

### 4. Build and Run
```bash
flutter run
```
- [ ] App builds successfully
- [ ] No compilation errors
- [ ] App launches to login screen

## Testing

### Email/Password Authentication
- [ ] Click "Sign Up"
- [ ] Fill in all fields with test data
- [ ] Password is at least 8 characters
- [ ] Passwords match
- [ ] Accept terms and conditions
- [ ] Click "Sign Up"
- [ ] Account created successfully
- [ ] Redirected to onboarding screen

### Login
- [ ] Navigate to login screen
- [ ] Enter the email and password you just created
- [ ] Click "Sign In"
- [ ] Login successful
- [ ] Redirected to home screen

### Forgot Password
- [ ] Navigate to login screen
- [ ] Enter your email
- [ ] Click "Forgot Password"
- [ ] Check email for password reset link
- [ ] Reset password works

### Social Login (if configured)
- [ ] Click "Continue with Google"
- [ ] Authenticate with Google
- [ ] Redirected back to app
- [ ] Login successful
- [ ] Redirected to home screen

### Error Handling
- [ ] Try login with wrong password → Shows clear error message
- [ ] Try signup with existing email → Shows clear error message
- [ ] Try signup with weak password → Shows validation error
- [ ] Try login with empty fields → Shows validation error
- [ ] Try signup without accepting terms → Button remains disabled

### Token Verification
- [ ] Login successfully
- [ ] Close and reopen app
- [ ] User remains logged in (if implemented auto-login)

## Verification

### Backend Verification
- [ ] Server starts without errors
- [ ] Environment variables are loaded correctly
- [ ] Health check endpoint responds
- [ ] Auth0 domain is logged to console

### Frontend Verification
- [ ] App builds without errors
- [ ] All authentication flows work
- [ ] Error messages are user-friendly
- [ ] Loading states appear during authentication
- [ ] Navigation works correctly after auth
- [ ] UI/UX unchanged from original design

### Integration Verification
- [ ] Backend receives JWT tokens from frontend
- [ ] Backend verifies tokens with Auth0
- [ ] Protected routes require authentication
- [ ] User information can be retrieved

## Troubleshooting

If you encounter issues, check:

1. **Auth0 Configuration**
   - [ ] Domain and Client ID are correct
   - [ ] Audience matches between frontend and backend
   - [ ] Connections are enabled for your application

2. **Backend Issues**
   - [ ] `.env` file exists and is configured
   - [ ] Server is running on correct port
   - [ ] No firewall blocking port 3000

3. **Frontend Issues**
   - [ ] `app_config.dart` has correct values
   - [ ] Dependencies installed successfully
   - [ ] Platform-specific setup completed

4. **Network Issues**
   - [ ] Backend URL is correct in frontend config
   - [ ] Device/emulator can reach backend
   - [ ] Internet connection is active

## Documentation References

- **Frontend Setup**: `frontend/AUTHENTICATION_INTEGRATION_README.md`
- **Backend Setup**: `backend/authentication-api/SETUP_GUIDE.md`
- **Integration Summary**: `INTEGRATION_SUMMARY.md`
- **Auth0 Docs**: https://auth0.com/docs

## Next Steps After Setup

1. [ ] Test all authentication flows thoroughly
2. [ ] Configure production Auth0 tenant
3. [ ] Set up CI/CD for deployments
4. [ ] Deploy backend to cloud service (e.g., Heroku, AWS, Google Cloud)
5. [ ] Update frontend config with production backend URL
6. [ ] Build and release mobile apps
7. [ ] Monitor Auth0 logs and analytics
8. [ ] Set up error tracking (e.g., Sentry)

## Success Criteria

✅ All checkboxes above are checked  
✅ Backend runs without errors  
✅ Flutter app builds and runs  
✅ Users can sign up and create accounts  
✅ Users can log in with email/password  
✅ Social logins work (if enabled)  
✅ Error messages are clear and helpful  
✅ Tokens are stored and verified correctly  
✅ Protected routes work as expected  

---

**Congratulations!** Your Auth0 authentication integration is complete and ready for use! 🎉

