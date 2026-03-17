class ScoreOverviewResponse {
  final int subjectId;
  final String subjectName;
  final String className;
  final double averageScore;

  ScoreOverviewResponse({
    required this.subjectId,
    required this.subjectName,
    required this.className,
    required this.averageScore,
  });

  factory ScoreOverviewResponse.fromJson(Map<String, dynamic> json) {
    return ScoreOverviewResponse(
      subjectId: json['subjectId'] ?? 0,
      subjectName: json['subjectName'] ?? '',
      className: json['className'] ?? '',
      averageScore: (json['averageScore'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
