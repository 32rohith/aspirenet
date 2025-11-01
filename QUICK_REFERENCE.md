# Quick Reference Guide - Auth0 Integration

## 🚀 Quick Start Commands

### Start Backend Server
```bash
cd backend/authentication-api
npm run dev
```

### Run Flutter App
```bash
cd frontend
flutter run
```

## 📝 Configuration Files

### Frontend Config
**File**: `frontend/lib/config/app_config.dart`
```dart
static const String apiBaseUrl = 'http://localhost:3000';
static const String auth0Domain = 'YOUR_DOMAIN.auth0.com';
static const String auth0ClientId = 'YOUR_CLIENT_ID';
static const String auth0Audience = 'YOUR_AUDIENCE';
```

### Backend Config
**File**: `backend/authentication-api/.env`
```env
PORT=3000
AUTH0_DOMAIN=https://YOUR_DOMAIN.auth0.com
AUTH0_AUDIENCE=YOUR_AUDIENCE
```

## 🔑 Auth0 Setup URLs

- **Dashboard**: https://manage.auth0.com
- **Create API**: Applications > APIs > Create API
- **Create Application**: Applications > Applications > Create Application
- **Enable Connections**: Authentication > Database / Social

## 📂 Key Files Created

### Frontend
```
lib/
├── config/
│   └── app_config.dart              # Configuration
├── models/
│   └── auth_models.dart             # Data models
├── providers/
│   └── auth_provider.dart           # State management
├── services/
│   ├── api_client.dart              # HTTP client
│   └── auth_service.dart            # Auth0 service
└── screens/
    ├── login_screen.dart            # Login (integrated)
    └── signup_screen.dart           # Signup (integrated)
```

### Backend (Unchanged)
```
src/
├── app.ts                          # Main app
├── middleware/
│   └── JWTcheck.ts                # JWT verification
└── controller/
    └── user.controller.ts          # User endpoints
```

## 🔐 Authentication Methods

| Method | Function | File |
|--------|----------|------|
| **Email/Password Login** | `loginWithEmailPassword()` | `auth_service.dart` |
| **Email/Password Signup** | `signupWithEmailPassword()` | `auth_service.dart` |
| **Google Login** | `loginWithGoogle()` | `auth_service.dart` |
| **Apple Login** | `loginWithApple()` | `auth_service.dart` |
| **Facebook Login** | `loginWithFacebook()` | `auth_service.dart` |
| **Forgot Password** | `resetPassword()` | `auth_service.dart` |

## 🎯 API Endpoints

| Endpoint | Method | Auth Required | Description |
|----------|--------|--------------|-------------|
| `/` | GET | No | Health check |
| `/protected` | GET | Yes | Verify authentication |
| `/user` | GET | Yes | Get user info |

## 💡 Common Usage Examples

### Check if User is Authenticated
```dart
final authProvider = Provider.of<AuthProvider>(context, listen: false);
if (authProvider.isAuthenticated) {
  // User is logged in
}
```

### Login User
```dart
final authProvider = Provider.of<AuthProvider>(context, listen: false);
final result = await authProvider.loginWithEmailPassword(
  email: email,
  password: password,
);

if (result.isSuccess) {
  // Navigate to home
} else {
  // Show error: result.error!.getUserFriendlyMessage()
}
```

### Logout User
```dart
final authProvider = Provider.of<AuthProvider>(context, listen: false);
await authProvider.logout();
// Navigate to login screen
```

### Get Current User
```dart
final authProvider = Provider.of<AuthProvider>(context);
final user = authProvider.currentUser;
print(user?.email);
```

## 🛡️ Protected Route (Backend)

```typescript
import { JWTcheck } from "./middleware/JWTcheck.js";

app.get("/your-route", JWTcheck, (req, res) => {
  const userId = req.auth?.sub;
  const email = req.auth?.email;
  // Your logic here
});
```

## 🐛 Troubleshooting Quick Fixes

