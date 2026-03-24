import 'package:flutter/material.dart';

class SubjectAttendanceCard extends StatelessWidget {
  final String subjectName;
  final String className;
  final int present;
  final int total;
  final int percentage;
  final bool bannedFromExam;

  const SubjectAttendanceCard({
    super.key,
    required this.subjectName,
    required this.className,
    required this.present,
    required this.total,
    required this.percentage,
    this.bannedFromExam = false,
  });

  @override
  Widget build(BuildContext context) {
    int percentageInt = percentage;
    double progressValue = percentageInt / 100.0;
    
    Color presentColor = bannedFromExam ? const Color(0xFFF27123) : Colors.greenAccent.shade400;
    Color absentColor = bannedFromExam ? const Color(0xFFE8EDF2) : Colors.orange;
    Color textColor = bannedFromExam ? const Color(0xFFF27123) : Colors.green;
    Color bgColor = bannedFromExam ? const Color(0xFFFFF9F5) : Colors.white;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: bannedFromExam ? Border.all(color: const Color(0xFFFCD0B4), width: 1.5) : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                SizedBox(
                  width: 80,
                  height: 80,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CircularProgressIndicator(
                        value: progressValue,
                        backgroundColor: absentColor,
                        color: presentColor,
                        strokeWidth: 8,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "$percentageInt",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: bannedFromExam ? const Color(0xFFF27123) : Colors.black,
                            ),
                          ),
                          Text(
                            "CHUYÊN CẦN",
                            style: TextStyle(
                              fontSize: 8,
                              fontWeight: FontWeight.w600,
                              color: bannedFromExam ? const Color(0xFF475569) : Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        subjectName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.menu_book, size: 16, color: Colors.blue.shade300),
                          const SizedBox(width: 8),
                          Text(
                            className,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Divider(height: 16, thickness: 1, color: bannedFromExam ? const Color(0xFFFCD0B4) : null),
                      Row(
                        children: [
                          Icon(bannedFromExam ? Icons.how_to_reg : Icons.person_outline, size: 16, color: textColor),
                          const SizedBox(width: 8),
                          Text(
                            "$present / $total Tiết",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: textColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (bannedFromExam)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: const BoxDecoration(
                  color: Color(0xFFF27123),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(15),
                    bottomLeft: Radius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error, size: 14, color: Colors.white),
                    const SizedBox(width: 4),
                    const Text(
                      "BỊ CẤM THI",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class YearDropdown extends StatelessWidget {
  final String selectedYear;
  final List<String> years;
  final ValueChanged<String?> onChanged;

  const YearDropdown({
    super.key,
    required this.selectedYear,
    required this.years,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: Row(
        children: [
          const Icon(Icons.calendar_month_outlined, color: Colors.green),
          const SizedBox(width: 8),
          const Text(
            "Năm học:",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedYear,
                icon: Container(
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_drop_down,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                isExpanded: true,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
                onChanged: onChanged,
                items: years.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
