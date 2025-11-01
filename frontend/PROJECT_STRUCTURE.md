# AspireNet - Complete Project Structure

## 📁 Full Project Architecture

```
aspirenet/
├── lib/
│   ├── main.dart                    # App entry point with Provider setup
│   │
│   ├── constants/
│   │   └── app_colors.dart          # App-wide color scheme
│   │
│   ├── models/                      # Data models (Backend-ready)
│   │   ├── task_model.dart
│   │   ├── dashboard_stats_model.dart
│   │   └── chart_data_model.dart
│   │
│   ├── providers/                   # State management (Provider)
│   │   ├── user_provider.dart       # User onboarding & preferences
│   │   └── dashboard_provider.dart  # Dashboard data management
│   │
│   ├── screens/                     # All app screens
│   │   ├── login_screen.dart        # Login page
│   │   ├── signup_screen.dart       # Sign up page
│   │   ├── home_screen.dart         # Home redirector
│   │   ├── dashboard_screen.dart    # Main dashboard
│   │   └── onboarding/              # Onboarding flow (post-signup)
│   │       ├── welcome_screen.dart
│   │       ├── goal_input_screen.dart
│   │       └── matching_preference_screen.dart
│   │
│   └── widgets/                     # Reusable widgets
│       ├── custom_text_field.dart
│       ├── social_login_button.dart
│       └── dashboard/               # Dashboard-specific widgets
│           ├── daily_streak_card.dart
│           ├── task_completion_chart.dart
│           ├── team_performance_chart.dart
│           ├── progress_overview_card.dart
│           └── task_card.dart
│
├── assets/
│   └── images/                      # Image assets
│
├── pubspec.yaml                     # Dependencies
├── DASHBOARD_README.md              # Dashboard documentation
└── PROJECT_STRUCTURE.md             # This file
```

## 🎯 App Flow

### 1. **Authentication Flow**
```
Login Screen
    ├─→ Sign In → Dashboard (Skip Onboarding)
    └─→ Sign Up → Onboarding Flow → Dashboard
```

### 2. **Onboarding Flow** (Only after signup)
```
Signup Success
    ↓
Welcome Screen (Screen 1)
    ↓
Goal Input Screen (Screen 2)
    ↓
Matching Preference Screen (Screen 3)
    ↓
Dashboard
```

### 3. **Dashboard Features**
- Daily Streak Tracking
- Performance Charts (3 swipeable views)
- Progress Overview (4 key metrics)
- Task Management (Assigned to/by user)
- Bottom Navigation
- Score Display

## 🎨 Design System

### Colors
- **Primary Purple**: `#9B4DCA`
- **Background**: `#000000` (Black)
- **Card Background**: `#1E2328` (Dark Gray)
- **Text Fields**: `#2C3237`
- **Text Primary**: `#FFFFFF`
- **Text Secondary**: `#B0B0B0`
- **Button**: `#D1D1D1`
- **Success Green**: `#4CAF50`
- **Warning Orange**: `#FF9800`

### Typography
- **Title**: 28-32px, Bold
- **Heading**: 18-24px, Bold
- **Body**: 14-16px, Regular
- **Caption**: 12px, Regular

## 📦 Dependencies

```yaml
dependencies:
  flutter: sdk
  provider: ^6.1.1           # State management
  shared_preferences: ^2.2.2 # Local storage
  cupertino_icons: ^1.0.8    # iOS icons
```

## 🔐 State Management

### UserProvider
Manages:
- User goals and preferences
- Onboarding completion status
- User profile data

### DashboardProvider
Manages:
- Dashboard statistics
- Task lists (assigned to/by user)
- Chart data
- Selected chart view

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.7.2+)
- Dart SDK
- Android Studio / VS Code
- Android Emulator / iOS Simulator

### Installation
```bash
# Clone the repository
git clone <your-repo-url>

# Navigate to project
cd aspirenet

# Install dependencies
flutter pub get

# Run the app
flutter run
```

### First Run
1. App starts at **Login Screen**
2. Tap **"Sign Up"** to create account
3. Fill signup form and accept terms
4. Complete **3-step onboarding**:
   - Welcome introduction
   - Enter your goals
   - Choose matching preference
5. Land on **Dashboard**

