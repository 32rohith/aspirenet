import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class DailyStreakCard extends StatelessWidget {
  final int streakDays;
  final String message;

  const DailyStreakCard({
    Key? key,
    required this.streakDays,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(
                Icons.local_fire_department,
                color: Colors.orange,
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                'Daily Streak',
                style: TextStyle(
                  color: AppColors.textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Longest Streak 28 Days',
            style: TextStyle(
              color: AppColors.textSecondaryColor,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              '$streakDays',
              style: const TextStyle(
                color: AppColors.textColor,
                fontSize: 64,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: const TextStyle(
              color: AppColors.textSecondaryColor,
              fontSize: 12,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}


