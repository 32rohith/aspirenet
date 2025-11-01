import 'package:flutter/foundation.dart';
import '../models/task_model.dart';
import '../models/dashboard_stats_model.dart';
import '../models/chart_data_model.dart';

class DashboardProvider extends ChangeNotifier {
  DashboardStatsModel _stats = DashboardStatsModel(
    tasksCompleted: 32,
    activeStreaks: 7,
    collaborations: 12,
    projectsManaged: 4,
    dailyStreak: 12,
    streakMessage: 'Keep up the great work! Lock it daily to maintain your momentum towards success.',
  );

  List<TaskModel> _assignedToMe = [
    TaskModel(
      id: '1',
      title: 'Draft the initial script for the YouTube video',
      description: 'Prepare the most creative script for an AI-based YouTube video around 10 minutes long',
      dueDate: '2024-07-20',
      assignedBy: 'Ben Carter',
      assignedTo: 'Me',
      avatarUrl: '',
      status: 'pending',
      progress: 0,
      isNew: false,
    ),
  ];

  List<TaskModel> _assignedByMe = [
    TaskModel(
      id: '2',
      title: 'Create Marketing Campaign Assets',
      description: 'Design social media graphics, video snippets, and ad copy for the new app launch campaign.',
      dueDate: '2024-07-25',
      assignedBy: 'Me',
      assignedTo: 'Arjun Ganesh',
      avatarUrl: '',
      status: 'in_progress',
      progress: 50,
      isNew: false,
    ),
    TaskModel(
      id: '3',
      title: 'Organize Community Workshop',
      description: 'Plan and coordinate an online workshop for onparing entrepreneurs on the platform.',
      dueDate: '2024-07-30',
      assignedBy: 'Me',
      assignedTo: 'Lekshaa',
      avatarUrl: '',
      status: 'completed',
      progress: 100,
      isNew: true,
    ),
  ];

  List<ChartDataModel> _taskCompletionData = [
    ChartDataModel(label: 'Mon', value: 14, category: 'completed'),
    ChartDataModel(label: 'Mon', value: 8, category: 'pending'),
    ChartDataModel(label: 'Tue', value: 20, category: 'completed'),
    ChartDataModel(label: 'Tue', value: 5, category: 'pending'),
    ChartDataModel(label: 'Wed', value: 18, category: 'completed'),
    ChartDataModel(label: 'Wed', value: 7, category: 'pending'),
    ChartDataModel(label: 'Thu', value: 25, category: 'completed'),
    ChartDataModel(label: 'Thu', value: 3, category: 'pending'),
    ChartDataModel(label: 'Fri', value: 16, category: 'completed'),
    ChartDataModel(label: 'Fri', value: 9, category: 'pending'),
    ChartDataModel(label: 'Sat', value: 12, category: 'completed'),
    ChartDataModel(label: 'Sat', value: 6, category: 'pending'),
  ];

  int _selectedChartIndex = 0;

  // Getters
  DashboardStatsModel get stats => _stats;
  List<TaskModel> get assignedToMe => _assignedToMe;
  List<TaskModel> get assignedByMe => _assignedByMe;
  List<ChartDataModel> get taskCompletionData => _taskCompletionData;
  int get selectedChartIndex => _selectedChartIndex;

  // Methods for future backend integration
  void setStats(DashboardStatsModel stats) {
    _stats = stats;
    notifyListeners();
  }

  void setAssignedToMe(List<TaskModel> tasks) {
    _assignedToMe = tasks;
    notifyListeners();
  }

  void setAssignedByMe(List<TaskModel> tasks) {
    _assignedByMe = tasks;
    notifyListeners();
  }

  void setTaskCompletionData(List<ChartDataModel> data) {
    _taskCompletionData = data;
    notifyListeners();
  }

  void setSelectedChartIndex(int index) {
    _selectedChartIndex = index;
    notifyListeners();
  }

  // Update task status
  void updateTaskStatus(String taskId, String status) {
    final taskIndexToMe = _assignedToMe.indexWhere((task) => task.id == taskId);
    if (taskIndexToMe != -1) {
      _assignedToMe[taskIndexToMe] = TaskModel(
        id: _assignedToMe[taskIndexToMe].id,
        title: _assignedToMe[taskIndexToMe].title,
        description: _assignedToMe[taskIndexToMe].description,
        dueDate: _assignedToMe[taskIndexToMe].dueDate,
        assignedBy: _assignedToMe[taskIndexToMe].assignedBy,
        assignedTo: _assignedToMe[taskIndexToMe].assignedTo,
        avatarUrl: _assignedToMe[taskIndexToMe].avatarUrl,
        status: status,
        progress: _assignedToMe[taskIndexToMe].progress,
        isNew: _assignedToMe[taskIndexToMe].isNew,
      );
      notifyListeners();
      return;
    }

    final taskIndexByMe = _assignedByMe.indexWhere((task) => task.id == taskId);
    if (taskIndexByMe != -1) {
      _assignedByMe[taskIndexByMe] = TaskModel(
        id: _assignedByMe[taskIndexByMe].id,
        title: _assignedByMe[taskIndexByMe].title,
        description: _assignedByMe[taskIndexByMe].description,
        dueDate: _assignedByMe[taskIndexByMe].dueDate,
        assignedBy: _assignedByMe[taskIndexByMe].assignedBy,
        assignedTo: _assignedByMe[taskIndexByMe].assignedTo,
        avatarUrl: _assignedByMe[taskIndexByMe].avatarUrl,
        status: status,
        progress: _assignedByMe[taskIndexByMe].progress,
        isNew: _assignedByMe[taskIndexByMe].isNew,
      );
      notifyListeners();
    }
  }

  // Future method placeholders for backend integration
  Future<void> fetchDashboardData() async {
    // TODO: Implement API call to fetch dashboard data
    // This will replace the static data with dynamic data from backend
  }

  Future<void> fetchTasks() async {
    // TODO: Implement API call to fetch tasks
  }

  Future<void> fetchChartData() async {
    // TODO: Implement API call to fetch chart data
  }
}


