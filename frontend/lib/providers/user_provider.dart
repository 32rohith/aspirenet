import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  String _userGoal = '';
  String _userGoalDetails = '';
  String _matchingPreference = '';
  bool _hasCompletedOnboarding = false;

  String get userGoal => _userGoal;
  String get userGoalDetails => _userGoalDetails;
  String get matchingPreference => _matchingPreference;
  bool get hasCompletedOnboarding => _hasCompletedOnboarding;

  // Set user goal
  void setUserGoal(String goal) {
    _userGoal = goal;
    notifyListeners();
  }

  // Set user goal details
  void setUserGoalDetails(String details) {
    _userGoalDetails = details;
    notifyListeners();
  }

  // Set matching preference
  void setMatchingPreference(String preference) {
    _matchingPreference = preference;
    notifyListeners();
  }

  // Complete onboarding
  Future<void> completeOnboarding() async {
    _hasCompletedOnboarding = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasCompletedOnboarding', true);
    notifyListeners();
  }

  // Load onboarding status
  Future<void> loadOnboardingStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _hasCompletedOnboarding = prefs.getBool('hasCompletedOnboarding') ?? false;
    notifyListeners();
  }

  // Reset for testing
  Future<void> resetOnboarding() async {
    _hasCompletedOnboarding = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasCompletedOnboarding', false);
    notifyListeners();
  }
}

