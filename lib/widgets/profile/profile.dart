import 'package:flutter/material.dart';
import 'package:myfschools/screens/login.dart';

class ProfileChildCard extends StatefulWidget {
  final Map<String, dynamic> student;

  const ProfileChildCard({
    super.key,
    required this.student,
  });

  @override
  State<ProfileChildCard> createState() => _ProfileChildCardState();
}

class _ProfileChildCardState extends State<ProfileChildCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final student = widget.student;

    final String firstName = student['firstName'] ?? '';
    final String middleName = student['middleName'] ?? '';
    final String lastName = student['lastName'] ?? '';
    final String name = [firstName, middleName, lastName].where((e) => e.trim().isNotEmpty).join(' ').trim();
    final String displayName = name.isEmpty ? "Chưa có tên" : name;

    final String className = student['className'] ?? '';
    final String schoolName = student['schoolName'] ?? '';
    final String subtitle = "$className - $schoolName";
    final String shortSubtitle = className;

    final String rawStatus = student['status'] ?? '';
    final String status = rawStatus == "LEARNING" ? "Đang học" : rawStatus;

    final String avatarUrl = student['avatarUrl'] ?? '';

    // Advanced details
    final String dateOfBirth = student['dateOfBirth'] ?? '';
    String formattedDob = dateOfBirth;
    if (dateOfBirth.isNotEmpty) {
      try {
        final DateTime parsedDate = DateTime.parse(dateOfBirth);
        formattedDob = "${parsedDate.day.toString().padLeft(2, '0')}/${parsedDate.month.toString().padLeft(2, '0')}/${parsedDate.year}";
      } catch (_) {}
    }

    final String address = student['address'] ?? 'Không có';
    final String rawGender = student['gender'] ?? '';
    String gender = rawGender == 'MALE' ? 'Nam' : (rawGender == 'FEMALE' ? 'Nữ' : 'Khác');
    final String phone = student['phone'] ?? 'Không có';
    final String fatherName = student['fatherName'] ?? 'Không có';
    final String motherName = student['motherName'] ?? 'Không có';

    return GestureDetector(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.shade200,
                  ),
                  child: avatarUrl.isNotEmpty && avatarUrl.startsWith('http')
                      ? Image.network(
                          avatarUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (ctx, _, stackTrace) =>
                              const Icon(Icons.person, color: Colors.grey),
                        )
                      : Image.asset(
                          'assets/avatars/child.png',
                          fit: BoxFit.cover,
                          errorBuilder: (ctx, _, stackTrace) =>
                              const Icon(Icons.person, color: Colors.grey),
                        ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        displayName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      RichText(
                        text: TextSpan(
                          text: "$subtitle • ",
                          style: TextStyle(
                              fontSize: 12, color: Colors.grey.shade600),
                          children: [
                            TextSpan(
                              text: status,
                              style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  _isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Colors.grey.shade600,
                ),
              ],
            ),
            if (_isExpanded) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F7F7),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  children: [
                    _buildDetailRow("Họ và Tên :", displayName),
                    _buildDetailRow("Lớp :", shortSubtitle),
                    _buildDetailRow("Ngày sinh :", formattedDob),
                    _buildDetailRow("Địa chỉ :", address),
                    _buildDetailRow("Giới tính :", gender),
                    _buildDetailRow("Số điện thoại:", phone),
                    _buildDetailRow("Tên bố:", fatherName),
                    _buildDetailRow("Tên mẹ:", motherName),
                    _buildDetailRow("Tình trạng:", status),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileSettingItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color titleColor;
  final Color iconColor;
  final Widget? trailing;
  final VoidCallback onTap;

  const ProfileSettingItem({
    super.key,
    required this.icon,
    required this.title,
    this.titleColor = Colors.black87,
    this.iconColor = Colors.grey,
    this.trailing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: iconColor, size: 28),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: titleColor,
        ),
      ),
      trailing: trailing,
      onTap: onTap,
    );
  }
}

void showLogoutConfirmationDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext ctx) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text("Đăng xuất"),
        content: const Text("Bạn có chắc chắn muốn đăng xuất?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("Hủy", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Navigator.of(ctx).pop(); // Đóng dialog
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Đã đăng xuất thành công')),
              );

              // Chuyển hướng về LoginScreen và xóa toàn bộ ngăn xếp Navigation
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (Route<dynamic> route) => false,
              );
            },
            child: const Text(
              "Đăng xuất",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      );
    },
  );
}
