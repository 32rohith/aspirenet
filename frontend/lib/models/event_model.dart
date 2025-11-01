class EventModel {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final DateTime date;
  final String location;
  final List<String> participantAvatars;
  final int participantCount;
  final bool isRegistered;
  final String category;
  final String organizer;

  EventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.date,
    required this.location,
    required this.participantAvatars,
    required this.participantCount,
    this.isRegistered = false,
    this.category = '',
    this.organizer = '',
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      date: json['date'] != null
          ? DateTime.parse(json['date'])
          : DateTime.now(),
      location: json['location'] ?? '',
      participantAvatars: (json['participantAvatars'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      participantCount: json['participantCount'] ?? 0,
      isRegistered: json['isRegistered'] ?? false,
      category: json['category'] ?? '',
      organizer: json['organizer'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'date': date.toIso8601String(),
      'location': location,
      'participantAvatars': participantAvatars,
      'participantCount': participantCount,
      'isRegistered': isRegistered,
      'category': category,
      'organizer': organizer,
    };
  }

  EventModel copyWith({
    String? id,
    String? title,
    String? description,
    String? imageUrl,
    DateTime? date,
    String? location,
    List<String>? participantAvatars,
    int? participantCount,
    bool? isRegistered,
    String? category,
    String? organizer,
  }) {
    return EventModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      date: date ?? this.date,
      location: location ?? this.location,
      participantAvatars: participantAvatars ?? this.participantAvatars,
      participantCount: participantCount ?? this.participantCount,
      isRegistered: isRegistered ?? this.isRegistered,
      category: category ?? this.category,
      organizer: organizer ?? this.organizer,
    );
  }
}



