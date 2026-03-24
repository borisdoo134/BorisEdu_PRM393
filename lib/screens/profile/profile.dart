import 'dart:convert';

import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:myfschools/services/auth_service.dart';
import 'package:myfschools/widgets/bottom_bar.dart';
import 'package:myfschools/widgets/profile/profile.dart';
import 'package:myfschools/models/auth/user_model.dart';
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
  String _parentRole = "Phụ huynh";
  String _parentAvatar = "";
  List<UserModel> _students = [];

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
        _parentRole = prefs.getString('USER_ROLE') ?? "Phụ huynh";
        _parentAvatar = prefs.getString('USER_AVATAR') ?? "";
        
        final String studentsJson = prefs.getString('USER_STUDENTS') ?? '[]';
        try {
          final List<dynamic> parsedJson = jsonDecode(studentsJson);
          _students = parsedJson.map((e) => UserModel.fromJson(e)).toList();
        } catch (_) {
          _students = [];
        }

        if (_parentRole == "Học sinh") {
          final String currentUserJson = prefs.getString('CURRENT_USER_DATA') ?? '{}';
          try {
            final Map<String, dynamic> userMap = jsonDecode(currentUserJson);
            if (userMap.isNotEmpty) {
              _students = [UserModel.fromJson(userMap)];
            }
          } catch (_) {}
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showChangePasswordDialog() {
    final formKey = GlobalKey<FormState>();
    final oldPasswordController = TextEditingController();
    final passwordController = TextEditingController();
    final rePasswordController = TextEditingController();
    bool obscureOldPassword = true;
    bool obscurePassword = true;
    bool obscureRePassword = true;
    bool isLoading = false;
    String? errorMessage;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(ctx).viewInsets.bottom,
              ),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Handle bar
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    const Text(
                      'Đổi mật khẩu',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Mật khẩu phải chứa ít nhất 8 ký tự, bao gồm chữ cái và số.',
                      style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                    ),
                    const SizedBox(height: 20),

                    if (errorMessage != null) ...[
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red.shade200),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.error_outline, color: Colors.red.shade700),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                errorMessage!,
                                style: TextStyle(color: Colors.red.shade700),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    Form(
                      key: formKey,
                      child: Column(
                        children: [
                          // Trường mật khẩu cũ
                          TextFormField(
                            controller: oldPasswordController,
                            obscureText: obscureOldPassword,
                            decoration: InputDecoration(
                              labelText: 'Mật khẩu hiện tại',
                              prefixIcon: const Icon(Icons.lock_person_outlined),
                              suffixIcon: IconButton(
                                icon: Icon(obscureOldPassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined),
                                onPressed: () => setModalState(
                                    () => obscureOldPassword = !obscureOldPassword),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 14),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Vui lòng nhập mật khẩu hiện tại!';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 14),

                          // Trường mật khẩu mới
                          TextFormField(
                            controller: passwordController,
                            obscureText: obscurePassword,
                            decoration: InputDecoration(
                              labelText: 'Mật khẩu mới',
                              prefixIcon: const Icon(Icons.lock_outline),
                              suffixIcon: IconButton(
                                icon: Icon(obscurePassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined),
                                onPressed: () => setModalState(
                                    () => obscurePassword = !obscurePassword),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 14),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Vui lòng nhập mật khẩu!';
                              }
                              final regex = RegExp(
                                  r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');
                              if (!regex.hasMatch(value)) {
                                return 'Ít nhất 8 ký tự, bao gồm chữ cái và số!';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 14),

                          // Trường nhập lại mật khẩu
                          TextFormField(
                            controller: rePasswordController,
                            obscureText: obscureRePassword,
                            decoration: InputDecoration(
                              labelText: 'Nhập lại mật khẩu',
                              prefixIcon: const Icon(Icons.lock_reset_outlined),
                              suffixIcon: IconButton(
                                icon: Icon(obscureRePassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined),
                                onPressed: () => setModalState(
                                    () => obscureRePassword = !obscureRePassword),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 14),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Vui lòng nhập lại mật khẩu!';
                              }
                              if (value != passwordController.text) {
                                return 'Mật khẩu nhập lại không khớp!';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 24),

                          // Nút xác nhận
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: isLoading
                                  ? null
                                  : () async {
                                      if (!formKey.currentState!.validate()) return;

                                      // Capture messenger TRƯỚC khi await để tránh lỗi
                                      // "use BuildContext across async gaps"
                                      final messenger = ScaffoldMessenger.of(context);
                                      final navigator = Navigator.of(context);

                                      setModalState(() {
                                        isLoading = true;
                                        errorMessage = null;
                                      });

                                      final result = await AuthService.changePassword(
                                        oldPasswordController.text,
                                        passwordController.text,
                                        rePasswordController.text,
                                      );

                                      if (!ctx.mounted) return;

                                      if (result['success'] == true) {
                                        // Không gọi setModalState ở đây vì dialog chuẩn bị bị huỷ (pop)
                                        // Gọi setModalState lúc này sẽ gây lỗi rebuild context
                                        navigator.pop(); // Đóng Modal
                                        navigator.pop(2); // Đóng ProfileScreen (trượt về màn hình Home)

                                        messenger.showSnackBar(
                                          SnackBar(
                                            content: Text(result['message'] ?? 'Đổi mật khẩu thành công!'),
                                            backgroundColor: Colors.green,
                                            behavior: SnackBarBehavior.floating,
                                            margin: const EdgeInsets.all(12),
                                          ),
                                        );
                                      } else {
                                        setModalState(() {
                                          isLoading = false;
                                          errorMessage = result['message'] ?? 'Có lỗi xảy ra!';
                                        });
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: isLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text(
                                      'Xác nhận',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    ).whenComplete(() {
      oldPasswordController.dispose();
      passwordController.dispose();
      rePasswordController.dispose();
    });
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
                          _parentRole,
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

              // --- DANH SÁCH CON / THÔNG TIN CHI TIẾT ---
              Text(
                _parentRole == "Học sinh" ? "Thông tin chi tiết" : "Danh sách con",
                style: const TextStyle(
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
                    child: ProfileChildCard(
                      student: student,
                      hidePhone: _parentRole == "Học sinh",
                    ),
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
                onTap: _showChangePasswordDialog,
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
