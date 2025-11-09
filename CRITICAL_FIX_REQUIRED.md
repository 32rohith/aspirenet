# 🚨 CRITICAL FIX REQUIRED - Auth0 Error 400

## The Problem You're Seeing

```
Auth0 Signup Error: Failed with unknown error
Status Code: 400
```

This error means **Password authentication is NOT enabled** in your Auth0 Application. The Auth0 Flutter SDK cannot use email/password login until you enable it.

## ✅ THE FIX (Takes 2 Minutes)

### Step 1: Enable Password Grant Type

1. **Open**: https://manage.auth0.com in your browser
2. **Navigate to**: Applications → Applications
3. **Click on**: Your application (AspireNet)
4. **Scroll down** and click: **"Show Advanced Settings"**
5. **Go to**: **"Grant Types"** tab
6. **CHECK THE BOX**: ✅ **"Password"**
7. **CHECK THE BOX**: ✅ **"Password Realm"** (recommended)
8. **Click**: **"Save Changes"** at the bottom

### Step 2: Enable Database Connection

1. **Go to**: Authentication → Database → Username-Password-Authentication
2. **Click**: **"Applications"** tab
3. **Find your app** in the list
4. **Toggle it ON** (should turn green)
5. **Click**: **"Save"**

### Step 3: Optional - Configure Default Directory

1. **Go to**: Settings → Tenant Settings → General
2. **Set "Default Directory"**: `Username-Password-Authentication`
3. **Save**

## 🧪 Test Again

After completing the steps above:

```powershell
# If app is still running, stop it (Ctrl+C in terminal)
cd frontend
flutter run
```

Then try to sign up again. You should now see detailed logs showing:
- Domain being used
- Client ID
- Connection name
- Either success ✅ or a more specific error

## 📋 What The Console Will Show After Fix

**Before Fix (Current):**
```
Auth0 Signup Error: Failed with unknown error
Status Code: 400
```

**After Fix (Success):**
```
✅ Signup API call successful!
✅ Auto-login successful!
```

**Or (If Email Verification Required):**
```
✅ Signup API call successful!
Account created! Please verify your email before logging in.
```

## 🔍 Additional Debugging Info

The app now prints detailed information when you try to login/signup:

```
============ Auth0 Signup Request ============
Domain: dev-4fw8d54yrctcnh0m.us.auth0.com
Client ID: yMEPXUr5NCQxRuLvP2fjJfeKQ8PgjYQY
Connection: Username-Password-Authentication
Email: your@email.com
Username: yourusername
Name: Your Name
Password Length: 12
==========================================
```

If you still see errors after enabling Password grant, the console will show the EXACT error from Auth0.

## ⚠️ Common Follow-Up Issues (After Enabling Password Grant)

### Issue: "Please verify your email"
**This is NORMAL!** Auth0 sent you a verification email. Check your inbox and click the link.

### Issue: "Password is too weak"
Use a password with:
- At least 8 characters
- Uppercase letter (A-Z)
- Lowercase letter (a-z)
- Number (0-9)
- Example: `Password123`

### Issue: "User already exists"
The email is already registered. Just use "Sign In" instead.

## 📞 Still Not Working?

If after enabling Password grant you still see errors, check the console output and look for:

1. **The exact error message** Auth0 returns
2. **The status code** (401, 403, etc.)
3. **Any details** in the error

Then share the console output and I'll help you fix it!

## 🎯 Summary

**You're seeing error 400 "Failed with unknown error" because:**
- Password grant type is NOT enabled in Auth0

**To fix:**
1. Enable "Password" grant type (Step 1 above)
2. Enable Database connection for your app (Step 2 above)
3. Restart the app
4. Try again

**After fix, authentication will work perfectly within your app!** ✅

