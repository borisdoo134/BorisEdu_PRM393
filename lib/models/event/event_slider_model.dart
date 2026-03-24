class EventSliderModel {
  final int id;
  final String imageUrl;

  EventSliderModel({
    required this.id,
    required this.imageUrl,
  });

  factory EventSliderModel.fromJson(Map<String, dynamic> json) {
    return EventSliderModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      imageUrl: json['imageUrl'] ?? '',
    );
  }
}
