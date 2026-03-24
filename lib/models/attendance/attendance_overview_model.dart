class AttendanceOverviewModel {
  final int subjectId;
  final String subjectName;
  final String className;
  final String academicYear;
  final int presentCount;
  final int excusedAbsentCount;
  final int unexcusedAbsentCount;
  final int totalConducted;
  final int percentage;
  final int totalYearSlots;
  final int maxUnexcusedAllowed;
  final bool bannedFromExam;

  AttendanceOverviewModel({
    required this.subjectId,
    required this.subjectName,
    required this.className,
    required this.academicYear,
    required this.presentCount,
    required this.excusedAbsentCount,
    required this.unexcusedAbsentCount,
    required this.totalConducted,
    required this.percentage,
    required this.totalYearSlots,
    required this.maxUnexcusedAllowed,
    required this.bannedFromExam,
  });

  factory AttendanceOverviewModel.fromJson(Map<String, dynamic> json) {
    return AttendanceOverviewModel(
      subjectId: json['subjectId'] ?? 0,
      subjectName: json['subjectName'] ?? '',
      className: json['className'] ?? '',
      academicYear: json['academicYear'] ?? '',
      presentCount: json['presentCount'] ?? 0,
      excusedAbsentCount: json['excusedAbsentCount'] ?? 0,
      unexcusedAbsentCount: json['unexcusedAbsentCount'] ?? 0,
      totalConducted: json['totalConducted'] ?? 0,
      percentage: json['percentage'] ?? 0,
      totalYearSlots: json['totalYearSlots'] ?? 0,
      maxUnexcusedAllowed: json['maxUnexcusedAllowed'] ?? 0,
      bannedFromExam: json['bannedFromExam'] ?? false,
    );
  }
}
