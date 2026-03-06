import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:myfschools/widgets/attendence_report/attendence_report.dart'; // For YearDropdown
import 'package:myfschools/widgets/bottom_bar.dart';
import 'package:myfschools/widgets/exam_schedule/exam_schedule.dart'; // Custom widgets for exam schedule

class ExamScheduleScreen extends StatefulWidget {
  const ExamScheduleScreen({super.key});

  @override
  State<ExamScheduleScreen> createState() => _ExamScheduleScreenState();
}

class _ExamScheduleScreenState extends State<ExamScheduleScreen> {
  String _selectedYear = '2020';
  final List<String> _years = ['2019', '2020', '2021', '2022'];
  final NotchBottomBarController _controller = NotchBottomBarController(
    index: 2,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
                  }
                },
              ),
              const SizedBox(height: 24),

              // Exam List
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: const [
                    ExamScheduleCard(
                      subjectName: "Tiếng Anh",
                      isUpcoming: true,
                      examType: "Kiểm tra cuối",
                      date: "06 / 03 /2026",
                      time: "9:00 - 9:45",
                      location: "Delta, Phòng 403",
                    ),
                    ExamScheduleCard(
                      subjectName: "Toán Học",
                      isUpcoming: false,
                      examType: "Kiểm tra cuối",
                      date: "06 / 04 /2026",
                      time: "9:00 - 9:45",
                      location: "Delta, Phòng 403",
                    ),
                    ExamScheduleCard(
                      subjectName: "Ngữ Văn",
                      isUpcoming: false,
                      examType: "Kiểm tra cuối",
                      date: "06 / 04 /2026",
                      time: "9:00 - 9:45",
                      location: "Delta, Phòng 403",
                    ),
                    SizedBox(height: 100), // padding for bottom nav bar
                  ],
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
