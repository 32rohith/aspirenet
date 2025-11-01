import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../models/user_profile_model.dart';

class ProfileListCard extends StatelessWidget {
  final UserProfileModel profile;
  final bool isLiked;
  final VoidCallback onLike;
  final VoidCallback onViewProfile;

  const ProfileListCard({
    Key? key,
    required this.profile,
    required this.isLiked,
    required this.onLike,
    required this.onViewProfile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Image
          GestureDetector(
            onTap: onViewProfile,
            child: Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                gradient: LinearGradient(
                  colors: [
                    _getGradientColor(profile.id),
                    _getGradientColor(profile.id).withOpacity(0.6),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                child: Text(
                  profile.name[0].toUpperCase(),
                  style: const TextStyle(
                    color: AppColors.textColor,
                    fontSize: 80,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          // Profile Info
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name and Age
                Row(
                  children: [
                    Text(
                      profile.name,
                      style: const TextStyle(
                        color: AppColors.textColor,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${profile.age}',
                      style: const TextStyle(
                        color: AppColors.textColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (profile.isVerified) ...[
                      const SizedBox(width: 6),
                      const Icon(
                        Icons.verified,
                        color: Color(0xFF2196F3),
                        size: 20,
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                // Title
                Text(
                  profile.title,
                  style: const TextStyle(
                    color: AppColors.textSecondaryColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                // Location
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: AppColors.textSecondaryColor,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      profile.location,
                      style: const TextStyle(
                        color: AppColors.textSecondaryColor,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Bio
                Text(
                  profile.bio,
                  style: const TextStyle(
                    color: AppColors.textColor,
                    fontSize: 14,
                    height: 1.5,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 16),
                // Skills Tags
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: profile.skills.map((skill) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryPurple,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        skill,
                        style: const TextStyle(
                          color: AppColors.textColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                // Followers
                Text(
                  '${profile.followers} Followers',
                  style: const TextStyle(
                    color: AppColors.textSecondaryColor,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 16),
                // Like Button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: onLike,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: AppColors.textSecondaryColor,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    icon: Icon(
                      isLiked ? Icons.favorite : Icons.favorite_border,
                      color: isLiked ? Colors.red : AppColors.textSecondaryColor,
                      size: 20,
                    ),
                    label: Text(
                      isLiked ? 'Liked' : 'Like',
                      style: TextStyle(
                        color: isLiked ? Colors.red : AppColors.textColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
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



