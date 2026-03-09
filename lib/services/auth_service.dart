import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart'; // Import thư viện

class AuthService {
  static String? userName;

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

        // Lấy và xử lý tên người dùng (như đã làm ở trên)
        final userData = responseData['user'] ?? {};
        final firstName = userData['firstName'] ?? '';
        final middleName = userData['middleName'] ?? '';
        final lastName = userData['lastName'] ?? '';

        String fullName = [
          firstName,
          middleName,
          lastName,
        ].where((e) => e.toString().trim().isNotEmpty).join(' ');

        if (fullName.isEmpty) {
          fullName = userData['username'] ?? '';
        }
        userName = fullName.isNotEmpty ? fullName : 'Phụ huynh';

        // ==========================================
        // THỰC HIỆN LƯU TOKEN VÀO BỘ NHỚ MÁY
        // ==========================================
        final prefs = await SharedPreferences.getInstance();

        // Lưu Access Token (để gọi API)
        if (accessToken != null) {
          await prefs.setString('ACCESS_TOKEN', accessToken);
        }

        // Lưu Refresh Token (để xin cấp lại token mới khi token cũ hết hạn)
        if (refreshToken != null) {
          await prefs.setString('REFRESH_TOKEN', refreshToken);
        }

        // Bạn cũng có thể lưu luôn tên để show ra màn hình Home
        await prefs.setString('USER_NAME', userName!);

        print('Đã lưu Token vào SharedPreferences thành công!');
        return true;
      } else {
        print('Đăng nhập thất bại. Mã lỗi: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Không thể kết nối tới máy chủ: $e');
      return false;
    }
  }

  // ==========================================
  // HÀM TIỆN ÍCH: Lấy Token ra để dùng
  // ==========================================
  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(
      'ACCESS_TOKEN',
    ); // Trả về token hoặc null nếu chưa đăng nhập
  }

  // Hàm đăng xuất: Gọi API (GET) và Xóa dữ liệu
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    // 1. Lấy Token ra (Cần cả 2: Access để qua cửa bảo vệ, Refresh để gửi cho hàm logout)
    final String? accessToken = prefs.getString('ACCESS_TOKEN');
    final String? refreshToken = prefs.getString('REFRESH_TOKEN');

    // 2. Gọi API báo cho Backend xóa Refresh Token
    if (refreshToken != null) {
      try {
        // Nối thẳng refresh_token vào URL vì BE dùng @RequestParam
        final String logoutUrl =
            'http://10.0.2.2:8386/api/v1/auth/logout?refresh_token=$refreshToken';

        // Đổi thành http.get vì BE khai báo @GetMapping
        await http.get(
          Uri.parse(logoutUrl),
          headers: {
            'Content-Type': 'application/json',
            // Vẫn nên kẹp Access Token vào Header đề phòng Spring Security chặn không cho gọi API logout
            if (accessToken != null) 'Authorization': 'Bearer $accessToken',
          },
        );
        print('Đã gọi API đăng xuất thành công!');
      } catch (e) {
        // Mất mạng thì cứ ngơ đi, xóa local là được
        print('Lỗi gọi API logout: $e');
      }
    }

    // 3. Quét sạch trí nhớ của App
    await prefs.remove('ACCESS_TOKEN');
    await prefs.remove('REFRESH_TOKEN');
    await prefs.remove('USER_NAME');
    userName = null;

    print('Đã xóa sạch token ở bộ nhớ máy!');
  }
}
