import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:myfschools/models/academic/score_overview_response.dart';
import 'package:myfschools/models/academic/score_detail_response.dart';
import 'package:myfschools/services/auth_service.dart';

class ScoreService {
  static const String baseUrl = 'http://10.0.2.2:8386/api/v1/scores';

  static Future<List<ScoreOverviewResponse>> getScoreOverview(
      String studentId, String academicYear, {String? semester}) async {
    try {
      final token = await AuthService.getAccessToken();
      if (token == null) {
        throw Exception('No access token found');
      }

      String url = '$baseUrl/$studentId?academicYear=$academicYear';
      // In Backend, semester is Integer, if valid, append
      if (semester != null && semester.isNotEmpty && semester != 'Cả năm') {
        url += '&semester=$semester';
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
          return data.map((json) => ScoreOverviewResponse.fromJson(json)).toList();
        }
      }
      return [];
    } catch (e) {
      print('Error fetching score overview: $e');
      return [];
    }
  }

  static Future<ScoreDetailResponse?> getScoreDetail(
      String studentId, int subjectId, String academicYear, {String? semester}) async {
    try {
      final token = await AuthService.getAccessToken();
      if (token == null) {
        throw Exception('No access token found');
      }

      String url = '$baseUrl/$studentId/subjects/$subjectId?academicYear=$academicYear';
      if (semester != null && semester.isNotEmpty && semester != 'Cả năm') {
        url += '&semester=$semester';
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
           return ScoreDetailResponse.fromJson(responseData['data']);
        }
      }
      return null;
    } catch (e) {
      print('Error fetching score detail: $e');
      return null;
    }
  }
}