### Testing Login Flow
- **Login** button → Goes directly to Dashboard (skips onboarding)
- **Sign Up** button → Goes through onboarding, then Dashboard

## 🎭 Features by Screen

### Login Screen
✅ Email/Username input
✅ Password with visibility toggle
✅ Sign In button
✅ Forgot Password
✅ Social logins (Google, Apple, Facebook)
✅ Sign Up navigation

### Sign Up Screen
✅ Username, Name, Email fields
✅ Password & Confirm Password
✅ Terms & Conditions checkbox
✅ Sign Up button (enabled when terms accepted)
✅ Log In navigation

### Onboarding Screens
✅ **Welcome**: Introduction with illustration
✅ **Goal Input**: User goals (50 chars) + details (200 chars)
✅ **Matching**: Choose Similar Interests or Complementary Skills
✅ Progress bar across all 3 screens
✅ Skip option on all screens

### Dashboard Screen
✅ Daily Streak card (12 days)
✅ 3 swipeable charts with indicators
✅ Progress Overview (4 metrics)
✅ Tasks Assigned To Me section
✅ Tasks Assigned By Me section
✅ Task cards with status, progress, avatars
✅ Bottom navigation (5 items)
✅ Score display
✅ Task detail modal

## 🔧 Backend Integration Ready

### Models Structure
All models include:
- `fromJson()` - Parse API responses
- `toJson()` - Serialize for API requests

### Provider Methods
Placeholder methods for API calls:
```dart
// In DashboardProvider
Future<void> fetchDashboardData() async {
  // TODO: Implement API call
}

Future<void> fetchTasks() async {
  // TODO: Implement API call
}
```

### Recommended API Structure
```
GET  /api/dashboard/stats       - Dashboard statistics
GET  /api/dashboard/tasks/me    - Tasks assigned to user
GET  /api/dashboard/tasks/by-me - Tasks assigned by user
GET  /api/dashboard/chart-data  - Chart data
POST /api/tasks/:id/update      - Update task status
```

## 📱 Screen Sizes
- Responsive design
- Works on all screen sizes
- Optimized for mobile (phones & tablets)
- SafeArea support for notches

## 🎨 UI Components

### Reusable Widgets
1. **CustomTextField** - Styled input fields
2. **SocialLoginButton** - Social auth buttons
3. **DailyStreakCard** - Streak display
4. **TaskCompletionChart** - Bar chart
5. **TeamPerformanceChart** - Donut chart
6. **ProgressOverviewCard** - Stats grid
7. **TaskCard** - Task item display

### Design Patterns
- **Provider** for state management
- **Widget composition** for reusability
- **Separation of concerns** (UI/Logic/Data)
- **Future-proof** structure for scaling

## 🐛 Debugging

### Check Provider State
```dart
// In any widget
final provider = Provider.of<DashboardProvider>(context, listen: false);
print(provider.stats.dailyStreak);
```

### Reset Onboarding
```dart
await Provider.of<UserProvider>(context, listen: false).resetOnboarding();
```

## 📈 Next Steps

### Phase 1: API Integration
- [ ] Add HTTP client (dio/http)
- [ ] Implement authentication API
- [ ] Connect dashboard to backend
- [ ] Add error handling

### Phase 2: Advanced Features
- [ ] Push notifications
- [ ] Real-time updates (WebSocket)
- [ ] Image upload for avatars
- [ ] Task creation/editing UI

### Phase 3: Polish
- [ ] Animations & transitions
- [ ] Loading states
- [ ] Error states
- [ ] Empty states
- [ ] Shimmer effects

### Phase 4: Testing
- [ ] Unit tests for models
- [ ] Provider tests
- [ ] Widget tests
- [ ] Integration tests

## 💡 Development Tips

1. **Hot Reload**: Press `r` in terminal during development
2. **Hot Restart**: Press `R` to restart app
3. **Debug Mode**: Use Flutter DevTools for inspection
4. **State Changes**: Use `notifyListeners()` in providers
5. **Navigation**: Use `Navigator.push/pop` for screen transitions

## 📞 Support

For questions or issues:
1. Check the documentation in this file
2. Review `DASHBOARD_README.md` for dashboard details
3. Inspect code comments in source files
4. Check Flutter documentation: https://flutter.dev

---

**Built with ❤️ using Flutter & Provider**



