import 'package:flutter/material.dart';
import 'package:myfschools/screens/login.dart';
import 'package:myfschools/services/auth_service.dart';
import 'package:myfschools/utils/constants/t_texts.dart';
import 'package:myfschools/widgets/copyright_footer.dart';
import 'package:myfschools/widgets/custom_label_field.dart';
import 'package:myfschools/widgets/login_signup/form_header.dart';
import 'package:myfschools/widgets/primary_button.dart';

class ChangePasswordScreen extends StatefulWidget {
  final String otpCode;

  const ChangePasswordScreen({super.key, required this.otpCode});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  bool _obscurePassword = true;
  bool _obscureRePassword = true;
  bool _isLoading = false;
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _rePasswordController = TextEditingController();
  final _keyForm = GlobalKey<FormState>();

  @override
  void dispose() {
    _passwordController.dispose();
    _rePasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf0f0f0),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 24.0,
                    right: 24.0,
                    bottom: 24.0,
                    top: 190.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Header
                      FormHeader(
                        title: TTexts.changePasswordTitle,
                        subTitle: TTexts.changePasswordSubTitle,
                      ),

                      const SizedBox(height: 32),

                      /// Form
                      Form(
                        key: _keyForm,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),

                            PasswordInputField(
                              label: TTexts.password,
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              onToggle: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Vui lòng nhập mật khẩu!';
                                }
                                final regex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');
                                if (!regex.hasMatch(value)) {
                                  return 'Mật khẩu phải chứa ít nhất 8 ký tự, bao gồm chữ cái và số!';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 8),

                            PasswordInputField(
                              label: TTexts.rePassword,
                              controller: _rePasswordController,
                              obscureText: _obscureRePassword,
                              onToggle: () {
                                setState(() {
                                  _obscureRePassword = !_obscureRePassword;
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Vui lòng nhập lại mật khẩu!';
                                }
                                if (value != _passwordController.text) {
                                  return 'Mật khẩu nhập lại không khớp!';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 35),

                            /// Submit Button
                            PrimaryButton(
                              text: _isLoading ? 'Đang xử lý...' : TTexts.changePassword,
                              onPressed: _isLoading
                                  ? null
                                  : () async {
                                      if (_keyForm.currentState!.validate()) {
                                        setState(() => _isLoading = true);

                                        final result = await AuthService.resetPassword(
                                          widget.otpCode,
                                          _passwordController.text,
                                        );

                                        if (!context.mounted) return;
                                        setState(() => _isLoading = false);

                                        if (result['success'] == true) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text(result['message'] ?? 'Đổi mật khẩu thành công!'),
                                              backgroundColor: Colors.green,
                                              behavior: SnackBarBehavior.floating,
                                              margin: const EdgeInsets.all(10),
                                              duration: const Duration(seconds: 3),
                                            ),
                                          );

                                          // Xóa toàn bộ stack và quay về Login
                                          Navigator.of(context).pushAndRemoveUntil(
                                            MaterialPageRoute(
                                              builder: (context) => const LoginScreen(),
                                            ),
                                            (route) => false,
                                          );
                                        } else {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text(result['message'] ?? 'Có lỗi xảy ra, vui lòng thử lại!'),
                                              backgroundColor: Colors.red,
                                              behavior: SnackBarBehavior.floating,
                                              margin: const EdgeInsets.all(10),
                                            ),
                                          );
                                        }
                                      }
                                    },
                            ),
                            const SizedBox(height: 30),
                          ],
                        ),
                      ),

                      const Spacer(),

                      const CopyrightFooter(),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
