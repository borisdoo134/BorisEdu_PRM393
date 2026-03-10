import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:myfschools/widgets/bottom_bar.dart';
import 'package:myfschools/widgets/weekly_timetable/weekly_timetable.dart';
import 'package:myfschools/models/academic/timetable_model.dart';
import 'package:myfschools/controllers/academic/schedule_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WeeklyTimetableScreen extends StatefulWidget {
  const WeeklyTimetableScreen({super.key});

  @override
  State<WeeklyTimetableScreen> createState() => _WeeklyTimetableScreenState();
}

class _WeeklyTimetableScreenState extends State<WeeklyTimetableScreen> {
  final Color primaryColor = const Color(
    0xFF43A047,
  ); // Màu xanh lá chủ đạo (tương tự appBar)

  int? _selectedWeekNum;
  List<int> _availableWeeks = [];
  int _currentMonth = DateTime.now().month;
  int _currentYear = DateTime.now().year;

  // Danh sách các ngày trong tuần
  late final List<WeekDayModel> _weekDays = [
    WeekDayModel(dayName: 'MON', date: '-', isActive: DateTime.now().weekday == 1),
    WeekDayModel(dayName: 'TUE', date: '-', isActive: DateTime.now().weekday == 2),
    WeekDayModel(dayName: 'WED', date: '-', isActive: DateTime.now().weekday == 3),
    WeekDayModel(dayName: 'THU', date: '-', isActive: DateTime.now().weekday == 4),
    WeekDayModel(dayName: 'FRI', date: '-', isActive: DateTime.now().weekday == 5),
    WeekDayModel(dayName: 'SAT', date: '-', isActive: DateTime.now().weekday == 6),
    WeekDayModel(dayName: 'SUN', date: '-', isActive: DateTime.now().weekday == 7),
  ];

  List<TimetableModel> _fullSchedule = [];
  List<TimetableModel> _dailyClasses = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTimetable();
  }

  Future<void> _loadTimetable() async {
    setState(() => _isLoading = true);
    final prefs = await SharedPreferences.getInstance();
    final studentId = prefs.getString('SELECTED_STUDENT_ID');
    
    if (studentId != null) {
      _fullSchedule = await ScheduleController.getTimetableByStudentId(studentId);
    }
    
    _availableWeeks = List.generate(52, (i) => i + 1);
    
    if (_fullSchedule.isNotEmpty && _selectedWeekNum == null) {
      _selectedWeekNum = _fullSchedule.first.weekOfYear;
      _currentYear = _fullSchedule.first.year;
    } else if (_selectedWeekNum == null) {
      final now = DateTime.now();
      final jan4 = DateTime(now.year, 1, 4);
      final firstMonday = jan4.subtract(Duration(days: jan4.weekday - 1));
      _selectedWeekNum = (now.difference(firstMonday).inDays / 7).floor() + 1;
      _currentYear = now.year;
    }

    _generateWeekDays();
    _filterClassesForActiveDay();
    setState(() => _isLoading = false);
  }

  DateTime _firstDayOfWeek(int year, int weekNumber) {
    final DateTime jan4 = DateTime(year, 1, 4);
    final DateTime firstMonday = jan4.subtract(Duration(days: jan4.weekday - 1));
    return firstMonday.add(Duration(days: 7 * (weekNumber - 1)));
  }

  void _generateWeekDays() {
    if (_selectedWeekNum == null) return;
    
    DateTime startOfWeek = _firstDayOfWeek(_currentYear, _selectedWeekNum!);
    _currentMonth = startOfWeek.month; // Cập nhật tháng dựa trên thứ 2 của tuần đó

    for (int i = 0; i < _weekDays.length; i++) {
      DateTime currentDay = startOfWeek.add(Duration(days: i));
      String name = _weekDays[i].dayName;
      String mappedDate = currentDay.day.toString().padLeft(2, '0');
      
      _weekDays[i] = WeekDayModel(
        dayName: name, 
        date: mappedDate, 
        isActive: _weekDays[i].isActive
      );
    }
  }

  void _filterClassesForActiveDay() {
    final activeDay = _weekDays.firstWhere(
      (d) => d.isActive, 
      orElse: () => _weekDays[1],
    ); 

    final Map<String, String> dayNamesMap = {
      'MON': 'MONDAY',
      'TUE': 'TUESDAY',
      'WED': 'WEDNESDAY',
      'THU': 'THURSDAY',
      'FRI': 'FRIDAY',
      'SAT': 'SATURDAY',
      'SUN': 'SUNDAY',
    };
    
    String beDayName = dayNamesMap[activeDay.dayName] ?? '';
    if (_selectedWeekNum != null) {
      _dailyClasses = _fullSchedule.where(
        (s) => s.dayOfWeek == beDayName && s.weekOfYear == _selectedWeekNum
      ).toList();
    } else {
      _dailyClasses = [];
    }
    _dailyClasses.sort((a, b) => a.timeLabel.compareTo(b.timeLabel));
  }

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
                  Text(
                    "Tháng $_currentMonth / $_currentYear",
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  if (_availableWeeks.isNotEmpty)
                    DropdownButton<int>(
                      value: _selectedWeekNum,
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.black87,
                      ),
                      elevation: 16,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                      underline: Container(), // Ẩn gạch chân
                      onChanged: (int? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _selectedWeekNum = newValue;
                            _generateWeekDays();
                            _filterClassesForActiveDay();
                          });
                        }
                      },
                      items: _availableWeeks.map<DropdownMenuItem<int>>((int value) {
                        return DropdownMenuItem<int>(
                          value: value,
                          child: Text('Tuần $value'),
                        );
                      }).toList(),
                    )
                  else
                    Text(
                      "Chưa có lịch",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // --- THANH CHỌN NGÀY ---
            WeeklyDateSelector(
              weekDays: _weekDays,
              onDayTapped: (index) {
                setState(() {
                  // Đặt lại tất cả thành false
                  for (var element in _weekDays) {
                    element.isActive = false;
                  }
                  // Đặt ngày hiện tại thành true
                  _weekDays[index].isActive = true;
                  _filterClassesForActiveDay();
                });
              },
            ),

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
                    Builder(
                      builder: (context) {
                        final activeDay = _weekDays.firstWhere(
                          (d) => d.isActive,
                          orElse: () => _weekDays[1],
                        );
                        final Map<String, String> shortToVnMap = {
                          'MON': '2', 'TUE': '3', 'WED': '4', 'THU': '5',
                          'FRI': '6', 'SAT': '7', 'SUN': 'CN',
                        };
                        String vnDay = shortToVnMap[activeDay.dayName] ?? '?';
                        String vnDate = activeDay.date;
                        return Text(
                          "Thứ $vnDay, $vnDate / $_currentMonth / $_currentYear",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        );
                      }
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // --- TIMELINE LỚP HỌC ---
            Expanded(
              child: _isLoading 
                ? const Center(child: CircularProgressIndicator())
                : _dailyClasses.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.calendar_today, size: 50, color: Colors.grey.shade400),
                          const SizedBox(height: 10),
                          Text(
                            "Không có lịch học",
                            style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                          )
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 24,
                        bottom: 120,
                        top: 10,
                      ),
                      itemCount: _dailyClasses.length,
                      itemBuilder: (context, index) {
                        return WeeklyTimelineItem(classInfo: _dailyClasses[index]);
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
}
