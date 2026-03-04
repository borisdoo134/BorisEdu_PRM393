import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:myfschools/widgets/attendence_report/attendence_report.dart';
import 'package:myfschools/widgets/bottom_bar.dart';
import 'attendence_detail.dart';

class AttendenceReportScreen extends StatefulWidget {
  const AttendenceReportScreen({super.key});

  @override
  State<AttendenceReportScreen> createState() => _AttendenceReportScreenState();
}

class _AttendenceReportScreenState extends State<AttendenceReportScreen> {
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

  Widget _buildCard(String subjectName, String className, int present, int total) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AttendenceDetailScreen(
              subjectName: subjectName,
              className: className,
              present: present,
              total: total,
            ),
          ),
        );
      },
      child: SubjectAttendanceCard(
        subjectName: subjectName,
        className: className,
        present: present,
        total: total,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = const Color(0xFF43A047);

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
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    _buildCard("Toán Học", "12A9", 25, 25), // Updated to match image data
                    _buildCard("Ngữ Văn", "12A9", 13, 26),
                    _buildCard("Tiếng Anh", "12A9", 26, 26),
                    _buildCard("Thể Dục", "12A9", 22, 26),
                    _buildCard("Vật Lý", "12A9", 24, 26),
                    const SizedBox(height: 100), 
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
