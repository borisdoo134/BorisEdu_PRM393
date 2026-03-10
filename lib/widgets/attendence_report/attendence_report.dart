import 'package:flutter/material.dart';

class SubjectAttendanceCard extends StatelessWidget {
  final String subjectName;
  final String className;
  final int present;
  final int total;

  const SubjectAttendanceCard({
    super.key,
    required this.subjectName,
    required this.className,
    required this.present,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate percentage
    double percentage = total > 0 ? present / total : 0;
    int percentageInt = (percentage * 100).round();
    
    Color presentColor = Colors.greenAccent.shade400;
    Color absentColor = Colors.orange;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
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
                  value: percentage,
                  backgroundColor: absentColor,
                  color: presentColor,
                  strokeWidth: 8,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "$percentageInt",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const Text(
                      "Chuyên Cần",
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.black87,
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
                const Divider(height: 16, thickness: 1),
                Row(
                  children: [
                    const Icon(Icons.person_outline, size: 16, color: Colors.green),
                    const SizedBox(width: 8),
                    Text(
                      "$present / $total Tiết",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ],
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
