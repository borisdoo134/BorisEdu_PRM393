import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:myfschools/widgets/bottom_bar.dart';

class WeeklyTimetableScreen extends StatefulWidget {
  const WeeklyTimetableScreen({super.key});

  @override
  State<WeeklyTimetableScreen> createState() => _WeeklyTimetableScreenState();
}

class _WeeklyTimetableScreenState extends State<WeeklyTimetableScreen> {
  final Color primaryColor = const Color(
    0xFF43A047,
  ); // Màu xanh lá chủ đạo (tương tự appBar)

  String _selectedWeek = 'Tuần 43';

  // Danh sách các ngày trong tuần (giả lập)
  final List<Map<String, dynamic>> _weekDays = [
    {'day': 'MON', 'date': '12', 'isActive': false},
    {'day': 'TUE', 'date': '13', 'isActive': true},
    {'day': 'WED', 'date': '14', 'isActive': false},
    {'day': 'THU', 'date': '15', 'isActive': false},
    {'day': 'FRI', 'date': '16', 'isActive': false},
    {'day': 'SAT', 'date': '17', 'isActive': false},
    {'day': 'SUN', 'date': '18', 'isActive': false},
  ];

  // Danh sách các môn học trong ngày (giả lập giống ảnh thiết kế)
  final List<Map<String, dynamic>> _dailyClasses = [
    {
      'timeLabel': '7:00',
      'subject': 'Toán Học',
      'room': 'Delta, Phòng 403',
      'timeRange': '7:00 - 7:45',
      'color': const Color(0xFFE8F5E9), // Nền xanh lá nhạt
      'accentColor': const Color(0xFF4CAF50), // Border xanh lá nhạt
    },
    {
      'timeLabel': '8:00',
      'subject': 'Toán Học',
      'room': 'Delta, Phòng 403',
      'timeRange': '8:00 - 8:45',
      'color': const Color(0xFFE1F5FE), // Nền xanh dương nhạt
      'accentColor': const Color(0xFF03A9F4), // Border xanh dương nhạt
    },
    {
      'timeLabel': '9:00',
      'subject': 'Toán Học',
      'room': 'Delta, Phòng 403',
      'timeRange': '9:00 - 9:45',
      'color': const Color(0xFFFFF3E0), // Nền cam nhạt
      'accentColor': const Color(0xFFFF9800), // Border cam nhạt
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        title: const Text(
          "Lịch Học",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 26,
          ),
        ),
        backgroundColor: primaryColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(35)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 30),

            // --- HEADER: THÁNG & TUẦN ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    "Tháng 10 / 2026",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  DropdownButton<String>(
                    value: _selectedWeek,
                    icon: const Icon(Icons.arrow_drop_down, color: Colors.black87),
                    elevation: 16,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                    underline: Container(), // Ẩn gạch chân
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _selectedWeek = newValue;
                        });
                      }
                    },
                    items: <String>['Tuần 41', 'Tuần 42', 'Tuần 43', 'Tuần 44']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // --- THANH CHỌN NGÀY ---
            _buildDateSelector(),

            const SizedBox(height: 10),
            const Divider(height: 1, thickness: 1, color: Colors.black12),
            const SizedBox(height: 16),

            // --- TIÊU ĐỀ HÔM NAY ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Lịch Học Hôm Nay",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Thứ 3, 10 / 2026",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // --- TIMELINE LỚP HỌC ---
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 24,
                  bottom: 20,
                  top: 10,
                ),
                itemCount: _dailyClasses.length,
                itemBuilder: (context, index) {
                  return _buildTimelineItem(_dailyClasses[index]);
                },
              ),
            ),
          ],
        ),
      ),
      // --- BOTTOM BAR ---
      extendBody: true,
      bottomNavigationBar: MovingBottomBar(
        controller: NotchBottomBarController(index: 2),
        onTap: (index) {
          if (index == 2) return;
          Navigator.pop(context); // Trở về trang trước khi chọn tab khác
        },
      ),
    );
  }

  // Widget Thanh ngày
  Widget _buildDateSelector() {
    return SizedBox(
      height: 75,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        itemCount: _weekDays.length,
        itemBuilder: (context, index) {
          final day = _weekDays[index];
          final isActive = day['isActive'] as bool;

          return GestureDetector(
            onTap: () {
              setState(() {
                // Đặt lại tất cả thành false
                for (var element in _weekDays) {
                  element['isActive'] = false;
                }
                // Đặt ngày hiện tại thành true
                _weekDays[index]['isActive'] = true;
              });
            },
            child: Container(
              width: 55,
              margin: const EdgeInsets.symmetric(horizontal: 6.0),
              decoration: BoxDecoration(
                color: isActive ? const Color(0xFFE8F5E9) : Colors.white,
                // Nền xanh nhạt nếu active
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

  // Widget 1 Tiết học
  Widget _buildTimelineItem(Map<String, dynamic> classInfo) {
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
                      // Thêm fallback text để test
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black, // Đảm bảo màu chữ là đen
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
                    Divider(height: 1, color: Colors.black.withValues(alpha: 0.1)),
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
