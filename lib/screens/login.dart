import 'package:flutter/material.dart';
import 'package:myfschools/screens/forget_password/forget_password.dart';
import 'package:myfschools/screens/home.dart';
import 'package:myfschools/utils/constants/t_texts.dart';
import 'package:myfschools/widgets/copyright_footer.dart';
import 'package:myfschools/widgets/custom_label_field.dart';
import 'package:myfschools/widgets/login_signup/form_header.dart';
import 'package:myfschools/widgets/primary_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _keyForm = GlobalKey<FormState>();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf0f0f0),

      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              // 2. Ép chiều cao tối thiểu bằng chiều cao màn hình
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              // 3. IntrinsicHeight giúp Column tính toán được khoảng trống cho Spacer
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
                        title: TTexts.loginTitle,
                        subTitle: TTexts.loginSubTitle,
                      ),

                      const SizedBox(height: 32),

                      /// Form
                      Form(
                        key: _keyForm,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RegularInputField(
                              label: TTexts.sdt,
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              validator: (value) =>
                                  (value == null || value.isEmpty)
                                  ? 'Vui lòng nhập số điện thoại!'
                                  : null,
                            ),
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
                              validator: (value) =>
                                  (value == null || value.isEmpty)
                                  ? 'Vui lòng nhập mật khẩu!'
                                  : null,
                            ),
                            const SizedBox(height: 8),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const ForgetPasswordScreen(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    TTexts.forgetPassword,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 20),

                            PrimaryButton(
                              text: TTexts.signIn,
                              onPressed: () {
                                if (_keyForm.currentState!.validate()) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const HomeScreen(),
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
