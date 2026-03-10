import 'dart:ui';

class TimetableModel {
  final String id;
  final String timeLabel;
  final String subject;
  final String room;
  final String timeRange;
  final int teacherId;
  final String teacherName;
  final String teacherAvatar;
  final String dayOfWeek;
  final String actualDate;
  final int month;
  final int year;
  final int weekOfYear;
  final Color backgroundColor;
  final Color accentColor;

  TimetableModel({
    this.id = '',
    this.timeLabel = '',
    this.subject = '',
    this.room = '',
    this.timeRange = '',
    this.teacherId = 0,
    this.teacherName = '',
    this.teacherAvatar = '',
    this.dayOfWeek = '',
    this.actualDate = '',
    this.month = 0,
    this.year = 0,
    this.weekOfYear = 0,
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
