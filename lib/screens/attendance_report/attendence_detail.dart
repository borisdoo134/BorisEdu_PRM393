import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:myfschools/widgets/bottom_bar.dart';

class AttendenceDetailScreen extends StatefulWidget {
  final String subjectName;
  final String className;
  final int present;
  final int total;

  const AttendenceDetailScreen({
    super.key,
    required this.subjectName,
    required this.className,
    required this.present,
    required this.total,
  });

  @override
  State<AttendenceDetailScreen> createState() => _AttendenceDetailScreenState();
}

class _AttendenceDetailScreenState extends State<AttendenceDetailScreen> {
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
          "Chi Tiết",
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 24, bottom: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Card
              _buildSummaryCard(),
              const SizedBox(height: 20),
              // Title Chi tiết
              const Text(
                "Chi tiết",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              // List of attendance records
              _buildAttendanceItem(
                date: "13/04/2004",
                teacher: "AnhNN59",
                session: "Tiết 1",
                isPresent: true,
              ),
              _buildAttendanceItem(
                date: "14/04/2004",
                teacher: "AnhNN59",
                session: "Tiết 1",
                isPresent: false,
              ),
              _buildAttendanceItem(
                date: "15/04/2004",
                teacher: "AnhNN59",
                session: "Tiết 1",
                isPresent: true,
              ),
              _buildAttendanceItem(
                date: "16/04/2004",
                teacher: "AnhNN59",
                session: "Tiết 1",
                isPresent: true,
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

  Widget _buildSummaryCard() {
    double percentage = widget.total > 0 ? widget.present / widget.total : 0;
    int percentageInt = (percentage * 100).round();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.subjectName,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              // Circular percentage
              SizedBox(
                width: 80,
                height: 80,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CircularProgressIndicator(
                      value: percentage,
                      backgroundColor: Colors.grey.shade200,
                      color: Colors.greenAccent.shade400,
                      strokeWidth: 6,
                    ),
                    Center(
                      child: Text(
                        "$percentageInt%",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              // Info column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.menu_book, size: 20, color: Colors.blue.shade300),
                        const SizedBox(width: 8),
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(fontSize: 14, color: Colors.black87),
                            children: [
                              const TextSpan(text: "Lớp: ", style: TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(text: widget.className, style: TextStyle(color: Colors.grey.shade600)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.insert_chart_outlined, size: 20, color: Colors.blue.shade400),
                        const SizedBox(width: 8),
                        const Text(
                          "Tổng quan:",
                          style: TextStyle(fontSize: 14, color: Colors.black87, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.only(left: 28),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "${widget.present} ",
                              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.green),
                            ),
                            TextSpan(
                              text: "/ ${widget.total} Tiết",
                              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // 3 boxes
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatBox(widget.present.toString(), "Có mặt", Colors.green),
              _buildStatBox((widget.total - widget.present).toString(), "Vắng mặt", Colors.red),
              _buildStatBox("15", "Tương lai", Colors.black87),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatBox(String count, String label, Color countColor) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              count,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: countColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendanceItem({
    required String date,
    required String teacher,
    required String session,
    required bool isPresent,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icon Left
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: isPresent ? Colors.greenAccent.shade400 : Colors.red,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.calendar_month,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          // Info Center
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  date,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.person_outline, size: 14, color: Colors.grey.shade600),
                    const SizedBox(width: 4),
                    Text(
                      teacher,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Session
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.access_time, size: 14, color: Colors.black87),
              const SizedBox(width: 4),
              Text(
                session,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          // Icon Right
          Icon(
            isPresent ? Icons.check_circle_outline : Icons.highlight_off,
            color: isPresent ? Colors.greenAccent.shade400 : Colors.red,
            size: 32,
          ),
        ],
      ),
    );
  }
}
