class ExamScheduleModel {
  final int id;
  final String subjectName;
  final String examType;
  final String examDate;
  final String startTime;
  final String endTime;
  final String room;
  final String status;
  final String academicYear;

  ExamScheduleModel({
    required this.id,
    required this.subjectName,
    required this.examType,
    required this.examDate,
    required this.startTime,
    required this.endTime,
    required this.room,
    required this.status,
    required this.academicYear,
  });

  factory ExamScheduleModel.fromJson(Map<String, dynamic> json) {
    return ExamScheduleModel(
      id: json['id'] ?? 0,
      subjectName: json['subjectName'] ?? '',
      examType: json['examType'] ?? '',
      examDate: json['examDate'] ?? '',
      startTime: json['startTime'] ?? '',
      endTime: json['endTime'] ?? '',
      room: json['room'] ?? '',
      status: json['status'] ?? '',
      academicYear: json['academicYear'] ?? '',
    );
  }
}
