import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myfschools/models/auth/user_model.dart';
import 'package:myfschools/models/student/student_model.dart';

class AuthController {
  // Biến lưu trữ thông tin User để xài trên giao diện
  static UserModel? currentUser;
  static List<StudentModel> userStudents = [];

  static Future<bool> loginUser(String phone, String password) async {
    final String apiUrl = 'http://10.0.2.2:8386/api/v1/auth/login';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'phone': phone, 'password': password}),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

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

        await prefs.setString('USER_NAME', currentUser!.fullName);
        await prefs.setString('USER_PHONE', phone);

        // Lưu danh sách con ra List<StudentModel>
        final studentsJson = userData['students'] as List? ?? [];
        userStudents = studentsJson.map((e) => StudentModel.fromJson(e)).toList();
        await prefs.setString('USER_STUDENTS', jsonEncode(studentsJson));

        print('Đã lưu Token và thông tin User thành công!');
        return true;
      } else {
        print('Đăng nhập thất bại. Mã lỗi: \${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Không thể kết nối tới máy chủ: \$e');
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
        print('Đã gọi API đăng xuất thành công!');
      } catch (e) {
        print('Lỗi gọi API logout: \$e');
      }
    }

    await prefs.remove('ACCESS_TOKEN');
    await prefs.remove('REFRESH_TOKEN');
    await prefs.remove('USER_NAME');
    await prefs.remove('USER_PHONE');
    await prefs.remove('USER_STUDENTS');
    currentUser = null;
    userStudents.clear();

    print('Đã xóa sạch token ở bộ nhớ máy!');
  }
}
