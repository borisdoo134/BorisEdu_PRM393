import 'package:flutter/material.dart';
import 'package:myfschools/screens/score_detail.dart';
import 'package:myfschools/models/academic/score_overview_response.dart';

// Widget xây dựng thẻ môn học
class SubjectCardWidget extends StatelessWidget {
  final ScoreOverviewResponse subject;
  final String academicYear;
  final String? semester;

  const SubjectCardWidget({
    super.key,
    required this.subject,
    required this.academicYear,
    this.semester,
  });

  IconData _getIconForSubject(String subjectName) {
    if (subjectName.contains('Toán')) return Icons.calculate;
    if (subjectName.contains('Văn')) return Icons.menu_book;
    if (subjectName.contains('Anh')) return Icons.language;
    if (subjectName.contains('Lý')) return Icons.lightbulb_outline;
    if (subjectName.contains('Hóa')) return Icons.science;
    if (subjectName.contains('Sinh')) return Icons.biotech;
    if (subjectName.contains('Sử')) return Icons.history_edu;
    if (subjectName.contains('Địa')) return Icons.public;
    if (subjectName.contains('Thể dục')) return Icons.sports_basketball;
    if (subjectName.contains('Tin')) return Icons.computer;
    if (subjectName.contains('Giáo dục')) return Icons.gavel;
    if (subjectName.contains('Mỹ thuật')) return Icons.color_lens;
    return Icons.menu_book;
  }

  Color _getColorForSubject(String subjectName) {
    if (subjectName.contains('Toán')) return Colors.green;
    if (subjectName.contains('Văn')) return Colors.blue;
    if (subjectName.contains('Anh')) return Colors.pink;
    if (subjectName.contains('Lý')) return Colors.orange;
    if (subjectName.contains('Hóa')) return Colors.purple;
    if (subjectName.contains('Sinh')) return Colors.lightGreen;
    if (subjectName.contains('Sử')) return Colors.brown;
    if (subjectName.contains('Địa')) return Colors.teal;
    if (subjectName.contains('Thể dục')) return Colors.redAccent;
    if (subjectName.contains('Tin')) return Colors.blueGrey;
    if (subjectName.contains('Mỹ thuật')) return Colors.deepOrange;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    Color scoreColor = Colors.grey;
    if (subject.averageScore > 0) {
      if (subject.averageScore >= 9.0) {
        scoreColor = const Color(0xFF00C853);
      } else if (subject.averageScore >= 7.0) {
        scoreColor = const Color(0xFF1976D2);
      } else if (subject.averageScore >= 5.0) {
        scoreColor = Colors.orange;
      } else {
        scoreColor = Colors.red;
      }
    }

    final IconData icon = _getIconForSubject(subject.subjectName);
    final Color iconColor = _getColorForSubject(subject.subjectName);

    return Card(
      margin: const EdgeInsets.only(bottom: 18),
      elevation: 3,
      shadowColor: Colors.grey.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ScoreDetailScreen(
                subjectId: subject.subjectId,
                subjectName: subject.subjectName,
                academicYear: academicYear,
                semester: semester,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(30),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 30),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subject.subjectName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subject.className,
                      style: TextStyle(color: Colors.grey[700], fontSize: 15),
                    ),
                  ],
                ),
              ),
              Container(
                width: 56,
                height: 56,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: scoreColor,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  subject.averageScore > 0 ? subject.averageScore.toString() : "-",
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

// Hàm tạo Dropdown dạng viên thuốc có nút mũi tên xanh
class ScoreBoardPillDropdown extends StatelessWidget {
  final String label;
  final String value;
  final List<String> items;
  final Function(String?) onChanged;
  final Color primaryColor;

  const ScoreBoardPillDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      padding: const EdgeInsets.only(left: 16, right: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(30),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: value,
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
}
