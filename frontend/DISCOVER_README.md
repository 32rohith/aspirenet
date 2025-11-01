# Discover Page Implementation Guide

## Overview
The Discover page features two switchable layouts (Grid & List) to help users find and connect with potential collaborators, mentors, and like-minded individuals. Built with Provider for state management and structured for seamless backend integration.

## 📁 Project Structure

```
lib/
├── models/
│   └── user_profile_model.dart       # User profile data structure
├── providers/
│   └── discover_provider.dart        # Discover state management
├── widgets/
│   └── discover/
│       ├── profile_grid_card.dart    # Grid layout card
│       └── profile_list_card.dart    # List layout card
└── screens/
    └── discover_screen.dart          # Main discover screen
```

## ✨ Features

### 🎯 Two Layout Modes

#### 1. **Grid Layout** (Default)
- 2-column grid of profile cards
- Compact view showing:
  - Profile picture (circular with gradient)
  - Name
  - Title/profession
  - "View Profile" button
- "Suggested for you" header
- Connection buttons at bottom

#### 2. **List Layout**
- Full-width card view showing:
  - Large profile image
  - Name with age and verification badge
  - Location
  - Bio (3 lines max)
  - Skill tags (purple pills)
  - Follower count
  - Like button (heart icon)
- "Explore Your Network" button
- Additional connection buttons

### 🔄 Layout Toggle
- Click the **grid icon** (top-left) to switch between layouts
- Icon changes: `grid_view_rounded` ↔ `view_list_rounded`
- Smooth transition between layouts
- State persists during session

### 🔍 Search Functionality
- Search bar with filter icon
- Real-time search (ready for API integration)
- Placeholder: "Search for people, passions, or tribes..."

### 💜 Like System
- Heart icon on list layout cards
- Toggle between liked/unliked states
- Tracks liked profiles
- Visual feedback (red heart when liked)

### 🤝 Connection Options
Three connection buttons:
1. **Connect with Similar Interests** (Purple)
2. **Connect with Complementary Skills** (Green)
3. **Explore Your Network** (Purple - List layout only)

### 📊 Profile Data
Each profile includes:
- ID (unique identifier)
- Name
- Age
- Title/profession
- Location
- Bio/description
- Profile image URL
- Skills array
- Follower count
- Verification status

## 🎨 UI Components

### ProfileGridCard
**Location**: `lib/widgets/discover/profile_grid_card.dart`

Features:
- Circular profile image with gradient background
- Name (18px, bold)
- Title (13px, secondary color)
- "View Profile" button (light gray)
- Gradient colors based on profile ID hash

### ProfileListCard
**Location**: `lib/widgets/discover/profile_list_card.dart`

Features:
- Large header image (200px height)
- Name with age and verification badge
- Location with pin icon
- Bio text (14px, 3 lines max)
- Skill tags (purple badges)
- Follower count
- Like/Unlike button with heart icon

## 🔧 State Management

### DiscoverProvider
**Location**: `lib/providers/discover_provider.dart`

#### State Variables:
```dart
DiscoverLayout _currentLayout        // grid or list
List<UserProfileModel> _suggestedProfiles  // User profiles
List<String> _likedProfiles          // Liked profile IDs
bool _isLoading                      // Loading state
String _searchQuery                  // Search text
```

#### Key Methods:
```dart
void toggleLayout()                  // Switch between grid/list
void likeProfile(String id)          // Like a profile
void unlikeProfile(String id)        // Unlike a profile
bool isProfileLiked(String id)       // Check if liked
void setSearchQuery(String query)    // Update search

// Backend-ready methods:
Future<void> fetchSuggestedProfiles()
Future<void> searchProfiles(String query)
Future<void> connectWithSimilarInterests()
Future<void> connectWithComplementarySkills()
Future<void> viewProfile(String id)
```

## 🌐 Backend Integration

### 1. API Endpoints Structure

```
GET  /api/discover/suggested        - Get suggested profiles
GET  /api/discover/search?q=query   - Search profiles
POST /api/discover/like/:id         - Like a profile
DELETE /api/discover/like/:id       - Unlike a profile
POST /api/discover/connect/similar  - Connect with similar interests
POST /api/discover/connect/complementary - Connect complementary skills
GET  /api/profile/:id               - View profile details
```

### 2. Expected API Response Format

#### Suggested Profiles Response:
```json
{
  "profiles": [
    {
      "id": "user123",
      "name": "Maya",
      "age": 24,
      "title": "Aspiring Musician",
      "location": "Los Angeles, CA",
      "bio": "Passionate about creating melodies...",
      "profileImageUrl": "https://cdn.example.com/profiles/maya.jpg",
      "skills": ["Music", "Singing", "Guitar"],
      "followers": 1200,
      "isVerified": false
    }
  ],
  "pagination": {
    "page": 1,
    "perPage": 20,
    "total": 156
  }
}
```

### 3. Implementing API Calls

In `discover_provider.dart`, replace the TODO comments:

