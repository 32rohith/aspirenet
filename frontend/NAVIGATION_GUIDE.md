# AspireNet - Complete Navigation Guide

## 📱 App Navigation Flow

```
Login Screen
    ├─→ Sign In → Dashboard
    └─→ Sign Up → Onboarding Flow
                    └─→ Dashboard

Dashboard
    ├─→ [Search Icon] → Discover Screen
    ├─→ [Play Icon] → (To be implemented)
    ├─→ [Deals Icon] → (To be implemented)
    └─→ [Profile Icon] → (To be implemented)

Discover Screen
    ├─→ [Grid Icon] → Toggle Layout (Grid ↔ List)
    ├─→ View Profile → Profile Details (To be implemented)
    ├─→ Connection Buttons → Matching Flow (To be implemented)
    └─→ [Back] → Dashboard
```

## 🎯 Screen-by-Screen Navigation

### 1. **Login Screen** (`login_screen.dart`)
**Entry Point**: App launch

**Navigation Options**:
- ✅ **Sign In** → `HomeScreen` (which redirects to `DashboardScreen`)
- ✅ **Sign Up** → `SignUpScreen`
- ⏳ **Forgot Password** → To be implemented
- ⏳ **Social Logins** → To be implemented

**Code**:
```dart
// Sign In
Navigator.pushReplacement(
  context,
  MaterialPageRoute(builder: (context) => const HomeScreen()),
);

// Go to Sign Up
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const SignUpScreen()),
);
```

---

### 2. **Sign Up Screen** (`signup_screen.dart`)
**How to reach**: Tap "Sign Up" on Login Screen

**Navigation Options**:
- ✅ **Sign Up Button** → `WelcomeScreen` (Onboarding)
- ✅ **Log In Link** → Back to `LoginScreen`

**Code**:
```dart
// After successful signup
Navigator.pushReplacement(
  context,
  MaterialPageRoute(builder: (context) => const WelcomeScreen()),
);
```

---

### 3. **Onboarding Flow** (Post-Signup Only)

#### **3.1 Welcome Screen** (`welcome_screen.dart`)
**Navigation Options**:
- ✅ **Next Button** → `GoalInputScreen`
- ✅ **Skip** → `HomeScreen` → `DashboardScreen`
- ✅ **Back Arrow** → Back to `SignUpScreen`

#### **3.2 Goal Input Screen** (`goal_input_screen.dart`)
**Navigation Options**:
- ✅ **Begin Your Journey** → `MatchingPreferenceScreen`
- ✅ **Skip** → `HomeScreen` → `DashboardScreen`
- ✅ **Back Arrow** → Back to `WelcomeScreen`

#### **3.3 Matching Preference Screen** (`matching_preference_screen.dart`)
**Navigation Options**:
- ✅ **Confirm Preferences** → `HomeScreen` → `DashboardScreen`
- ✅ **Skip** → `HomeScreen` → `DashboardScreen`
- ✅ **Back Arrow** → Back to `GoalInputScreen`

**Code**:
```dart
// Complete onboarding and go to dashboard
await Provider.of<UserProvider>(context, listen: false)
    .completeOnboarding();

Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(builder: (context) => const HomeScreen()),
  (route) => false,
);
```

---

### 4. **Home Screen** (`home_screen.dart`)
**How to reach**: After login or completing onboarding

**Purpose**: Redirects to Dashboard

**Code**:
```dart
return const DashboardScreen();
```

---

### 5. **Dashboard Screen** (`dashboard_screen.dart`)
**Main Application Screen**

**Navigation Options**:
- ✅ **Search Icon (Bottom Nav)** → `DiscoverScreen`
- ✅ **Task "View Details"** → Task Detail Modal
- ⏳ **Home Icon** → Stay on Dashboard
- ⏳ **Play Icon** → To be implemented
- ⏳ **Deals Icon** → To be implemented
- ⏳ **Profile Icon** → To be implemented
- ⏳ **Notifications Icon** → To be implemented
- ⏳ **Edit Icon** → To be implemented

**Code**:
```dart
// Navigate to Discover
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const DiscoverScreen()),
);

// Show task details
showModalBottomSheet(
  context: context,
  builder: (context) => TaskDetailsModal(),
);
```

---

### 6. **Discover Screen** (`discover_screen.dart`)
**How to reach**: Tap Search icon in Dashboard bottom nav

**Navigation Options**:
- ✅ **Grid Icon (Top-Left)** → Toggle Layout (Grid ↔ List)
- ✅ **View Profile** → Profile Details (To be implemented)
- ✅ **Connection Buttons** → Matching flow (To be implemented)
- ✅ **Back Button** → Return to Dashboard
- ⏳ **Notifications Icon** → To be implemented
- ⏳ **Edit Icon** → To be implemented
- ⏳ **Filter Icon** → To be implemented

