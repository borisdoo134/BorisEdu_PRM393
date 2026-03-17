import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:myfschools/widgets/bottom_bar.dart';
import 'package:myfschools/widgets/score_board/score_board.dart';
import 'package:myfschools/models/academic/score_overview_response.dart';
import 'package:myfschools/services/score_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScoreBoardScreen extends StatefulWidget {
  const ScoreBoardScreen({super.key});

  @override
  State<ScoreBoardScreen> createState() => _ScoreBoardScreenState();
}

class _ScoreBoardScreenState extends State<ScoreBoardScreen> {
  final List<String> _years = ['2023-2024', '2024-2025', '2025-2026', '2026-2027'];
  final List<String> _semesters = ['1', '2', 'Cả năm'];

  List<ScoreOverviewResponse> _subjects = [];
  bool _isLoading = true;

  // --- BIẾN TRẠNG THÁI ---
  String _selectedYear = '2025-2026';
  String _selectedSemester = 'Cả năm';
  final Color primaryColor = const Color(0xFF43A047); // Màu xanh lá chủ đạo

  @override
  void initState() {
    super.initState();
    _fetchScores();
  }

  Future<void> _fetchScores() async {
    setState(() => _isLoading = true);
    final prefs = await SharedPreferences.getInstance();
    final studentId = prefs.getString('SELECTED_STUDENT_ID');
    if (studentId != null) {
      final result = await ScoreService.getScoreOverview(
        studentId,
        _selectedYear,
        semester: _selectedSemester == 'Cả năm' ? null : _selectedSemester,
      );
      if (mounted) {
        setState(() {
          _subjects = result;
          _isLoading = false;
        });
      }
    } else {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

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
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator(color: Colors.green))
                  : _subjects.isEmpty
                      ? const Center(child: Text('Không có dữ liệu bảng điểm', style: TextStyle(color: Colors.grey)))
                      : ListView.builder(
                          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
                          itemCount: _subjects.length + 1,
                          itemBuilder: (context, index) {
                            if (index == _subjects.length) {
                               return const SizedBox(height: 100); // padding for bottom nav bar
                            }
                            return SubjectCardWidget(
                              subject: _subjects[index],
                              academicYear: _selectedYear,
                              semester: _selectedSemester == 'Cả năm' ? null : _selectedSemester,
                            );
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
                _fetchScores();
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
                _fetchScores();
              },
            ),
          ),
        ],
      ),
    );
  }
}
