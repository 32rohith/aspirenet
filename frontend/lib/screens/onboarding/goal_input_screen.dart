import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../providers/user_provider.dart';
import 'matching_preference_screen.dart';

class GoalInputScreen extends StatefulWidget {
  const GoalInputScreen({Key? key}) : super(key: key);

  @override
  State<GoalInputScreen> createState() => _GoalInputScreenState();
}

class _GoalInputScreenState extends State<GoalInputScreen> {
  final TextEditingController _goalController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();

  @override
  void dispose() {
    _goalController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

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
                        value: 0.66,
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
                      Navigator.pushReplacementNamed(context, '/home');
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
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    // Title
                    const Text(
                      'Tell us about your\nBig Step towards\nsuccess:',
                      style: TextStyle(
                        color: AppColors.textColor,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Subtitle
                    const Text(
                      'In just few words, tell us about what you\nwant to become in the future and take this\nbig step towards success along with us.',
                      style: TextStyle(
                        color: Color(0xFF4CAF50),
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Goal Input
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.backgroundColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.textFieldColor,
                          width: 1,
                        ),
                      ),
                      child: TextField(
                        controller: _goalController,
                        maxLength: 50,
                        style: const TextStyle(
                          color: AppColors.textColor,
                          fontSize: 14,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'e.g: Youtuber, Instagram Content\nCreator, Podcaster, Guitarist, Singer,\nCrypto trader, Stock trader, etc.',
                          hintStyle: TextStyle(
                            color: AppColors.textSecondaryColor,
                            fontSize: 14,
                            height: 1.4,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(16),
                          counterStyle: TextStyle(
                            color: AppColors.textSecondaryColor,
                            fontSize: 12,
                          ),
                        ),
                        onChanged: (value) {
                          Provider.of<UserProvider>(context, listen: false)
                              .setUserGoal(value);
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Details Label
                    const Text(
                      'Explain more about it:',
                      style: TextStyle(
                        color: AppColors.textColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Details Input
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.backgroundColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.textFieldColor,
                          width: 1,
                        ),
                      ),
                      child: TextField(
                        controller: _detailsController,
                        maxLength: 200,
                        maxLines: 4,
                        style: const TextStyle(
                          color: AppColors.textColor,
                          fontSize: 14,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'e.g., Become a famous Podcaster with\none more person from this app and\nmake content with celebrities.',
                          hintStyle: TextStyle(
                            color: AppColors.textSecondaryColor,
                            fontSize: 14,
                            height: 1.4,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(16),
                          counterStyle: TextStyle(
                            color: AppColors.textSecondaryColor,
                            fontSize: 12,
                          ),
                        ),
                        onChanged: (value) {
                          Provider.of<UserProvider>(context, listen: false)
                              .setUserGoalDetails(value);
                        },
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
            // Begin Your Journey Button
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    if (_goalController.text.isNotEmpty &&
                        _detailsController.text.isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MatchingPreferenceScreen(),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please fill in both fields'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFBBAECC),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Begin Your Journey',
                        style: TextStyle(
                          color: AppColors.backgroundColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(
                        Icons.arrow_forward,
                        color: AppColors.backgroundColor,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

