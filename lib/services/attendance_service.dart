import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:myfschools/models/attendance/attendance_overview_model.dart';
import 'package:myfschools/models/attendance/attendance_detail_model.dart';
import 'package:myfschools/services/auth_service.dart';

class AttendanceService {
  static const String baseUrl = 'http://10.0.2.2:8386/api/v1/attendances';

  static Future<List<AttendanceOverviewModel>> getAttendanceOverview(String studentId) async {
    try {
      final token = await AuthService.getAccessToken();
      if (token == null) {
        throw Exception('No access token found');
      }

      final url = '$baseUrl/$studentId';
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
          return data.map((json) => AttendanceOverviewModel.fromJson(json)).toList();
        }
      }
      return [];
    } catch (e) {
      print('Error fetching attendance overview: $e');
      return [];
    }
  }

  static Future<AttendanceDetailResponse?> getAttendanceDetail(String studentId, int subjectId) async {
    try {
      final token = await AuthService.getAccessToken();
      if (token == null) {
        throw Exception('No access token found');
      }

      final url = '$baseUrl/detail/$studentId/subjects/$subjectId';
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
          return AttendanceDetailResponse.fromJson(responseData['data']);
        }
      }
      return null;
    } catch (e) {
      print('Error fetching attendance detail: $e');
      return null;
    }
  }
}
