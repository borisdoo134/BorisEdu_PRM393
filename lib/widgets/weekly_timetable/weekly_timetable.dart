import 'package:flutter/material.dart';

// Widget Thanh ngày
class WeeklyDateSelector extends StatelessWidget {
  final List<Map<String, dynamic>> weekDays;
  final Function(int) onDayTapped;

  const WeeklyDateSelector({
    super.key,
    required this.weekDays,
    required this.onDayTapped,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 75,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        itemCount: weekDays.length,
        itemBuilder: (context, index) {
          final day = weekDays[index];
          final isActive = day['isActive'] as bool;

          return GestureDetector(
            onTap: () => onDayTapped(index),
            child: Container(
              width: 55,
              margin: const EdgeInsets.symmetric(horizontal: 6.0),
              decoration: BoxDecoration(
                color: isActive ? const Color(0xFFE8F5E9) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isActive
                      ? Colors.green.withValues(alpha: 0.5)
                      : Colors.grey.shade300,
                  width: 1,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    day['day'],
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
                      color: isActive ? Colors.green.shade800 : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    day['date'],
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// Widget 1 Tiết học
class WeeklyTimelineItem extends StatelessWidget {
  final Map<String, dynamic> classInfo;

  const WeeklyTimelineItem({super.key, required this.classInfo});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Cột hiển thị giờ
          SizedBox(
            width: 45,
            child: Column(
              children: [
                Text(
                  classInfo['timeLabel'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Container(
                    width: 2,
                    color: Colors.grey.shade400, // Thanh dọc kẻ ngang xuống
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // 2. Thẻ môn học bên phải
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 24),
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                color: classInfo['color'], // Màu nền
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: classInfo['accentColor'].withOpacity(0.3),
                  width: 1,
                ),
              ),
              // Dùng Row bọc lấy Dải Màu Bên Trái và phần Nội Dung
              child: Row(
                children: [
                  Container(
                    width: 7,
                    color: classInfo['accentColor'],
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 14.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 1. Tên môn học
                          Text(
                            classInfo['subject'] ?? 'Môn học',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 4),

                          // 2. Địa điểm phòng
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                size: 14,
                                color: Colors.grey.shade700,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                classInfo['room'] ?? 'Phòng học',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 14),
                          Divider(
                            height: 1,
                            color: Colors.black.withOpacity(0.1),
                          ),
                          const SizedBox(height: 12),

                          // 3. Thời gian và Avatar
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.access_time,
                                    size: 16,
                                    color: Colors.black87,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    classInfo['timeRange'] ?? '00:00 - 00:00',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                              // Avatar giả lập
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Colors.grey,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.person,
                                  size: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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
