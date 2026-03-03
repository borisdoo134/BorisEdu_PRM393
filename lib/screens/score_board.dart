import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:myfschools/widgets/bottom_bar.dart';

class ScoreBoardScreen extends StatefulWidget {
  const ScoreBoardScreen({super.key});

  @override
  State<ScoreBoardScreen> createState() => _ScoreBoardScreenState();
}

class _ScoreBoardScreenState extends State<ScoreBoardScreen> {
  // --- DỮ LIỆU MÔ PHỎNG THEO ẢNH ---
  final List<String> _years = ['2020', '2021', '2022'];
  final List<String> _semesters = ['1', '2'];

  final List<SubjectItem> _subjects = [
    SubjectItem(
      id: 'TOAN1',
      name: 'Toán Học',
      icon: Icons.calculate,
      iconColor: Colors.green,
      averageScore: 9.5,
      className: '12A9',
    ),
    SubjectItem(
      id: 'VAN',
      name: 'Ngữ Văn',
      icon: Icons.menu_book,
      iconColor: Colors.blue,
      averageScore: 8.0,
      className: '12A9',
    ),
    SubjectItem(
      id: 'ANH',
      name: 'Tiếng Anh',
      icon: Icons.language,
      iconColor: Colors.pink,
      averageScore: 9.5,
      className: '12A9',
    ),
    SubjectItem(
      id: 'KHOA',
      name: 'Khoa Học',
      icon: Icons.science,
      iconColor: Colors.green,
      averageScore: 9.5,
      className: '12A9',
    ),
    SubjectItem(
      id: 'NHAC',
      name: 'Âm Nhạc',
      icon: Icons.library_music,
      iconColor: Colors.green,
      averageScore: 9.5,
      className: '12A9',
    ),
    SubjectItem(
      id: 'TOAN2',
      name: 'Toán học',
      icon: Icons.calculate,
      iconColor: Colors.green,
      averageScore: 9.5,
      className: '12A9',
    ),
  ];

  // --- BIẾN TRẠNG THÁI ---
  String _selectedYear = '2020';
  String _selectedSemester = '1';
  final Color primaryColor = const Color(0xFF43A047); // Màu xanh lá chủ đạo

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Đặt nền Scaffold màu xanh để trùng màu với AppBar
      backgroundColor: primaryColor,
      appBar: AppBar(
        title: const Text(
          "Bảng điểm",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 26,
          ),
        ),
        backgroundColor: primaryColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      // Dùng Container bo tròn 2 góc trên để tạo hiệu ứng như thiết kế
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100], // Nền xám nhạt cho khu vực danh sách
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          children: [
            // --- PHẦN 1: BỘ LỌC DẠNG VIÊN THUỐC ---
            _buildFilterSection(),

        // --- PHẦN 2: DANH SÁCH MÔN HỌC ---
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
                itemCount: _subjects.length,
                itemBuilder: (context, index) {
                  return _buildSubjectCard(_subjects[index]);
                },
              ),
            ),
          ],
        ),
      ),
      extendBody: true,
      bottomNavigationBar: MovingBottomBar(
        controller: NotchBottomBarController(index: 2), // Giả sử ScoreBoard nằm ở index 2 hoặc nút giữa
        onTap: (index) {
          if (index == 2) return; // Nếu đang ở tab này rồi thì không làm gì
          // TODO: Thêm xử lý chuyển tab nếu cần
          Navigator.pop(context); // Tạm thời pop về Home khi bấm các tab khác
        },
      ),
    );
  }

  // Widget xây dựng khu vực bộ lọc
  Widget _buildFilterSection() {
    return Padding(
      padding: const EdgeInsets.only(top: 24, left: 16, right: 16, bottom: 16),
      child: Row(
        children: [
          // Dropdown Năm học
          Expanded(
            child: _buildPillDropdown(
              label: "Năm học",
              value: _selectedYear,
              items: _years,
              onChanged: (val) {
                setState(() => _selectedYear = val!);
              },
            ),
          ),
          const SizedBox(width: 16),
          // Dropdown Học kì
          Expanded(
            child: _buildPillDropdown(
              label: "Học kì",
              value: _selectedSemester,
              items: _semesters,
              onChanged: (val) {
                setState(() => _selectedSemester = val!);
              },
            ),
          ),
        ],
      ),
    );
  }

  // Hàm tạo Dropdown dạng viên thuốc có nút mũi tên xanh
  Widget _buildPillDropdown({
    required String label,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Container(
      height: 45,
      padding: const EdgeInsets.only(left: 16, right: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(30), // Bo tròn mạnh
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: value,
          // Nút mũi tên được bọc trong hình tròn xanh
          icon: Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: primaryColor,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.keyboard_arrow_down,
              color: Colors.white,
              size: 18,
            ),
          ),
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: onChanged,
          // Custom cách hiển thị item đang được chọn (Thêm chữ "Năm học: " phía trước)
          selectedItemBuilder: (context) {
            return items.map((e) {
              return Container(
                alignment: Alignment.centerLeft,
                child: RichText(
                  text: TextSpan(
                    text: "$label: ",
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                    children: [
                      TextSpan(
                        text: e,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList();
          },
        ),
      ),
    );
  }

  // Widget xây dựng thẻ môn học
  Widget _buildSubjectCard(SubjectItem subject) {
    // Xác định màu điểm
    Color scoreColor = Colors.grey;
    if (subject.averageScore != null) {
      if (subject.averageScore! >= 9.0) {
        scoreColor = const Color(0xFF00C853);
      } // Màu xanh lá tươi
      else if (subject.averageScore! >= 7.0) {
        scoreColor = const Color(0xFF1976D2);
      } // Màu xanh dương
      else if (subject.averageScore! >= 5.0) {
        scoreColor = Colors.orange;
      } else {
        scoreColor = Colors.red;
      }
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 18),
      elevation: 3,
      // Tạo bóng đổ rõ hơn một chút
      shadowColor: Colors.grey.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      // Bo tròn như viên thuốc
      child: InkWell(
        onTap: () {
          // TODO: Mở comment dưới đây khi bạn đã tạo trang Chi tiết điểm
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => SubjectDetailScreen(subjectName: subject.name),
          //   ),
          // );
        },
        borderRadius: BorderRadius.circular(30),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Row(
            children: [
              // Icon môn học (Màu nền nhạt + Icon đậm)
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: subject.iconColor.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(subject.icon, color: subject.iconColor, size: 30),
              ),
              const SizedBox(width: 20),

              // Tên môn học & Tên lớp
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subject.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Lớp: ${subject.className}",
                      style: TextStyle(color: Colors.grey[700], fontSize: 15),
                    ),
                  ],
                ),
              ),

              // Cục tròn hiển thị Điểm
              Container(
                width: 56,
                height: 56,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: scoreColor,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  subject.averageScore?.toString() ?? "-",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- MODEL CẬP NHẬT LẠI CHO PHÙ HỢP GIAO DIỆN ---
class SubjectItem {
  final String id;
  final String name;
  final IconData icon;
  final Color iconColor;
  final double? averageScore;
  final String className;

  SubjectItem({
    required this.id,
    required this.name,
    required this.icon,
    required this.iconColor,
    this.averageScore,
    required this.className,
  });
}
