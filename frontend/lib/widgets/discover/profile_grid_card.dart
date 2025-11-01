import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../models/user_profile_model.dart';

class ProfileGridCard extends StatelessWidget {
  final UserProfileModel profile;
  final VoidCallback onViewProfile;

  const ProfileGridCard({
    Key? key,
    required this.profile,
    required this.onViewProfile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          // Profile Image
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  _getGradientColor(profile.id),
                  _getGradientColor(profile.id).withOpacity(0.6),
                ],
              ),
            ),
            child: Center(
              child: Text(
                profile.name[0].toUpperCase(),
                style: const TextStyle(
                  color: AppColors.textColor,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Name
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              profile.name,
              style: const TextStyle(
                color: AppColors.textColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 4),
          // Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              profile.title,
              style: const TextStyle(
                color: AppColors.textSecondaryColor,
                fontSize: 13,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 16),
          // View Profile Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onViewProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.buttonColor,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'View Profile',
                  style: TextStyle(
                    color: AppColors.buttonTextColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Color _getGradientColor(String id) {
    final colors = [
      const Color(0xFF9B4DCA),
      const Color(0xFF4CAF50),
      const Color(0xFFE91E63),
      const Color(0xFF2196F3),
      const Color(0xFFFF9800),
      const Color(0xFF00BCD4),
    ];
    return colors[id.hashCode % colors.length];
  }
}



