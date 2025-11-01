import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../models/chart_data_model.dart';

class TaskCompletionChart extends StatelessWidget {
  final List<ChartDataModel> data;
  final String title;

  const TaskCompletionChart({
    Key? key,
    required this.data,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Group data by day
    final Map<String, List<ChartDataModel>> groupedData = {};
    for (var item in data) {
      if (!groupedData.containsKey(item.label)) {
        groupedData[item.label] = [];
      }
      groupedData[item.label]!.add(item);
    }

    final days = groupedData.keys.toList();
    final maxValue = data.map((e) => e.value).reduce((a, b) => a > b ? a : b);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          // Chart
          SizedBox(
            height: 200,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: days.map((day) {
                final dayData = groupedData[day]!;
                final completed = dayData.firstWhere(
                  (e) => e.category == 'completed',
                  orElse: () => ChartDataModel(label: day, value: 0),
                ).value;
                final pending = dayData.firstWhere(
                  (e) => e.category == 'pending',
                  orElse: () => ChartDataModel(label: day, value: 0),
                ).value;

                return _buildBar(day, completed, pending, maxValue);
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegend(const Color(0xFF4CAF50), 'Completed'),
              const SizedBox(width: 16),
              _buildLegend(const Color(0xFF9B7FBD), 'Pending'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBar(String day, double completed, double pending, double maxValue) {
    final completedHeight = (completed / maxValue) * 180;
    final pendingHeight = (pending / maxValue) * 180;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          width: 24,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (completed > 0)
                Container(
                  width: 24,
                  height: completedHeight,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4CAF50),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(4),
                    ),
                  ),
                ),
              const SizedBox(height: 2),
              if (pending > 0)
                Container(
                  width: 24,
                  height: pendingHeight,
                  decoration: BoxDecoration(
                    color: const Color(0xFF9B7FBD),
                    borderRadius: BorderRadius.vertical(
                      top: completed > 0 ? Radius.zero : const Radius.circular(4),
                      bottom: const Radius.circular(4),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          day,
          style: const TextStyle(
            color: AppColors.textSecondaryColor,
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildLegend(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondaryColor,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}


