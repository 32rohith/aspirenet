class DashboardStatsModel {
  final int tasksCompleted;
  final int activeStreaks;
  final int collaborations;
  final int projectsManaged;
  final int dailyStreak;
  final String streakMessage;

  DashboardStatsModel({
    required this.tasksCompleted,
    required this.activeStreaks,
    required this.collaborations,
    required this.projectsManaged,
    required this.dailyStreak,
    required this.streakMessage,
  });

  factory DashboardStatsModel.fromJson(Map<String, dynamic> json) {
    return DashboardStatsModel(
      tasksCompleted: json['tasksCompleted'] ?? 0,
      activeStreaks: json['activeStreaks'] ?? 0,
      collaborations: json['collaborations'] ?? 0,
      projectsManaged: json['projectsManaged'] ?? 0,
      dailyStreak: json['dailyStreak'] ?? 0,
      streakMessage: json['streakMessage'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tasksCompleted': tasksCompleted,
      'activeStreaks': activeStreaks,
      'collaborations': collaborations,
      'projectsManaged': projectsManaged,
      'dailyStreak': dailyStreak,
      'streakMessage': streakMessage,
    };
  }
}


