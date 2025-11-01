class TribeModel {
  final String id;
  final String name;
  final String description;
  final String iconUrl;
  final int memberCount;
  final List<String> tags;

  TribeModel({
    required this.id,
    required this.name,
    required this.description,
    required this.iconUrl,
    required this.memberCount,
    required this.tags,
  });

  factory TribeModel.fromJson(Map<String, dynamic> json) {
    return TribeModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      iconUrl: json['iconUrl'] ?? '',
      memberCount: json['memberCount'] ?? 0,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'iconUrl': iconUrl,
      'memberCount': memberCount,
      'tags': tags,
    };
  }
}



