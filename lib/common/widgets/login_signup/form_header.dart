import 'package:flutter/material.dart';
import 'package:myfschools/utils/constants/ImageString.dart';

class FormHeader extends StatelessWidget {
  const FormHeader({super.key, required this.title, required this.subTitle});

  // Khai báo các biến để nhận dữ liệu thay đổi
  final String title, subTitle;

  @override
  Widget build(BuildContext context) {
    // Mình đã bỏ bớt 1 lớp Column bao ngoài thừa thãi trong code cũ của bạn
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image(height: 100, image: AssetImage(TImages.logo)),
        Text(title, style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 8),
        Text(subTitle, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}
