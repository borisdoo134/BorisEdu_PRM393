import 'package:flutter/material.dart';
import 'package:myfschools/utils/constants/t_texts.dart';

class CopyrightFooter extends StatelessWidget {
  final String text;
  final Color? color;

  const CopyrightFooter({
    super.key,
    this.text = TTexts.copyrightTitle,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: color ?? Colors.grey[600],
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
