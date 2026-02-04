import 'package:flutter/material.dart';

class BackToLogin extends StatelessWidget {
  final String text; // Nội dung chữ
  final VoidCallback onPressed; // Hành động khi bấm
  final TextStyle? style; // Style chữ (nếu muốn chỉnh sửa, không bắt buộc)

  const BackToLogin({
    super.key,
    required this.text,
    required this.onPressed,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center, // Luôn căn giữa
      children: [
        TextButton(
          onPressed: onPressed,
          child: Text(
            text,
            // Nếu không truyền style thì lấy style mặc định của App
            style: style ?? Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}
