class UserProfileModel {
  final String id;
  final String name;
  final int age;
  final String title;
  final String location;
  final String bio;
  final String profileImageUrl;
  final List<String> skills;
  final int followers;
  final bool isVerified;

  UserProfileModel({
    required this.id,
    required this.name,
    required this.age,
    required this.title,
    required this.location,
    required this.bio,
    required this.profileImageUrl,
    required this.skills,
    required this.followers,
    this.isVerified = false,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      age: json['age'] ?? 0,
      title: json['title'] ?? '',
      location: json['location'] ?? '',
      bio: json['bio'] ?? '',
      profileImageUrl: json['profileImageUrl'] ?? '',
      skills: (json['skills'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      followers: json['followers'] ?? 0,
      isVerified: json['isVerified'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'title': title,
      'location': location,
      'bio': bio,
      'profileImageUrl': profileImageUrl,
      'skills': skills,
      'followers': followers,
      'isVerified': isVerified,
    };
  }
}


