import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:myfschools/models/exam_schedule/exam_schedule_model.dart';
import 'package:myfschools/services/auth_service.dart';

class ExamScheduleService {
  static const String baseUrl = 'http://10.0.2.2:8386/api/v1/exam_schedules';

  static Future<List<ExamScheduleModel>> getExamSchedules(String studentId, {String? academicYear}) async {
    try {
      final token = await AuthService.getAccessToken();
      if (token == null) {
        throw Exception('No access token found');
      }

      String url = '$baseUrl/$studentId';
      if (academicYear != null && academicYear.isNotEmpty && academicYear != 'Tất cả') {
        url += '?academicYear=$academicYear';
      }

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(utf8.decode(response.bodyBytes));
        if (responseData['status'] == 200 && responseData['data'] != null) {
          final List<dynamic> data = responseData['data'];
          return data.map((json) => ExamScheduleModel.fromJson(json)).toList();
        }
      }
      return [];
    } catch (e) {
      print('Error fetching exam schedules: $e');
      return [];
    }
  }
}