| Issue | Solution |
|-------|----------|
| Backend won't start | Check `.env` file exists and is configured |
| "Invalid token" error | Verify `AUTH0_AUDIENCE` matches in frontend & backend |
| "Network error" | Ensure backend is running on correct URL |
| Social login fails | Check Auth0 connection is enabled and configured |
| "User exists" on signup | User already registered, use login instead |
| App won't build | Run `flutter pub get` in frontend directory |

## 📊 Validation Rules

| Field | Rules |
|-------|-------|
| **Email** | Valid email format required |
| **Password** | Minimum 8 characters |
| **Username** | Minimum 3 characters |
| **Name** | Cannot be empty |
| **Confirm Password** | Must match password |

## 🎨 User-Friendly Error Messages

All technical errors are automatically converted to user-friendly messages:

| Code | User Sees |
|------|-----------|
| `invalid_credentials` | "Invalid email or password..." |
| `user_exists` | "An account with this email already exists..." |
| `password_too_weak` | "Password is too weak..." |
| `network_error` | "Network connection error..." |
| `server_error` | "Server error. Please try again later." |

## 📱 Platform-Specific Requirements

### Android
Add to `AndroidManifest.xml`:
- Auth0 RedirectActivity configuration
- Callback URL intent filter

### iOS
Add to `Info.plist`:
- CFBundleURLTypes with Auth0 client ID

See `AUTHENTICATION_INTEGRATION_README.md` for details.

## 🔒 Security Features

✅ Secure token storage (flutter_secure_storage)  
✅ JWT verification with Auth0  
✅ Input validation (client & server)  
✅ HTTPS communication  
✅ Token expiration handling  
✅ User-friendly error messages (no technical details exposed)  

## 📚 Documentation Files

| File | Purpose |
|------|---------|
| `SETUP_CHECKLIST.md` | Step-by-step setup guide |
| `INTEGRATION_SUMMARY.md` | Complete integration overview |
| `frontend/AUTHENTICATION_INTEGRATION_README.md` | Frontend integration details |
| `backend/authentication-api/SETUP_GUIDE.md` | Backend setup instructions |
| `QUICK_REFERENCE.md` | This file - quick reference |

## 🧪 Test Credentials (After Setup)

Create a test account:
- Email: `test@example.com`
- Password: `TestPass123!`
- Use for testing login flow

## 🌐 Production Checklist

Before going live:
- [ ] Create production Auth0 tenant
- [ ] Deploy backend to cloud service
- [ ] Update frontend config with production URL
- [ ] Configure production callback URLs in Auth0
- [ ] Enable rate limiting on backend
- [ ] Set up monitoring and logging
- [ ] Test all flows in production environment
- [ ] Configure custom domain (optional)

## 💻 Development vs Production

| Aspect | Development | Production |
|--------|------------|------------|
| **Backend URL** | `http://localhost:3000` | `https://api.yourapp.com` |
| **Auth0 Tenant** | Development tenant | Production tenant |
| **HTTPS** | Not required | Required |
| **Rate Limiting** | Disabled | Enabled |
| **Logging** | Console | Cloud service |

## 🆘 Support Resources

- **Auth0 Docs**: https://auth0.com/docs
- **Flutter Auth0 Plugin**: https://pub.dev/packages/auth0_flutter
- **Express OAuth2 JWT**: https://www.npmjs.com/package/express-oauth2-jwt-bearer

## ⚡ Performance Tips

1. **Token Caching**: Tokens are cached in secure storage
2. **Auto-Refresh**: Implement token refresh for better UX
3. **Offline Support**: Store user data locally when authenticated
4. **Loading States**: Always shown during authentication operations

## 🔄 Authentication State Flow

```
App Start
    ↓
Check Stored Token
    ↓
    ├─ Valid Token → Home Screen
    └─ No/Invalid Token → Login Screen
        ↓
    Login/Signup Success
        ↓
    Store Token
        ↓
    Navigate to Home
```

## 📞 Quick Help

**Need help?** Check these in order:
1. Review error message in app
2. Check console logs (backend & frontend)
3. Verify Auth0 configuration
4. Review relevant documentation file
5. Check Auth0 logs in dashboard

---

**Happy Coding!** 🚀

