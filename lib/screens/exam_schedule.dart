import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:myfschools/widgets/attendence_report/attendence_report.dart'; // For YearDropdown
import 'package:myfschools/widgets/bottom_bar.dart';
import 'package:myfschools/widgets/exam_schedule/exam_schedule.dart'; // Custom widgets for exam schedule
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myfschools/models/exam_schedule/exam_schedule_model.dart';
import 'package:myfschools/services/exam_schedule_service.dart';

class ExamScheduleScreen extends StatefulWidget {
  const ExamScheduleScreen({super.key});

  @override
  State<ExamScheduleScreen> createState() => _ExamScheduleScreenState();
}

class _ExamScheduleScreenState extends State<ExamScheduleScreen> {
  String _selectedYear = 'Tất cả';
  final List<String> _years = ['Tất cả', '2023-2024', '2024-2025', '2025-2026', '2026-2027'];
  final NotchBottomBarController _controller = NotchBottomBarController(
    index: 2,
  );
  
  List<ExamScheduleModel> _schedules = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchSchedules();
  }

  Future<void> _fetchSchedules() async {
    setState(() => _isLoading = true);
    final prefs = await SharedPreferences.getInstance();
    final studentId = prefs.getString('SELECTED_STUDENT_ID');
    if (studentId != null) {
      final yearParam = _selectedYear == 'Tất cả' ? null : _selectedYear;
      final result = await ExamScheduleService.getExamSchedules(
        studentId, 
        academicYear: yearParam,
      );
      if (mounted) {
        setState(() {
          _schedules = result;
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

  String _formatDate(String date) {
    try {
      final parts = date.split('-');
      if (parts.length == 3) {
        return "${parts[2]} / ${parts[1]} / ${parts[0]}";
      }
    } catch (_) {}
    return date;
  }

  String _formatTime(String time) {
    if (time.length >= 5) {
      return time.substring(0, 5);
    }
    return time;
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = const Color(0xFF43A047);

    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        title: const Text(
          "Lịch Thi",
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
                    _fetchSchedules();
                  }
                },
              ),
              const SizedBox(height: 24),

              // Exam List
              Expanded(
                child: _isLoading 
                    ? const Center(child: CircularProgressIndicator(color: Colors.green))
                    : _schedules.isEmpty
                        ? const Center(child: Text('Không có lịch thi nào', style: TextStyle(color: Colors.grey)))
                        : ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: _schedules.length + 1, // +1 for the bottom padding
                            itemBuilder: (context, index) {
                              if (index == _schedules.length) {
                                return const SizedBox(height: 100); // padding for bottom nav bar
                              }
                              final schedule = _schedules[index];
                              return ExamScheduleCard(
                                subjectName: schedule.subjectName,
                                status: schedule.status,
                                examType: schedule.examType,
                                date: _formatDate(schedule.examDate),
                                time: "${_formatTime(schedule.startTime)} - ${_formatTime(schedule.endTime)}", 
                                location: schedule.room,
                              );
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
