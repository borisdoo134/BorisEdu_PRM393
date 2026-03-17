class ScoreRecordDto {
  final int id;
  final String scoreTypeName;
  final String scoreTypeCode;
  final int coefficient;
  final double scoreValue;
  final String? description;
  final String entryDate;
  final int semester;

  ScoreRecordDto({
    required this.id,
    required this.scoreTypeName,
    required this.scoreTypeCode,
    required this.coefficient,
    required this.scoreValue,
    this.description,
    required this.entryDate,
    required this.semester,
  });

  factory ScoreRecordDto.fromJson(Map<String, dynamic> json) {
    return ScoreRecordDto(
      id: json['id'] ?? 0,
      scoreTypeName: json['scoreTypeName'] ?? '',
      scoreTypeCode: json['scoreTypeCode'] ?? '',
      coefficient: json['coefficient'] ?? 1,
      scoreValue: (json['scoreValue'] as num?)?.toDouble() ?? 0.0,
      description: json['description'],
      entryDate: json['entryDate'] ?? '',
      semester: json['semester'] ?? 1,
    );
  }
}

class ScoreDetailResponse {
  final String subjectName;
  final double averageScore;
  final List<ScoreRecordDto> records;

  ScoreDetailResponse({
    required this.subjectName,
    required this.averageScore,
    required this.records,
  });

  factory ScoreDetailResponse.fromJson(Map<String, dynamic> json) {
    return ScoreDetailResponse(
      subjectName: json['subjectName'] ?? '',
      averageScore: (json['averageScore'] as num?)?.toDouble() ?? 0.0,
      records: (json['records'] as List<dynamic>?)
              ?.map((e) => ScoreRecordDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
