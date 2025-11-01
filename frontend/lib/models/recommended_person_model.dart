class RecommendedPersonModel {
  final String id;
  final String name;
  final String description;
  final String profileImageUrl;
  final bool isVerified;

  RecommendedPersonModel({
    required this.id,
    required this.name,
    required this.description,
    required this.profileImageUrl,
    this.isVerified = false,
  });

  factory RecommendedPersonModel.fromJson(Map<String, dynamic> json) {
    return RecommendedPersonModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      profileImageUrl: json['profileImageUrl'] ?? '',
      isVerified: json['isVerified'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'profileImageUrl': profileImageUrl,
      'isVerified': isVerified,
    };
  }
}



