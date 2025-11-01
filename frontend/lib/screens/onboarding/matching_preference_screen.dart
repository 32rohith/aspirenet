import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../providers/user_provider.dart';
import '../home_screen.dart';

class MatchingPreferenceScreen extends StatefulWidget {
  const MatchingPreferenceScreen({Key? key}) : super(key: key);

  @override
  State<MatchingPreferenceScreen> createState() =>
      _MatchingPreferenceScreenState();
}

class _MatchingPreferenceScreenState extends State<MatchingPreferenceScreen> {
  String? _selectedPreference;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar with progress and skip
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: AppColors.textColor,
                      size: 20,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: 1.0,
                        backgroundColor: AppColors.textFieldColor,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFF9B7FBD),
                        ),
                        minHeight: 6,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  GestureDetector(
                    onTap: () {
                      // Skip to home
                      _navigateToHome();
                    },
                    child: const Text(
                      'Skip',
                      style: TextStyle(
                        color: AppColors.textColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Title
                    const Text(
                      'How do you want to connect on\nAspireNet\nto succeed together?',
                      style: TextStyle(
                        color: AppColors.textColor,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        height: 1.3,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    // Subtitle
                    const Text(
                      'Choose your primary matching style.',
                      style: TextStyle(
                        color: AppColors.textSecondaryColor,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    // Similar Interests Option
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedPreference = 'similar';
                        });
                        Provider.of<UserProvider>(context, listen: false)
                            .setMatchingPreference('similar');
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: _selectedPreference == 'similar'
                              ? const Color(0xFFBBAECC)
                              : const Color(0xFFBBAECC).withOpacity(0.3),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: const [
                                Icon(
                                  Icons.people_outline,
                                  color: AppColors.backgroundColor,
                                  size: 28,
                                ),
                                SizedBox(width: 12),
                                Text(
                                  'Similar Interests',
                                  style: TextStyle(
                                    color: AppColors.backgroundColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Find collaborators and mentors with skills that\nis similar to yours.',
                              style: TextStyle(
                                color: AppColors.backgroundColor,
                                fontSize: 14,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Complementary Skills Option
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedPreference = 'complementary';
                        });
                        Provider.of<UserProvider>(context, listen: false)
                            .setMatchingPreference('complementary');
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: _selectedPreference == 'complementary'
                              ? const Color(0xFF4CAF50)
                              : const Color(0xFF4CAF50).withOpacity(0.3),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: const [
                                Icon(
                                  Icons.bolt,
                                  color: AppColors.backgroundColor,
                                  size: 28,
                                ),
                                SizedBox(width: 12),
                                Text(
                                  'Complementary Skills',
                                  style: TextStyle(
                                    color: AppColors.backgroundColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Find collaborators and mentors with skills that\ncomplete yours.',
                              style: TextStyle(
                                color: AppColors.backgroundColor,
                                fontSize: 14,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Confirm Button
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _selectedPreference != null
                      ? () async {
                          await Provider.of<UserProvider>(context, listen: false)
                              .completeOnboarding();
                          _navigateToHome();
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50),
                    disabledBackgroundColor:
                        const Color(0xFF4CAF50).withOpacity(0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Confirm Preferences',
                    style: TextStyle(
                      color: AppColors.textColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToHome() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
      (route) => false,
    );
  }
}

