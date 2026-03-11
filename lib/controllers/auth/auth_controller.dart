import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myfschools/models/auth/user_model.dart';

class AuthController {
  // Biến lưu trữ thông tin User để xài trên giao diện
  static UserModel? currentUser;
  static List<UserModel> userStudents = [];

  static Future<bool> loginUser(String phone, String password) async {
    final String apiUrl = 'http://10.0.2.2:8386/api/v1/auth/login';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'phone': phone, 'password': password}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);

        if (responseBody['status'] == 200 && responseBody['data'] != null) {
          final responseData = responseBody['data'];

          final accessToken = responseData['accessToken'];
          final refreshToken = responseData['refreshToken'];

          final userData = responseData['user'] ?? {};
          
          // Parse ra UserModel
          currentUser = UserModel.fromJson(userData);

          final prefs = await SharedPreferences.getInstance();

          if (accessToken != null) {
            await prefs.setString('ACCESS_TOKEN', accessToken);
          }

          if (refreshToken != null) {
            await prefs.setString('REFRESH_TOKEN', refreshToken);
          }

          final String userRole = currentUser!.isStudent ? "Học sinh" : "Phụ huynh";
          await prefs.setString('USER_ROLE', userRole);

          await prefs.setString('USER_NAME', currentUser!.fullName);
          await prefs.setString('USER_PHONE', phone);
          await prefs.setString('USER_AVATAR', currentUser!.avatarUrl);

          // Lưu danh sách con ra List<UserModel>
          final studentsJson = userData['children'] as List? ?? [];
          userStudents = studentsJson.map((e) => UserModel.fromJson(e)).toList();
          await prefs.setString('USER_STUDENTS', jsonEncode(studentsJson));
          
          // Lưu cả user hiện tại phòng hờ lúc gọi profile
          await prefs.setString('CURRENT_USER_DATA', jsonEncode(userData));

          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('ACCESS_TOKEN');
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    final String? accessToken = prefs.getString('ACCESS_TOKEN');
    final String? refreshToken = prefs.getString('REFRESH_TOKEN');

    if (refreshToken != null) {
      try {
        final String logoutUrl = 'http://10.0.2.2:8386/api/v1/auth/logout?refresh_token=\$refreshToken';
        await http.get(
          Uri.parse(logoutUrl),
          headers: {
            'Content-Type': 'application/json',
            if (accessToken != null) 'Authorization': 'Bearer \$accessToken',
          },
        );
      } catch (_) {
        // Ignored error during logout
      }
    }

    await prefs.remove('ACCESS_TOKEN');
    await prefs.remove('REFRESH_TOKEN');
    await prefs.remove('USER_NAME');
    await prefs.remove('USER_PHONE');
    await prefs.remove('USER_AVATAR');
    await prefs.remove('USER_STUDENTS');
    await prefs.remove('USER_ROLE');
    currentUser = null;
    userStudents.clear();
    await prefs.remove('CURRENT_USER_DATA');
  }
}
