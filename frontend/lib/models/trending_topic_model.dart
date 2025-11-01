class TrendingTopicModel {
  final String id;
  final String title;
  final String description;
  final String iconUrl;
  final List<String> tags;

  TrendingTopicModel({
    required this.id,
    required this.title,
    required this.description,
    required this.iconUrl,
    required this.tags,
  });

  factory TrendingTopicModel.fromJson(Map<String, dynamic> json) {
    return TrendingTopicModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      iconUrl: json['iconUrl'] ?? '',
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'iconUrl': iconUrl,
      'tags': tags,
    };
  }
}



