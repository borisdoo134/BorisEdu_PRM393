import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:myfschools/controllers/auth/auth_controller.dart';
import 'package:myfschools/models/academic/timetable_model.dart';

class ScheduleController {
  static Future<List<TimetableModel>> getTimetableByStudentId(String studentId) async {
    final String apiUrl = 'http://10.0.2.2:8386/api/v1/schedules/timetable/$studentId';
    
    try {
      final token = await AuthController.getAccessToken();
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(utf8.decode(response.bodyBytes));
        
        if (responseBody['status'] == 200 && responseBody['data'] != null) {
          final List<dynamic> schedulesJson = responseBody['data'];
          
          final List<Color> bgColors = [
            const Color(0xFFE8F5E9),
            const Color(0xFFE1F5FE),
            const Color(0xFFFFF3E0),
            const Color(0xFFFCE4EC),
            const Color(0xFFF3E5F5),
          ];
          
          final List<Color> accColors = [
            const Color(0xFF4CAF50),
            const Color(0xFF03A9F4),
            const Color(0xFFFF9800),
            const Color(0xFFE91E63),
            const Color(0xFF9C27B0),
          ];

          return schedulesJson.asMap().entries.map((entry) {
            int index = entry.key;
            var json = entry.value;
            
            String startTime = json['startTime']?.toString() ?? '00:00:00';
            String endTime = json['endTime']?.toString() ?? '00:00:00';
            
            String startShort = startTime.split(':').sublist(0, 2).join(':');
            String endShort = endTime.split(':').sublist(0, 2).join(':');

            return TimetableModel(
              id: json['id']?.toString() ?? '',
              timeLabel: startShort,
              subject: json['subjectName']?.toString() ?? '',
              room: json['room']?.toString() ?? 'Chưa xếp phòng',
              dayOfWeek: json['dayOfWeek']?.toString() ?? '',
              timeRange: '$startShort - $endShort',
              teacherId: json['teacherId'] as int? ?? 0,
              teacherName: json['teacherName']?.toString() ?? '',
              teacherAvatar: json['teacherAvatar']?.toString() ?? '',
              actualDate: json['actualDate']?.toString() ?? '',
              month: json['month'] as int? ?? 0,
              year: json['year'] as int? ?? 0,
              weekOfYear: json['weekOfYear'] as int? ?? 0,
              backgroundColor: bgColors[index % bgColors.length],
              accentColor: accColors[index % accColors.length],
            );
          }).toList();
        }
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}
