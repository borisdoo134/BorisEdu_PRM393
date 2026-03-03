import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:myfschools/widgets/bottom_bar.dart';
import 'package:myfschools/widgets/score_board/score_board.dart';

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
                  return SubjectCardWidget(subject: _subjects[index]);
                },
              ),
            ),
          ],
        ),
      ),
      extendBody: true,
      bottomNavigationBar: MovingBottomBar(
        controller: NotchBottomBarController(index: 2),
        // Giả sử ScoreBoard nằm ở index 2 hoặc nút giữa
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
            child: ScoreBoardPillDropdown(
              label: "Năm học",
              value: _selectedYear,
              items: _years,
              primaryColor: primaryColor,
              onChanged: (val) {
                setState(() => _selectedYear = val!);
              },
            ),
          ),
          const SizedBox(width: 16),
          // Dropdown Học kì
          Expanded(
            child: ScoreBoardPillDropdown(
              label: "Học kì",
              value: _selectedSemester,
              items: _semesters,
              primaryColor: primaryColor,
              onChanged: (val) {
                setState(() => _selectedSemester = val!);
              },
            ),
          ),
        ],
      ),
    );
  }
}
