import 'package:flutter/material.dart';
import 'package:myfschools/screens/forget_password/otp.dart';
import 'package:myfschools/screens/login.dart';
import 'package:myfschools/utils/constants/t_texts.dart';
import 'package:myfschools/widgets/change_password/back_to_login.dart';
import 'package:myfschools/widgets/copyright_footer.dart';
import 'package:myfschools/widgets/custom_label_field.dart';
import 'package:myfschools/widgets/login_signup/form_header.dart';
import 'package:myfschools/widgets/primary_button.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final TextEditingController _phoneController = TextEditingController();
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
                      //Header
                      FormHeader(
                        title: TTexts.registerTitle,
                        subTitle: TTexts.registerSubTitle,
                      ),

                      const SizedBox(height: 32),

                      //Form
                      Form(
                        key: _keyForm,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RegularInputField(
                              label: TTexts.sdt,
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              // Bàn phím số
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Vui lòng nhập số điện thoại!';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 40),

                            /// Forget Password Request Button
                            PrimaryButton(
                              text: TTexts.requestForgetPassword,
                              onPressed: () {
                                if (_keyForm.currentState!.validate()) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const OTPScreen(),
                                    ),
                                  );
                                }
                              },
                            ),

                            const SizedBox(height: 10),

                            //Back to Login Page
                            BackToLogin(
                              text: TTexts.backToLogin,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LoginScreen(),
                                  ),
                                );
                              },
                            ),
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
