import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:myfschools/widgets/attendence_report/attendence_report.dart';
import 'package:myfschools/widgets/bottom_bar.dart';
import 'attendence_detail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myfschools/models/attendance/attendance_overview_model.dart';
import 'package:myfschools/services/attendance_service.dart';

class AttendenceReportScreen extends StatefulWidget {
  const AttendenceReportScreen({super.key});

  @override
  State<AttendenceReportScreen> createState() => _AttendenceReportScreenState();
}

class _AttendenceReportScreenState extends State<AttendenceReportScreen> {
  String _selectedYear = 'Tất cả';
  final List<String> _years = ['Tất cả', '2023-2024', '2024-2025', '2025-2026', '2026-2027'];
  final NotchBottomBarController _controller = NotchBottomBarController(
    index: 2,
  );
  
  List<AttendanceOverviewModel> _attendances = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAttendances();
  }

  Future<void> _fetchAttendances() async {
    setState(() => _isLoading = true);
    final prefs = await SharedPreferences.getInstance();
    final studentId = prefs.getString('SELECTED_STUDENT_ID');
    if (studentId != null) {
      final result = await AttendanceService.getAttendanceOverview(studentId);
      if (mounted) {
        setState(() {
          _attendances = result;
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
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildCard(AttendanceOverviewModel model) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AttendenceDetailScreen(
              subjectId: model.subjectId,
              subjectName: model.subjectName,
              className: model.className,
              present: model.presentCount,
              total: model.totalConducted,
            ),
          ),
        );
      },
      child: SubjectAttendanceCard(
        subjectName: model.subjectName,
        className: model.className,
        present: model.presentCount,
        total: model.totalConducted,
        percentage: model.percentage,
        bannedFromExam: model.bannedFromExam,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = const Color(0xFF43A047);

    final filteredAttendances = _selectedYear == 'Tất cả'
        ? _attendances
        : _attendances.where((item) => item.academicYear == _selectedYear).toList();

    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        title: const Text(
          "Điểm Danh",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        backgroundColor: primaryColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xFFF5F5F5),
          borderRadius: BorderRadius.vertical(top: Radius.circular(35)),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 24, bottom: 0),
          child: Column(
            children: [
              // Year Filter
              YearDropdown(
                selectedYear: _selectedYear,
                years: _years,
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedYear = newValue;
                    });
                  }
                },
              ),
              const SizedBox(height: 24),

              // Subject List
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator(color: Colors.green))
                    : filteredAttendances.isEmpty
                        ? const Center(child: Text('Không có dữ liệu điểm danh', style: TextStyle(color: Colors.grey)))
                        : ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: filteredAttendances.length + 1, // +1 for the bottom padding
                            itemBuilder: (context, index) {
                              if (index == filteredAttendances.length) {
                                return const SizedBox(height: 100); // padding for bottom nav bar
                              }
                              return _buildCard(filteredAttendances[index]);
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
      extendBody: true,
      bottomNavigationBar: MovingBottomBar(
        controller: _controller,
        onTap: (index) {
          if (index == 2) return;
          Navigator.pop(context, index); 
        },
      ),
    );
  }
}
