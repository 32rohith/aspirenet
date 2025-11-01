import 'package:flutter/foundation.dart';
import '../models/notification_model.dart';

class NotificationsProvider extends ChangeNotifier {
  List<NotificationModel> _notifications = [];
  NotificationCategory _selectedCategory = NotificationCategory.all;
  bool _isLoading = false;

  // Static data
  final List<NotificationModel> _staticNotifications = [
    NotificationModel(
      id: '1',
      type: 'link_request',
      title: 'New Link Request',
      message: 'You have a new link request from @storytellingbydata.',
      senderName: '@storytellingbydata',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: false,
      category: NotificationCategory.general,
    ),
    NotificationModel(
      id: '2',
      type: 'ambition_progress',
      title: 'Ambition Progress',
      message: 'Your ambition "Launch a Youtube Channel" is 75% complete!',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      isRead: false,
      category: NotificationCategory.alerts,
    ),
    NotificationModel(
      id: '3',
      type: 'collaboration',
      title: 'Collaboration Invite',
      message: 'Emily has accepted your collaboration invite for "Project Nova"',
      senderName: 'Emily',
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      isRead: false,
      category: NotificationCategory.general,
    ),
    NotificationModel(
      id: '4',
      type: 'event_reminder',
      title: 'Event Reminder',
      message: 'Your event "Tech Conference" starts in 2 days',
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      isRead: false,
      category: NotificationCategory.alerts,
    ),
    NotificationModel(
      id: '5',
      type: 'mention',
      title: 'New Mention',
      message: 'Sarah mentioned you in a comment',
      senderName: 'Sarah',
      timestamp: DateTime.now().subtract(const Duration(days: 3)),
      isRead: true,
      category: NotificationCategory.mentions,
    ),
  ];

  // Getters
  List<NotificationModel> get notifications {
    if (_notifications.isEmpty) {
      return _getFilteredNotifications(_staticNotifications);
    }
    return _getFilteredNotifications(_notifications);
  }

  int get unreadCount {
    final allNotifications =
        _notifications.isEmpty ? _staticNotifications : _notifications;
    return allNotifications.where((n) => !n.isRead).length;
  }

  NotificationCategory get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;

  // Filter notifications based on category
  List<NotificationModel> _getFilteredNotifications(
      List<NotificationModel> notifs) {
    switch (_selectedCategory) {
      case NotificationCategory.unread:
        return notifs.where((n) => !n.isRead).toList();
      case NotificationCategory.mentions:
        return notifs
            .where((n) => n.category == NotificationCategory.mentions)
            .toList();
      case NotificationCategory.alerts:
        return notifs
            .where((n) => n.category == NotificationCategory.alerts)
            .toList();
      case NotificationCategory.all:
      default:
        return notifs;
    }
  }

  // Set category
  void setCategory(NotificationCategory category) {
    _selectedCategory = category;
    notifyListeners();
  }

  // Set loading
  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Fetch notifications
  Future<void> fetchNotifications() async {
    setLoading(true);
    try {
      // TODO: Implement API call
      // final response = await http.get(
      //   Uri.parse('YOUR_API_URL/notifications'),
      // );

      await Future.delayed(const Duration(milliseconds: 500));
      _notifications = _staticNotifications;
      notifyListeners();
    } catch (e) {
      // Error fetching notifications
    } finally {
      setLoading(false);
    }
  }

  // Mark notification as read
  Future<void> markAsRead(String notificationId) async {
    try {
      final index = _notifications.indexWhere((n) => n.id == notificationId);
      if (index != -1) {
        _notifications[index] = _notifications[index].copyWith(isRead: true);
        notifyListeners();
      }

      // TODO: Implement API call
      // await http.post(
      //   Uri.parse('YOUR_API_URL/notifications/$notificationId/read'),
      // );
    } catch (e) {
      // Error marking as read
    }
  }

  // Mark all as read
  Future<void> markAllAsRead() async {
    try {
      _notifications = _notifications
          .map((n) => n.copyWith(isRead: true))
          .toList();
      notifyListeners();

      // TODO: Implement API call
      // await http.post(
      //   Uri.parse('YOUR_API_URL/notifications/mark-all-read'),
      // );
    } catch (e) {
      // Error marking all as read
    }
  }

  // Clear all notifications
  Future<void> clearAll() async {
    try {
      _notifications.clear();
      notifyListeners();

      // TODO: Implement API call
      // await http.delete(
      //   Uri.parse('YOUR_API_URL/notifications/clear-all'),
      // );
    } catch (e) {
      // Error clearing notifications
    }
  }

  // Delete notification
  Future<void> deleteNotification(String notificationId) async {
    try {
      _notifications.removeWhere((n) => n.id == notificationId);
      notifyListeners();

      // TODO: Implement API call
      // await http.delete(
      //   Uri.parse('YOUR_API_URL/notifications/$notificationId'),
      // );
    } catch (e) {
      // Error deleting notification
    }
  }
}



