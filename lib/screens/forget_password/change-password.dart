import 'package:flutter/material.dart';
import 'package:myfschools/screens/login.dart';
import 'package:myfschools/utils/constants/TTexts.dart';
import 'package:myfschools/widgets/copyright_footer.dart';
import 'package:myfschools/widgets/custom_label_field.dart';
import 'package:myfschools/widgets/login_signup/form_header.dart';
import 'package:myfschools/widgets/primary_button.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  bool _obscurePassword = true;
  bool _obscureRePassword = true;
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _rePasswordController = TextEditingController();
  final _keyForm = GlobalKey<FormState>();

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
                                return null;
                              },
                            ),

                            const SizedBox(height: 35),

                            /// Sign In Button
                            PrimaryButton(
                              text: TTexts.changePassword,
                              onPressed: () {
                                if (_keyForm.currentState!.validate()) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const LoginScreen(),
                                    ),
                                  );

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Đổi mật khẩu thành công!'),
                                      backgroundColor: Colors.green,
                                      behavior: SnackBarBehavior.floating,
                                      margin: EdgeInsets.all(10),
                                      duration: Duration(seconds: 3),
                                    ),
                                  );
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
