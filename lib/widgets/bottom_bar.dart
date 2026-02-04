import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';

class MovingBottomBar extends StatelessWidget {
  final NotchBottomBarController controller;
  final Function(int) onTap;

  const MovingBottomBar({
    super.key,
    required this.controller,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedNotchBottomBar(
      notchBottomBarController: controller,

      color: Colors.green,
      notchColor: Colors.white,

      /// --- 1. SỬA LỖI ĐỎ (QUAN TRỌNG NHẤT) ---
      // Thư viện bắt buộc phải có dòng này.
      // Đặt bằng 0.0 để nó vuông góc, dính sát đáy màn hình.
      kBottomRadius: 0.0,

      /// --- 2. SỬA LỖI KHOẢNG TRẮNG ---
      // Xóa dòng bottomBarMargins đi, thay bằng dòng này:
      removeMargins: true,
      bottomBarWidth: MediaQuery.of(context).size.width,

      /// --- 3. SỬA LỖI ICON BỊ LỆCH ---
      // Phải đặt kIconSize BẰNG ĐÚNG size của icon bên dưới (28.0)
      // Nếu kIconSize nhỏ hơn size thật, icon sẽ bị đẩy lệch tâm.
      kIconSize: 28.0,

      durationInMilliSeconds: 500,
      showLabel: true,
      textOverflow: TextOverflow.visible,
      maxLine: 1,
      shadowElevation: 2,
      showBlurBottomBar: false,

      itemLabelStyle: const TextStyle(
        color: Colors.white,
        fontSize: 10,
        fontWeight: FontWeight.w500,
      ),

      onTap: (index) {
        controller.jumpTo(index);
        onTap(index);
      },

      bottomBarItems: const [
        BottomBarItem(
          inActiveItem: Icon(Icons.chat_bubble_outline, color: Colors.white),
          activeItem: Icon(
            Icons.chat_bubble,
            color: Colors.green,
            size: 28, // Size này phải khớp với kIconSize ở trên
          ),
          itemLabel: 'Trò chuyện',
        ),
        BottomBarItem(
          inActiveItem: Icon(Icons.notifications_none, color: Colors.white),
          activeItem: Icon(Icons.notifications, color: Colors.green, size: 28),
          itemLabel: 'Thông báo',
        ),
        BottomBarItem(
          inActiveItem: Icon(Icons.home_outlined, color: Colors.white),
          activeItem: Icon(Icons.home, color: Colors.green, size: 28),
          itemLabel: 'Trang chủ',
        ),
        BottomBarItem(
          inActiveItem: Icon(Icons.access_time, color: Colors.white),
          activeItem: Icon(
            Icons.access_time_filled,
            color: Colors.green,
            size: 28,
          ),
          itemLabel: 'Hoạt động',
        ),
        BottomBarItem(
          inActiveItem: Icon(Icons.contacts_outlined, color: Colors.white),
          activeItem: Icon(Icons.contacts, color: Colors.green, size: 28),
          itemLabel: 'Danh bạ',
        ),
      ],
    );
  }
}
