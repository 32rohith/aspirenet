class ConversationModel {
  final String id;
  final String name;
  final String? avatarUrl;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;
  final bool isGroup;
  final List<String> participantIds;
  final List<String> participantNames;
  final bool isOnline;
  final ConversationType type;

  ConversationModel({
    required this.id,
    required this.name,
    this.avatarUrl,
    required this.lastMessage,
    required this.lastMessageTime,
    this.unreadCount = 0,
    this.isGroup = false,
    required this.participantIds,
    required this.participantNames,
    this.isOnline = false,
    this.type = ConversationType.direct,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      avatarUrl: json['avatarUrl'],
      lastMessage: json['lastMessage'] ?? '',
      lastMessageTime: json['lastMessageTime'] != null
          ? DateTime.parse(json['lastMessageTime'])
          : DateTime.now(),
      unreadCount: json['unreadCount'] ?? 0,
      isGroup: json['isGroup'] ?? false,
      participantIds: (json['participantIds'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      participantNames: (json['participantNames'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      isOnline: json['isOnline'] ?? false,
      type: ConversationType.values.firstWhere(
        (e) => e.toString() == 'ConversationType.${json['type']}',
        orElse: () => ConversationType.direct,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatarUrl': avatarUrl,
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime.toIso8601String(),
      'unreadCount': unreadCount,
      'isGroup': isGroup,
      'participantIds': participantIds,
      'participantNames': participantNames,
      'isOnline': isOnline,
      'type': type.toString().split('.').last,
    };
  }

  ConversationModel copyWith({
    String? id,
    String? name,
    String? avatarUrl,
    String? lastMessage,
    DateTime? lastMessageTime,
    int? unreadCount,
    bool? isGroup,
    List<String>? participantIds,
    List<String>? participantNames,
    bool? isOnline,
    ConversationType? type,
  }) {
    return ConversationModel(
      id: id ?? this.id,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      unreadCount: unreadCount ?? this.unreadCount,
      isGroup: isGroup ?? this.isGroup,
      participantIds: participantIds ?? this.participantIds,
      participantNames: participantNames ?? this.participantNames,
      isOnline: isOnline ?? this.isOnline,
      type: type ?? this.type,
    );
  }

  String getTimeString() {
    final now = DateTime.now();
    final difference = now.difference(lastMessageTime);

    if (difference.inDays == 0) {
      // Today - show time
      return '${lastMessageTime.hour}:${lastMessageTime.minute.toString().padLeft(2, '0')} ${lastMessageTime.hour >= 12 ? 'PM' : 'AM'}';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      // Show date
      final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return '${months[lastMessageTime.month - 1]} ${lastMessageTime.day}';
    }
  }
}

enum ConversationType {
  direct,
  group,
  channel,
}

