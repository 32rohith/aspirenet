import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../providers/dashboard_provider.dart';
import '../providers/messages_provider.dart';
import '../providers/notifications_provider.dart';
import '../widgets/dashboard/daily_streak_card.dart';
import '../widgets/dashboard/task_completion_chart.dart';
import '../widgets/dashboard/team_performance_chart.dart';
import '../widgets/dashboard/progress_overview_card.dart';
import '../widgets/dashboard/task_card.dart';
import 'discover_screen.dart';
import 'messages_list_screen.dart';
import 'notifications_screen.dart';

class DashboardScreen extends StatefulWidget {
  final bool showBottomNav;
  
  const DashboardScreen({
    Key? key,
    this.showBottomNav = true,
  }) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedBottomNavIndex = 0;
  final PageController _chartPageController = PageController();

  @override
  void dispose() {
    _chartPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dashboardProvider = Provider.of<DashboardProvider>(context);
    final messagesProvider = Provider.of<MessagesProvider>(context);
    final notificationsProvider = Provider.of<NotificationsProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        title: const Text(
          'Dashboard',
          style: TextStyle(
            color: AppColors.textColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.notifications_outlined,
                  color: AppColors.textColor,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NotificationsScreen(),
                    ),
                  );
                },
              ),
              if (notificationsProvider.unreadCount > 0)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Center(
                      child: Text(
                        notificationsProvider.unreadCount > 9
                            ? '9+'
                            : notificationsProvider.unreadCount.toString(),
                        style: const TextStyle(
                          color: AppColors.textColor,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.chat_bubble_outline,
                  color: AppColors.textColor,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MessagesListScreen(),
                    ),
                  );
                },
              ),
              if (messagesProvider.totalUnreadCount > 0)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Center(
                      child: Text(
                        messagesProvider.totalUnreadCount > 9
                            ? '9+'
                            : messagesProvider.totalUnreadCount.toString(),
                        style: const TextStyle(
                          color: AppColors.textColor,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Daily Streak Card
            DailyStreakCard(
              streakDays: dashboardProvider.stats.dailyStreak,
              message: dashboardProvider.stats.streakMessage,
            ),
            const SizedBox(height: 20),
            // Charts Section with PageView
            SizedBox(
              height: 360,
              child: PageView(
                controller: _chartPageController,
                onPageChanged: (index) {
                  dashboardProvider.setSelectedChartIndex(index);
                },
                children: [
                  // Your Task Completion Chart
                  TaskCompletionChart(
                    data: dashboardProvider.taskCompletionData,
                    title: 'Your Task Completion',
                  ),
                  // LeMana's Performance Chart
                  TaskCompletionChart(
                    data: dashboardProvider.taskCompletionData,
                    title: 'LeMana\'s Performance',
                  ),
                  // Team Performance Chart
                  const TeamPerformanceChart(),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Page Indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: dashboardProvider.selectedChartIndex == index ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: dashboardProvider.selectedChartIndex == index
                        ? AppColors.primaryPurple
                        : AppColors.textFieldColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
            const SizedBox(height: 20),
            // Progress Overview
            ProgressOverviewCard(stats: dashboardProvider.stats),
            const SizedBox(height: 24),
            // Tasks Assigned To Me
            const Text(
              'Tasks Assigned To Me',
              style: TextStyle(
                color: AppColors.textColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...dashboardProvider.assignedToMe.map((task) {
              return TaskCard(
                task: task,
                onTap: () {
                  // Handle task tap
                  _showTaskDetails(task);
                },
              );
            }).toList(),
            const SizedBox(height: 24),
            // Tasks Assigned By Me
            const Text(
              'Tasks Assigned By Me',
              style: TextStyle(
                color: AppColors.textColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...dashboardProvider.assignedByMe.map((task) {
              return TaskCard(
                task: task,
                onTap: () {
                  // Handle task tap
                  _showTaskDetails(task);
                },
              );
            }).toList(),
            const SizedBox(height: 20),
            // Score
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: AppColors.cardColor,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Text(
                  'Score: 60',
                  style: TextStyle(
                    color: AppColors.textColor,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomNavigationBar: widget.showBottomNav ? Container(
        decoration: BoxDecoration(
          color: AppColors.cardColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(Icons.home_outlined, 'Home', 0),
                _buildNavItem(Icons.search, 'Search', 1),
                _buildNavItem(Icons.play_circle_outline, 'Play', 2),
                _buildNavItem(Icons.location_on_outlined, 'Deals', 3),
                _buildNavItem(Icons.person_outline, 'Profile', 4),
              ],
            ),
          ),
        ),
      ) : null,
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _selectedBottomNavIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedBottomNavIndex = index;
        });
        
        // Navigate to Discover screen when Search is tapped
        if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const DiscoverScreen(),
            ),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primaryPurple : AppColors.textSecondaryColor,
              size: 24,
            ),
            const SizedBox(height: 4),
            if (isSelected)
              Container(
                width: 4,
                height: 4,
                decoration: const BoxDecoration(
                  color: AppColors.primaryPurple,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showTaskDetails(task) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                task.title,
                style: const TextStyle(
                  color: AppColors.textColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                task.description,
                style: const TextStyle(
                  color: AppColors.textSecondaryColor,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryPurple,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Close',
                    style: TextStyle(
                      color: AppColors.textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

