class NotificationModel {
  final String id;
  final String type;
  final String title;
  final String message;
  final String? senderAvatar;
  final String? senderName;
  final DateTime timestamp;
  final bool isRead;
  final String? actionUrl;
  final NotificationCategory category;

  NotificationModel({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    this.senderAvatar,
    this.senderName,
    required this.timestamp,
    this.isRead = false,
    this.actionUrl,
    this.category = NotificationCategory.general,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] ?? '',
      type: json['type'] ?? '',
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      senderAvatar: json['senderAvatar'],
      senderName: json['senderName'],
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
      isRead: json['isRead'] ?? false,
      actionUrl: json['actionUrl'],
      category: NotificationCategory.values.firstWhere(
        (e) => e.toString() == 'NotificationCategory.${json['category']}',
        orElse: () => NotificationCategory.general,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'title': title,
      'message': message,
      'senderAvatar': senderAvatar,
      'senderName': senderName,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
      'actionUrl': actionUrl,
      'category': category.toString().split('.').last,
    };
  }

  NotificationModel copyWith({
    String? id,
    String? type,
    String? title,
    String? message,
    String? senderAvatar,
    String? senderName,
    DateTime? timestamp,
    bool? isRead,
    String? actionUrl,
    NotificationCategory? category,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      message: message ?? this.message,
      senderAvatar: senderAvatar ?? this.senderAvatar,
      senderName: senderName ?? this.senderName,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      actionUrl: actionUrl ?? this.actionUrl,
      category: category ?? this.category,
    );
  }

  String getTimeString() {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${difference.inDays ~/ 7} weeks ago';
    }
  }
}

enum NotificationCategory {
  all,
  unread,
  mentions,
  alerts,
  general,
}



