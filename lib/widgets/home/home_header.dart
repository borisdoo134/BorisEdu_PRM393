import 'package:flutter/material.dart';
import 'package:myfschools/screens/profile/profile.dart';

class HomeHeader extends StatelessWidget {
  final Color primaryColor;
  final Function(int)? onTabChanged;

  const HomeHeader({super.key, required this.primaryColor, this.onTabChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 25),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          // Điều hướng sang màn hình ProfileScreen
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ProfileScreen(),
                            ),
                          );
                          
                          // Nếu ProfileScreen trả về index (do user bấm bottom bar)
                          if (result != null && result is int && onTabChanged != null) {
                            onTabChanged!(result);
                          }
                        },
                        child: const CircleAvatar(
                          radius: 30,
                          backgroundImage: AssetImage(
                            'assets/avatars/phu_huynh.png',
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Xin chào, Phụ huynh",
                            style: TextStyle(
                              color: Colors.green[100],
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            "Cường Đỗ",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 25),

          // Thẻ thông tin học sinh (Con cái)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 22,
                  backgroundImage: AssetImage('assets/avatars/child.png'),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Boris Doo",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "Lớp 12A9 - Trường THPT Hoằng Hóa II",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
                const Spacer(),
                const Icon(
                  Icons.arrow_circle_down_outlined,
                  color: Colors.green,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
