class AttendanceRecordDto {
  final String date;
  final String teacherName;
  final int period;
  final String status;

  AttendanceRecordDto({
    required this.date,
    required this.teacherName,
    required this.period,
    required this.status,
  });

  factory AttendanceRecordDto.fromJson(Map<String, dynamic> json) {
    return AttendanceRecordDto(
      date: json['date'] ?? '',
      teacherName: json['teacherName'] ?? '',
      period: json['period'] ?? 0,
      status: json['status'] ?? '',
    );
  }
}

class AttendanceDetailResponse {
  final String subjectName;
  final String className;
  final int percentage;
  final int presentCount;
  final int absentCount;
  final int futureCount;
  final int totalYearSlots;
  final int maxAbsentAllowed;
  final bool bannedFromExam;
  final List<AttendanceRecordDto> records;

  AttendanceDetailResponse({
    required this.subjectName,
    required this.className,
    required this.percentage,
    required this.presentCount,
    required this.absentCount,
    required this.futureCount,
    required this.totalYearSlots,
    required this.maxAbsentAllowed,
    required this.bannedFromExam,
    required this.records,
  });

  factory AttendanceDetailResponse.fromJson(Map<String, dynamic> json) {
    var list = json['records'] as List? ?? [];
    List<AttendanceRecordDto> recordsList =
        list.map((i) => AttendanceRecordDto.fromJson(i)).toList();

    return AttendanceDetailResponse(
      subjectName: json['subjectName'] ?? '',
      className: json['className'] ?? '',
      percentage: json['percentage'] ?? 0,
      presentCount: json['presentCount'] ?? 0,
      absentCount: json['absentCount'] ?? 0,
      futureCount: json['futureCount'] ?? 0,
      totalYearSlots: json['totalYearSlots'] ?? 0,
      maxAbsentAllowed: json['maxAbsentAllowed'] ?? 0,
      bannedFromExam: json['bannedFromExam'] ?? false,
      records: recordsList,
    );
  }
}
