import 'package:flutter/material.dart';

class RegularInputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType; // Để chỉnh bàn phím số cho SĐT
  final String? hintText;

  const RegularInputField({
    super.key,
    required this.label,
    required this.controller,
    this.validator,
    this.keyboardType,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _CustomLabel(label: label), // Gọi widget label chung bên dưới
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          // Giữ nguyên logic của bạn
          validator: validator,
          decoration: _commonInputDecoration(hintText ?? label),
        ),
      ],
    );
  }
}

class PasswordInputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool obscureText; // Trạng thái ẩn/hiện
  final VoidCallback onToggle; // Hàm bấm nút mắt
  final String? hintText;

  const PasswordInputField({
    super.key,
    required this.label,
    required this.controller,
    required this.obscureText,
    required this.onToggle,
    this.validator,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _CustomLabel(label: label),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: validator,
          decoration: _commonInputDecoration(hintText ?? label).copyWith(
            suffixIcon: IconButton(
              icon: Icon(
                obscureText
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
              ),
              onPressed: onToggle,
            ),
          ),
        ),
      ],
    );
  }
}

class _CustomLabel extends StatelessWidget {
  final String label;

  const _CustomLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: '* ',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          TextSpan(
            text: label,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

InputDecoration _commonInputDecoration(String hint) {
  return InputDecoration(
    filled: true,
    fillColor: Colors.white,
    hintText: hint,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide.none,
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: const BorderSide(color: Colors.red, width: 1),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: const BorderSide(color: Colors.red, width: 2),
    ),
  );
}
