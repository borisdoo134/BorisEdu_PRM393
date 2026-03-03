import 'dart:async';

import 'package:flutter/material.dart';
import 'package:myfschools/screens/forget_password/change_password.dart';
import 'package:myfschools/screens/login.dart';
import 'package:myfschools/utils/constants/t_texts.dart';
import 'package:myfschools/widgets/change_password/back_to_login.dart';
import 'package:myfschools/widgets/copyright_footer.dart'; // Widget bản quyền (bạn tạo ở bước trước)
import 'package:myfschools/widgets/login_signup/form_header.dart';
import 'package:myfschools/widgets/primary_button.dart';
import 'package:pinput/pinput.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({super.key});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  int _secondsRemaining = 30;
  Timer? _timer;
  bool _canResend = false;
  final TextEditingController _pinController = TextEditingController();
  final _keyForm = GlobalKey<FormState>();
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    setState(() {
      _canResend = false;
      _secondsRemaining = 30;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        if (mounted) {
          setState(() {
            _secondsRemaining--;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _canResend = true;
          });
        }
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf0f0f0),

      // 1. Dùng LayoutBuilder để lấy chiều cao màn hình
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              // 2. Ép chiều cao tối thiểu bằng màn hình
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              // 3. IntrinsicHeight giúp Spacer tính toán được khoảng trống
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 24.0,
                    right: 24.0,
                    bottom: 24.0,
                    top: 190.0,
                  ),
                  child: Column(
                    children: [
                      // Header
                      FormHeader(
                        title: TTexts.otpTitle,
                        subTitle: TTexts.otpSubTitle,
                      ),

                      const SizedBox(height: 30),

                      // Form OTP
                      Form(
                        key: _keyForm,
                        child: Pinput(
                          controller: _pinController,
                          length: 6,
                          forceErrorState: _hasError,
                          pinputAutovalidateMode:
                              PinputAutovalidateMode.disabled,
                          onChanged: (value) {
                            if (_hasError) {
                              setState(() {
                                _hasError = false;
                              });
                            }
                          },
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value.length < 6) {
                              return 'Vui lòng nhập đủ mã OTP!';
                            }
                            return null;
                          },
                          errorTextStyle: const TextStyle(
                            color: Colors.red,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          errorPinTheme: PinTheme(
                            width: 56,
                            height: 64,
                            textStyle: const TextStyle(
                              fontSize: 22,
                              color: Colors.red,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.red),
                            ),
                          ),
                          preFilledWidget: const Text(
                            '.',
                            style: TextStyle(color: Colors.black, fontSize: 24),
                          ),
                          defaultPinTheme: PinTheme(
                            width: 56,
                            height: 64,
                            textStyle: const TextStyle(
                              fontSize: 22,
                              color: Colors.black,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.black),
                            ),
                          ),
                          focusedPinTheme: PinTheme(
                            width: 56,
                            height: 64,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.green),
                            ),
                          ),
                          onCompleted: (pin) {
                            _keyForm.currentState!.validate();
                          },
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Resend OTP Section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: _canResend
                                ? () {
                                    debugPrint("Đã gửi lại mã!");
                                    startTimer();
                                  }
                                : null,
                            child: Text(
                              TTexts.resendOtp,
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(
                                    color: _canResend
                                        ? Colors.green
                                        : Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                          if (!_canResend)
                            Text(
                              "(${_secondsRemaining}s)",
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(color: Colors.grey),
                            ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Button Verify
                      PrimaryButton(
                        text: TTexts.verifyOtp,
                        onPressed: () {
                          final pin = _pinController.text;

                          if (_keyForm.currentState!.validate()) {
                            setState(() => _hasError = false);
                            debugPrint('Mã OTP là: $pin');

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ChangePasswordScreen(),
                              ),
                            );
                          } else {
                            setState(() {
                              _hasError = true;
                            });
                          }
                        },
                      ),

                      const SizedBox(height: 10),

                      // Back to Login Link
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

                      // 4. Spacer đẩy Footer xuống đáy
                      const Spacer(),

                      // 5. Footer bản quyền
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
