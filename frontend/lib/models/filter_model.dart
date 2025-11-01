class FilterModel {
  final String filterType; // 'people', 'mentors', 'topics', 'tribes'
  final List<String> skills;
  final String location;
  final String projectDomain;
  final int availabilityHours;

  FilterModel({
    this.filterType = 'people',
    this.skills = const [],
    this.location = '',
    this.projectDomain = '',
    this.availabilityHours = 10,
  });

  FilterModel copyWith({
    String? filterType,
    List<String>? skills,
    String? location,
    String? projectDomain,
    int? availabilityHours,
  }) {
    return FilterModel(
      filterType: filterType ?? this.filterType,
      skills: skills ?? this.skills,
      location: location ?? this.location,
      projectDomain: projectDomain ?? this.projectDomain,
      availabilityHours: availabilityHours ?? this.availabilityHours,
    );
  }

  factory FilterModel.fromJson(Map<String, dynamic> json) {
    return FilterModel(
      filterType: json['filterType'] ?? 'people',
      skills: (json['skills'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      location: json['location'] ?? '',
      projectDomain: json['projectDomain'] ?? '',
      availabilityHours: json['availabilityHours'] ?? 10,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'filterType': filterType,
      'skills': skills,
      'location': location,
      'projectDomain': projectDomain,
      'availabilityHours': availabilityHours,
    };
  }

  // Check if any filters are active
  bool get hasActiveFilters {
    return skills.isNotEmpty ||
        location.isNotEmpty ||
        projectDomain.isNotEmpty ||
        availabilityHours != 10;
  }

  // Reset all filters
  FilterModel reset() {
    return FilterModel(
      filterType: filterType,
      skills: [],
      location: '',
      projectDomain: '',
      availabilityHours: 10,
    );
  }
}



