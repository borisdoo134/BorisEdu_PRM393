import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:myfschools/models/student/leave_request_history_model.dart';
import 'package:myfschools/services/auth_service.dart';

class LeaveRequestService {
  static const String baseUrl = 'http://10.0.2.2:8386/api/v1/leave-requests';

  static Future<List<LeaveRequestHistoryResponse>> getLeaveRequestHistory(String parentId, String studentId) async {
    try {
      final token = await AuthService.getAccessToken();
      if (token == null) {
        throw Exception('No access token found');
      }

      final url = '$baseUrl/parents/$parentId/students/$studentId';
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
          return data.map((json) => LeaveRequestHistoryResponse.fromJson(json)).toList();
        }
      }
      return [];
    } catch (e) {
      print('Error fetching leave request history: $e');
      return [];
    }
  }

  static Future<bool> createLeaveRequest({
    required String parentId,
    required String studentId,
    required DateTime fromDate,
    required DateTime toDate,
    required String reason,
  }) async {
    try {
      final token = await AuthService.getAccessToken();
      if (token == null) {
        throw Exception('No access token found');
      }

      final url = '$baseUrl/parents/$parentId';
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'studentId': int.tryParse(studentId) ?? 0,
          'fromDate': fromDate.toIso8601String().split('T')[0],
          'toDate': toDate.toIso8601String().split('T')[0],
          'reason': reason,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        print('Error creating leave request: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('Exception creating leave request: $e');
      return false;
    }
  }
}
