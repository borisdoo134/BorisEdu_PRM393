import 'dart:ui';

class TimetableModel {
  final String id;
  final String timeLabel;
  final String subject;
  final String room;
  final String timeRange;
  final String teacherName;
  final Color backgroundColor;
  final Color accentColor;

  TimetableModel({
    this.id = '',
    this.timeLabel = '',
    this.subject = '',
    this.room = '',
    this.timeRange = '',
    this.teacherName = '',
    this.backgroundColor = const Color(0xFFE8F5E9),
    this.accentColor = const Color(0xFF4CAF50),
  });
}

class WeekDayModel {
  final String dayName;
  final String date;
  bool isActive;

  WeekDayModel({
    required this.dayName,
    required this.date,
    this.isActive = false,
  });
}
