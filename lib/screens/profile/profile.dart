import 'dart:convert';

import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:myfschools/widgets/bottom_bar.dart';
import 'package:myfschools/widgets/profile/profile.dart';
import 'package:myfschools/models/student/student_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final Color primaryColor = const Color(0xFF43A047);
  bool _isBiometricEnabled = true;

  String _parentName = "Đang tải...";
  String _parentPhone = "Đang tải...";
  String _parentAvatar = "";
  List<StudentModel> _students = [];

  final NotchBottomBarController _controller = NotchBottomBarController(
    index: 2,
  );

  @override
  void initState() {
    super.initState();
    _loadParentInfo();
  }

  Future<void> _loadParentInfo() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _parentName = prefs.getString('USER_NAME') ?? "Phụ huynh";
        _parentPhone = prefs.getString('USER_PHONE') ?? "Không có số điện thoại";
        _parentAvatar = prefs.getString('USER_AVATAR') ?? "";
        
        final String studentsJson = prefs.getString('USER_STUDENTS') ?? '[]';
        try {
          final List<dynamic> parsedJson = jsonDecode(studentsJson);
          _students = parsedJson.map((e) => StudentModel.fromJson(e)).toList();
        } catch (_) {
          _students = [];
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        title: const Text(
          "Hồ Sơ",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        backgroundColor: primaryColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(35)),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(
            left: 24,
            right: 24,
            top: 30,
            bottom: 100, // Tăng lên khoảng 100 để tránh BottomBar
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- THÔNG TIN PHỤ HUYNH ---
              Row(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    clipBehavior: Clip.antiAlias,
                    decoration: const BoxDecoration(shape: BoxShape.circle),
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Positioned.fill(
                          child: _parentAvatar.isNotEmpty && _parentAvatar.startsWith('http')
                              ? Image.network(
                                  _parentAvatar,
                                  fit: BoxFit.cover,
                                  errorBuilder: (ctx, err, stackTrace) => Image.asset(
                                    'assets/avatars/phu_huynh.png',
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Image.asset(
                                  'assets/avatars/phu_huynh.png',
                                  fit: BoxFit.cover,
                                ),
                        ),
                        Container(
                          width: double.infinity,
                          height: 25,
                          color: Colors.black.withValues(alpha: 0.5),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                _parentName,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.edit_square,
                              color: Colors.grey.shade600,
                              size: 20,
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Phụ huynh",
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _parentPhone,
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // --- DANH SÁCH CON ---
              const Text(
                "Danh sách con",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),

              if (_students.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Text(
                    "Không có dữ liệu học sinh",
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                )
              else
                ..._students.map((student) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: ProfileChildCard(student: student),
                  );
                }),

              const SizedBox(height: 30),

              // --- CÀI ĐẶT & TIỆN ÍCH ---
              const Text(
                "Cài đặt & Tiện ích",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 12),

              ProfileSettingItem(
                icon: Icons.notifications_none,
                title: "Cài đặt thông báo",
                onTap: () {},
              ),
              ProfileSettingItem(
                icon: Icons.lock_outline,
                title: "Đổi mật khẩu",
                onTap: () {},
              ),
              ProfileSettingItem(
                icon: Icons.fingerprint,
                title: "Xác thực sinh trắc học\n(Vân tay/FaceID)",
                trailing: Switch(
                  value: _isBiometricEnabled,
                  onChanged: (val) {
                    setState(() {
                      _isBiometricEnabled = val;
                    });
                  },
                  activeThumbColor: Colors.white,
                  activeTrackColor: primaryColor,
                ),
                onTap: () {
                  setState(() {
                    _isBiometricEnabled = !_isBiometricEnabled;
                  });
                },
              ),
              ProfileSettingItem(
                icon: Icons.logout,
                title: "Đăng xuất",
                titleColor: Colors.red,
                iconColor: Colors.red,
                onTap: () {
                  showLogoutConfirmationDialog(context);
                },
              ),

              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
      // --- BOTTOM BAR ---
      extendBody: true,
      bottomNavigationBar: MovingBottomBar(
        controller: _controller,
        onTap: (index) {
          if (index == 2) return;
          Navigator.pop(context, index); // Trở về trang trước và kèm theo index
        },
      ),
    );
  }
}
