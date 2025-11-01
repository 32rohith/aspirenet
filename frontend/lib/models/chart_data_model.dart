class ChartDataModel {
  final String label;
  final double value;
  final String? category; // For grouped bar charts

  ChartDataModel({
    required this.label,
    required this.value,
    this.category,
  });

  factory ChartDataModel.fromJson(Map<String, dynamic> json) {
    return ChartDataModel(
      label: json['label'] ?? '',
      value: (json['value'] ?? 0).toDouble(),
      category: json['category'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'value': value,
      'category': category,
    };
  }
}


