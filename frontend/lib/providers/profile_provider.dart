import 'package:flutter/foundation.dart';
import '../models/user_profile_extended_model.dart';

class ProfileProvider extends ChangeNotifier {
  UserProfileExtended? _currentProfile;
  bool _isLoading = false;
  bool _notificationsEnabled = true;

  // Static data
  final UserProfileExtended _staticProfile = UserProfileExtended(
    id: 'user123',
    name: 'Alex Johnson',
    username: '@alex_j',
    bio:
        'Entrepreneur & Crypto Trader | Let\'s connect to take the big step together with our cryptos',
    avatarUrl: '',
    isOnline: true,
    ambitionTitle: 'Ambition',
    ambitionDescription: 'Crypto Trader and Forex Investor',
    passionDescription:
        'From when I was 20 years old, I have been interested in making YouTube videos and especially content related to comedy and politics. My comedy is more centered towards kids humour and teenagers. My politics content is related to BJP government being really good.',
    skills: [
      '1) Mastered price action for cryptos in online courses',
      '2) Developed financial data analysis through YouTube videos by Ken Z.',
      '3) Currently mastering Fibonacci Retracement for cryptos by Dheeraj Reddy S.',
    ],
    connectionsCount: 234,
    projectsCount: 12,
    eventsCount: 8,
  );

  // Getters
  UserProfileExtended get currentProfile =>
      _currentProfile ?? _staticProfile;
  bool get isLoading => _isLoading;
  bool get notificationsEnabled => _notificationsEnabled;

  // Set loading
  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Toggle notifications
  void toggleNotifications(bool value) {
    _notificationsEnabled = value;
    notifyListeners();

    // TODO: Implement API call
    // http.post(
    //   Uri.parse('YOUR_API_URL/settings/notifications'),
    //   body: json.encode({'enabled': value}),
    // );
  }

  // Fetch profile
  Future<void> fetchProfile() async {
    setLoading(true);
    try {
      // TODO: Implement API call
      // final response = await http.get(
      //   Uri.parse('YOUR_API_URL/profile'),
      // );

      await Future.delayed(const Duration(milliseconds: 500));
      _currentProfile = _staticProfile;
      notifyListeners();
    } catch (e) {
      // Error fetching profile
    } finally {
      setLoading(false);
    }
  }

  // Update profile
  Future<void> updateProfile(UserProfileExtended profile) async {
    try {
      _currentProfile = profile;
      notifyListeners();

      // TODO: Implement API call
      // await http.put(
      //   Uri.parse('YOUR_API_URL/profile'),
      //   body: json.encode(profile.toJson()),
      // );
    } catch (e) {
      // Error updating profile
    }
  }

  // Share profile
  void shareProfile() {
    // TODO: Implement share functionality
    // Share.share('Check out my AspireNet profile: https://aspirenet.com/${currentProfile.username}');
  }
}



