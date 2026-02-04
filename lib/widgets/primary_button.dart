import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  // Bạn có thể thêm màu tùy chỉnh nếu muốn, nhưng mặc định là xanh
  final Color? backgroundColor;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, // Nút luôn full chiều ngang
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? Colors.green[600],
          // Mặc định xanh
          foregroundColor: Colors.white,
          // Chữ trắng
          padding: const EdgeInsets.all(15),
          // Padding chuẩn
          // Nếu muốn bo tròn giống TextFormField thì thêm dòng này:
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 2, // Đổ bóng nhẹ cho đẹp
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
