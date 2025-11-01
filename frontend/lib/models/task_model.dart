class TaskModel {
  final String id;
  final String title;
  final String description;
  final String dueDate;
  final String assignedBy;
  final String assignedTo;
  final String avatarUrl;
  final String status; // 'pending', 'in_progress', 'completed'
  final int progress; // 0-100
  final bool isNew;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.assignedBy,
    required this.assignedTo,
    required this.avatarUrl,
    required this.status,
    required this.progress,
    this.isNew = false,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      dueDate: json['dueDate'] ?? '',
      assignedBy: json['assignedBy'] ?? '',
      assignedTo: json['assignedTo'] ?? '',
      avatarUrl: json['avatarUrl'] ?? '',
      status: json['status'] ?? 'pending',
      progress: json['progress'] ?? 0,
      isNew: json['isNew'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate,
      'assignedBy': assignedBy,
      'assignedTo': assignedTo,
      'avatarUrl': avatarUrl,
      'status': status,
      'progress': progress,
      'isNew': isNew,
    };
  }
}


