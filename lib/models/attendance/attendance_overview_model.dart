class AttendanceOverviewModel {
  final int subjectId;
  final String subjectName;
  final String className;
  final int presentCount;
  final int absentCount;
  final int totalConducted;
  final int percentage;
  final int totalYearSlots;
  final int maxAbsentAllowed;
  final bool bannedFromExam;

  AttendanceOverviewModel({
    required this.subjectId,
    required this.subjectName,
    required this.className,
    required this.presentCount,
    required this.absentCount,
    required this.totalConducted,
    required this.percentage,
    required this.totalYearSlots,
    required this.maxAbsentAllowed,
    required this.bannedFromExam,
  });

  factory AttendanceOverviewModel.fromJson(Map<String, dynamic> json) {
    return AttendanceOverviewModel(
      subjectId: json['subjectId'] ?? 0,
      subjectName: json['subjectName'] ?? '',
      className: json['className'] ?? '',
      presentCount: json['presentCount'] ?? 0,
      absentCount: json['absentCount'] ?? 0,
      totalConducted: json['totalConducted'] ?? 0,
      percentage: json['percentage'] ?? 0,
      totalYearSlots: json['totalYearSlots'] ?? 0,
      maxAbsentAllowed: json['maxAbsentAllowed'] ?? 0,
      bannedFromExam: json['bannedFromExam'] ?? false,
    );
  }
}
