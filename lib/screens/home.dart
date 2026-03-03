import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:myfschools/screens/score_board.dart';
import 'package:myfschools/screens/weekly_timetable.dart';
import 'package:myfschools/widgets/bottom_bar.dart';
import 'package:myfschools/widgets/home/feature_new_section.dart';
import 'package:myfschools/widgets/home/home_header.dart';
import 'package:myfschools/widgets/home/home_menu_card.dart';
import 'package:myfschools/widgets/keep_alive_wrapper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _controller = NotchBottomBarController(index: 2);
  final _pageController = PageController(initialPage: 2);

  int maxCount = 5;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Danh sách các màn hình
    final List<Widget> bottomBarPages = [
      const KeepAliveWrapper(child: Center(child: Text("Màn hình Trò chuyện"))),
      const KeepAliveWrapper(child: Center(child: Text("Màn hình Thông báo"))),
      KeepAliveWrapper(child: _buildHomeBody(context)),
      const KeepAliveWrapper(child: Center(child: Text("Màn hình Hoạt động"))),
      const KeepAliveWrapper(child: Center(child: Text("Màn hình Danh bạ"))),
    ];

    return Scaffold(
      backgroundColor: Colors.white,

      // 3. BODY: Dùng PageView để có hiệu ứng lướt qua lại mượt mà (Option)
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: bottomBarPages,
      ),

      extendBody: true,
      bottomNavigationBar: MovingBottomBar(
        controller: _controller,
        onTap: (index) {
          _pageController.jumpToPage(index);
        },
      ),
    );
  }

  Widget _buildHomeBody(BuildContext context) {
    final Color primaryColor = Colors.green;

    return SingleChildScrollView(
      child: Column(
        children: [
          /// 1. HEADER SECTION
          HomeHeader(
            primaryColor: primaryColor,
            onTabChanged: (index) {
              _pageController.jumpToPage(index);
              _controller.jumpTo(index); // Update animated bottom notch bar
            },
          ),

          const SizedBox(height: 20),

          /// 2. FEATURE GRID (Các chức năng chính)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Tiện ích",
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(top: 20),
                  // Rút gọn padding
                  crossAxisCount: 3,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 0.9,
                  children: [
                    MenuCard(
                      icon: Icons.calendar_month_outlined,
                      label: "Thời khóa biểu",
                      color: Colors.blue,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const WeeklyTimetableScreen(),
                          ),
                        );
                      },
                    ),
                    MenuCard(
                      icon: Icons.score,
                      label: "Bảng điểm",
                      color: Colors.orange,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ScoreBoardScreen(),
                          ),
                        );
                      },
                    ),
                    MenuCard(
                      icon: Icons.edit_document,
                      label: "Xin nghỉ phép",
                      color: Colors.red,
                      onTap: () {},
                    ),
                    MenuCard(
                      icon: Icons.assessment_rounded,
                      label: "Lịch thi",
                      color: Colors.purple,
                      onTap: () {},
                    ),
                    MenuCard(
                      icon: Icons.group,
                      label: "Câu lạc bộ",
                      color: Colors.teal,
                      onTap: () {},
                    ),
                    MenuCard(
                      icon: Icons.payment,
                      label: "Học phí",
                      color: Colors.pink,
                      onTap: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 25),

          /// 3. LATEST NOTICES (Tin tức mới)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const FeaturedNewsSection(), // Thêm const cho tối ưu
              ],
            ),
          ),

          const SizedBox(height: 100),
        ],
      ),
    );
  }
}
