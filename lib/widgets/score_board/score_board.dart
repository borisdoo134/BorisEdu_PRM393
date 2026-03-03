import 'package:flutter/material.dart';

// --- MODEL ---
class SubjectItem {
  final String id;
  final String name;
  final IconData icon;
  final Color iconColor;
  final double? averageScore;
  final String className;

  SubjectItem({
    required this.id,
    required this.name,
    required this.icon,
    required this.iconColor,
    this.averageScore,
    required this.className,
  });
}

// Widget xây dựng thẻ môn học
class SubjectCardWidget extends StatelessWidget {
  final SubjectItem subject;

  const SubjectCardWidget({super.key, required this.subject});

  @override
  Widget build(BuildContext context) {
    Color scoreColor = Colors.grey;
    if (subject.averageScore != null) {
      if (subject.averageScore! >= 9.0) {
        scoreColor = const Color(0xFF00C853);
      } else if (subject.averageScore! >= 7.0) {
        scoreColor = const Color(0xFF1976D2);
      } else if (subject.averageScore! >= 5.0) {
        scoreColor = Colors.orange;
      } else {
        scoreColor = Colors.red;
      }
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 18),
      elevation: 3,
      shadowColor: Colors.grey.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(30),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: subject.iconColor.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(subject.icon, color: subject.iconColor, size: 30),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subject.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Lớp: ${subject.className}",
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
                  subject.averageScore?.toString() ?? "-",
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
