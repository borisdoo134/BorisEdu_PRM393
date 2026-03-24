import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:myfschools/models/event/event_slider_model.dart';
import 'package:myfschools/models/event/event_detail_model.dart';
import 'package:myfschools/services/auth_service.dart';

class SystemEventService {
  static const String baseUrl = 'http://10.0.2.2:8386/api/v1/events';

  static Future<List<EventSliderModel>> getSliders() async {
    try {
      final token = await AuthService.getAccessToken();
      if (token == null) {
        throw Exception('No access token found');
      }

      final url = '$baseUrl/sliders';
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
          return data.map((json) => EventSliderModel.fromJson(json)).toList();
        }
      }
      return [];
    } catch (e) {
      print('Error fetching sliders: $e');
      return [];
    }
  }

  static Future<EventDetailModel?> getEventDetail(int id) async {
    try {
      final token = await AuthService.getAccessToken();
      if (token == null) {
        throw Exception('No access token found');
      }

      final url = '$baseUrl/$id';
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
          return EventDetailModel.fromJson(responseData['data']);
        }
      }
      return null;
    } catch (e) {
      print('Error fetching event detail: $e');
      return null;
    }
  }
}
