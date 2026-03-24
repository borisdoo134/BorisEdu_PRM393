class EventDetailModel {
  final int id;
  final String title;
  final String imageUrl;
  final String content;
  final DateTime? startDate;
  final DateTime? endDate;
  final String targetAudience;
  final String termsAndConditions;
  final DateTime? createdAt;

  EventDetailModel({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.content,
    this.startDate,
    this.endDate,
    required this.targetAudience,
    required this.termsAndConditions,
    this.createdAt,
  });

  factory EventDetailModel.fromJson(Map<String, dynamic> json) {
    return EventDetailModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      title: json['title'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      content: json['content'] ?? '',
      startDate: json['startDate'] != null ? DateTime.tryParse(json['startDate']) : null,
      endDate: json['endDate'] != null ? DateTime.tryParse(json['endDate']) : null,
      targetAudience: json['targetAudience'] ?? '',
      termsAndConditions: json['termsAndConditions'] ?? '',
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
    );
  }
}