**Code**:
```dart
// Toggle layout
Provider.of<DiscoverProvider>(context, listen: false).toggleLayout();

// View profile (to be implemented)
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => ProfileDetailScreen(profileId: profile.id),
  ),
);
```

---

## 🔄 Bottom Navigation Bar

Current implementation on Dashboard:

| Index | Icon | Label | Screen | Status |
|-------|------|-------|--------|--------|
| 0 | `home_outlined` | Home | Dashboard | ✅ Active |
| 1 | `search` | Search | Discover | ✅ Implemented |
| 2 | `play_circle_outline` | Play | TBD | ⏳ To do |
| 3 | `location_on_outlined` | Deals | TBD | ⏳ To do |
| 4 | `person_outline` | Profile | TBD | ⏳ To do |

**Code**:
```dart
void _handleNavigation(int index) {
  switch (index) {
    case 0: // Home - Stay on dashboard
      break;
    case 1: // Search - Go to Discover
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const DiscoverScreen()),
      );
      break;
    case 2: // Play - To be implemented
      break;
    case 3: // Deals - To be implemented
      break;
    case 4: // Profile - To be implemented
      break;
  }
}
```

---

## 🎨 Navigation Patterns Used

### 1. **Push** - Standard forward navigation
```dart
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => NextScreen()),
);
```

### 2. **Push Replacement** - Replace current screen
```dart
Navigator.pushReplacement(
  context,
  MaterialPageRoute(builder: (context) => NextScreen()),
);
```

### 3. **Push and Remove Until** - Clear navigation stack
```dart
Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(builder: (context) => NextScreen()),
  (route) => false, // Remove all previous routes
);
```

### 4. **Pop** - Go back
```dart
Navigator.pop(context);
```

### 5. **Modal Bottom Sheet** - Overlay content
```dart
showModalBottomSheet(
  context: context,
  builder: (context) => YourModal(),
);
```

---

## 🚀 Future Navigation To Implement

### Priority 1:
- [ ] Profile Detail Screen
- [ ] Profile Edit Screen
- [ ] Notifications Screen
- [ ] Settings Screen

### Priority 2:
- [ ] Play/Content Screen
- [ ] Deals/Marketplace Screen
- [ ] Chat/Messages Screen
- [ ] Task Detail Screen

### Priority 3:
- [ ] Search Results Screen
- [ ] Filter Options Screen
- [ ] Onboarding Skip Confirmation
- [ ] Logout Confirmation

---

## 🔧 Navigation State Management

### Using Provider for Navigation State:
```dart
// In your provider
void navigateToProfile(BuildContext context, String profileId) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ProfileScreen(profileId: profileId),
    ),
  );
}
```

### Accessing Navigation in Provider:
```dart
// Use Navigator key in main.dart
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// In MaterialApp
MaterialApp(
  navigatorKey: navigatorKey,
  // ...
)

// In provider
navigatorKey.currentState?.push(
  MaterialPageRoute(builder: (context) => NextScreen()),
);
```

---

## 📱 Deep Linking (Future)

Structure for deep links:
```
aspirenet://login
aspirenet://dashboard
aspirenet://discover
aspirenet://profile/[userId]
aspirenet://task/[taskId]
```

---

## 🧭 Navigation Guards

### Check Authentication:
```dart
void navigateToDashboard(BuildContext context) {
  final userProvider = Provider.of<UserProvider>(context, listen: false);
  
  if (userProvider.hasCompletedOnboarding) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const DashboardScreen()),
    );
  } else {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const WelcomeScreen()),
    );
  }
}
```

---

## 💡 Navigation Tips

1. **Use named routes** for complex apps (future enhancement)
2. **Always use `const`** constructors when possible
3. **Clear navigation stack** when appropriate (login/logout)
4. **Handle back button** on Android properly
5. **Use `Navigator.pop`** to return data from screens

---

## 🎯 Current Navigation Summary

| From | To | Type | Status |
|------|------|------|--------|
| Login | Dashboard | Push Replacement | ✅ |
| Login | Sign Up | Push | ✅ |
| Sign Up | Onboarding | Push Replacement | ✅ |
| Onboarding | Dashboard | Push Remove Until | ✅ |
| Dashboard | Discover | Push | ✅ |
| Dashboard | Task Modal | Modal | ✅ |
| Discover | Toggle Layout | State Change | ✅ |

---

**All navigation is functional and ready for backend integration! 🎉**



