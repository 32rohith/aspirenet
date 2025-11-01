class UserProfileExtended {
  final String id;
  final String name;
  final String username;
  final String bio;
  final String avatarUrl;
  final bool isOnline;
  final String ambitionTitle;
  final String ambitionDescription;
  final String passionDescription;
  final List<String> skills;
  final int connectionsCount;
  final int projectsCount;
  final int eventsCount;

  UserProfileExtended({
    required this.id,
    required this.name,
    required this.username,
    required this.bio,
    required this.avatarUrl,
    this.isOnline = false,
    required this.ambitionTitle,
    required this.ambitionDescription,
    required this.passionDescription,
    required this.skills,
    this.connectionsCount = 0,
    this.projectsCount = 0,
    this.eventsCount = 0,
  });

  factory UserProfileExtended.fromJson(Map<String, dynamic> json) {
    return UserProfileExtended(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      username: json['username'] ?? '',
      bio: json['bio'] ?? '',
      avatarUrl: json['avatarUrl'] ?? '',
      isOnline: json['isOnline'] ?? false,
      ambitionTitle: json['ambitionTitle'] ?? '',
      ambitionDescription: json['ambitionDescription'] ?? '',
      passionDescription: json['passionDescription'] ?? '',
      skills: (json['skills'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      connectionsCount: json['connectionsCount'] ?? 0,
      projectsCount: json['projectsCount'] ?? 0,
      eventsCount: json['eventsCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'bio': bio,
      'avatarUrl': avatarUrl,
      'isOnline': isOnline,
      'ambitionTitle': ambitionTitle,
      'ambitionDescription': ambitionDescription,
      'passionDescription': passionDescription,
      'skills': skills,
      'connectionsCount': connectionsCount,
      'projectsCount': projectsCount,
      'eventsCount': eventsCount,
    };
  }

  UserProfileExtended copyWith({
    String? id,
    String? name,
    String? username,
    String? bio,
    String? avatarUrl,
    bool? isOnline,
    String? ambitionTitle,
    String? ambitionDescription,
    String? passionDescription,
    List<String>? skills,
    int? connectionsCount,
    int? projectsCount,
    int? eventsCount,
  }) {
    return UserProfileExtended(
      id: id ?? this.id,
      name: name ?? this.name,
      username: username ?? this.username,
      bio: bio ?? this.bio,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isOnline: isOnline ?? this.isOnline,
      ambitionTitle: ambitionTitle ?? this.ambitionTitle,
      ambitionDescription: ambitionDescription ?? this.ambitionDescription,
      passionDescription: passionDescription ?? this.passionDescription,
      skills: skills ?? this.skills,
      connectionsCount: connectionsCount ?? this.connectionsCount,
      projectsCount: projectsCount ?? this.projectsCount,
      eventsCount: eventsCount ?? this.eventsCount,
    );
  }
}