```dart
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> fetchSuggestedProfiles() async {
  setLoading(true);
  try {
    final response = await http.get(
      Uri.parse('YOUR_API_URL/discover/suggested'),
      headers: {
        'Authorization': 'Bearer ${YOUR_AUTH_TOKEN}',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      _suggestedProfiles = (data['profiles'] as List)
          .map((profile) => UserProfileModel.fromJson(profile))
          .toList();
      notifyListeners();
    }
  } catch (e) {
    print('Error fetching profiles: $e');
  } finally {
    setLoading(false);
  }
}

Future<void> likeProfileAPI(String profileId) async {
  try {
    final response = await http.post(
      Uri.parse('YOUR_API_URL/discover/like/$profileId'),
      headers: {
        'Authorization': 'Bearer ${YOUR_AUTH_TOKEN}',
      },
    );
    
    if (response.statusCode == 200) {
      likeProfile(profileId);
    }
  } catch (e) {
    print('Error liking profile: $e');
  }
}
```

### 4. Add Loading States

In `discover_screen.dart`, loading is already implemented:

```dart
discoverProvider.isLoading
  ? const Center(
      child: CircularProgressIndicator(
        color: AppColors.primaryPurple,
      ),
    )
  : // Your content
```

### 5. Add Pagination

For infinite scrolling:

```dart
@override
void initState() {
  super.initState();
  _scrollController.addListener(_onScroll);
}

void _onScroll() {
  if (_scrollController.position.pixels ==
      _scrollController.position.maxScrollExtent) {
    // Load more profiles
    Provider.of<DiscoverProvider>(context, listen: false)
        .loadMoreProfiles();
  }
}
```

## 🎨 Color Scheme

- **Primary Purple**: `#9B4DCA`
- **Light Purple**: `#BBAEC`
- **Success Green**: `#4CAF50`
- **Card Background**: `#1E2328`
- **Background**: `#000000`
- **Text Primary**: `#FFFFFF`
- **Text Secondary**: `#B0B0B0`

## 🎯 Navigation

### From Dashboard to Discover:
- Tap the **Search icon** in bottom navigation bar
- Navigates to Discover screen

### From Discover:
- "View Profile" button → Profile details page (to be implemented)
- Connection buttons → Matching/connection flow (to be implemented)

## 📱 Responsive Design

- Grid: 2 columns on all screen sizes
- Cards adjust to screen width
- Scroll controller for smooth scrolling
- SafeArea for notch support

## 🧪 Testing

### Test Layout Toggle:
1. Open Discover page
2. Tap grid icon (top-left)
3. Verify layout changes from grid to list
4. Tap again, verify it changes back

### Test Like Functionality:
1. Switch to list layout
2. Tap heart icon on a profile
3. Verify icon fills with red
4. Tap again, verify it returns to outline

### Test Search:
1. Type in search bar
2. Check `_searchQuery` updates in provider
3. (Backend: verify search results update)

## 🚀 Future Enhancements

### Phase 1:
- [ ] Profile detail page
- [ ] Real-time notifications
- [ ] Profile image uploads
- [ ] Advanced filters (age, location, skills)

### Phase 2:
- [ ] Swipe gestures for like/pass
- [ ] Chat integration
- [ ] Video profiles
- [ ] Recommendation algorithm improvements

### Phase 3:
- [ ] Analytics (profile views, likes)
- [ ] A/B testing for layouts
- [ ] Personalized suggestions
- [ ] Social sharing

## 📊 Static Data

Currently using 9 sample profiles:
1. Maya - Aspiring Musician
2. Ethan - Creative Entrepreneur
3. Chloe - Digital Artist
4. Liam - Fitness Enthusiast
5. Sophia - Activist & Leader
6. Noah - Indie Game Developer
7. Evelyn Reed - Software Engineer
8. Kai Sharma - Film Student
9. Lena Petrova - Fashion Design Student

Replace with API data by implementing `fetchSuggestedProfiles()`.

## 💡 Development Tips

1. **Profile Images**: Currently using gradient backgrounds with initials. Replace with actual images from API.

2. **Error Handling**: Add try-catch blocks and user-friendly error messages.

3. **Caching**: Consider caching profile data to reduce API calls.

4. **Offline Support**: Store liked profiles locally using SharedPreferences.

5. **Performance**: Use `ListView.builder` instead of `Column` for large lists.

## 🐛 Troubleshooting

### Layout not toggling:
- Check `DiscoverProvider` is properly injected
- Verify `notifyListeners()` is called
- Check widget is wrapped in `Consumer` or using `context.watch`

### Profiles not loading:
- Check `fetchSuggestedProfiles()` is called in `initState`
- Verify API endpoint is correct
- Check network connectivity

### Like button not working:
- Verify profile ID is correct
- Check `likeProfile()` method is called
- Ensure state updates trigger rebuild

## 📖 Usage Example

```dart
// Navigate to Discover page
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const DiscoverScreen(),
  ),
);

// Access provider
final discoverProvider = Provider.of<DiscoverProvider>(context);

// Toggle layout
discoverProvider.toggleLayout();

// Like a profile
discoverProvider.likeProfile('user123');

// Check if liked
bool isLiked = discoverProvider.isProfileLiked('user123');
```

## 🎉 Completion Checklist

- [x] Grid layout with 2 columns
- [x] List layout with detailed cards
- [x] Layout toggle functionality
- [x] Search bar UI
- [x] Like/unlike functionality
- [x] Connection buttons
- [x] Provider state management
- [x] Backend-ready structure
- [x] Proper models with JSON parsing
- [x] Loading states
- [x] Navigation integration
- [x] Responsive design
- [x] Color scheme matching designs

---

**Built with ❤️ for seamless collaboration and discovery**



