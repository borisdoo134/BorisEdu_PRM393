import 'dart:async';

import 'package:flutter/material.dart';
import 'package:myfschools/common/widgets/login_signup/form_header.dart';
import 'package:myfschools/screens/forget-password/change-password.dart';
import 'package:myfschools/screens/login.dart';
import 'package:myfschools/utils/constants/TTexts.dart';
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
    startTimer(); // Bắt đầu đếm ngay khi vào màn hình
  }

  // Hàm xử lý đếm ngược
  // Sửa lại hàm startTimer một chút cho an toàn
  void startTimer() {
    setState(() {
      _canResend = false;
      _secondsRemaining = 30;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        // Kiểm tra mounted để đảm bảo màn hình còn tồn tại
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
    _timer?.cancel(); // Hủy timer khi thoát màn hình để tránh rò rỉ bộ nhớ
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf0f0f0),
      body: Padding(
        padding: const EdgeInsets.only(
          left: 24.0,
          right: 24.0,
          bottom: 24.0,
          top: 190.0,
        ),
        child: Column(
          children: [
            //Header
            FormHeader(title: TTexts.otpTitle, subTitle: TTexts.otpSubTitle),

            const SizedBox(height: 30),

            Form(
              key: _keyForm,
              child: Pinput(
                controller: _pinController,
                length: 6,
                forceErrorState: _hasError,

                pinputAutovalidateMode: PinputAutovalidateMode.disabled,

                onChanged: (value) {
                  if (_hasError) {
                    setState(() {
                      _hasError = false;
                    });
                  }
                },

                validator: (value) {
                  if (value == null || value.isEmpty || value.length < 6) {
                    return 'Vui lòng nhập đủ mã OTP!';
                  }
                  return null;
                },
                errorTextStyle: const TextStyle(
                  color: Colors.red, // Chữ màu đỏ
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                errorPinTheme: PinTheme(
                  width: 56,
                  height: 64,
                  textStyle: const TextStyle(fontSize: 22, color: Colors.red),
                  // Số bên trong cũng màu đỏ
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.red,
                    ), // Viền chuyển sang đỏ
                  ),
                ),
                preFilledWidget: const Text(
                  '.',
                  style: TextStyle(color: Colors.black, fontSize: 24),
                ),
                defaultPinTheme: PinTheme(
                  width: 56,
                  height: 64,
                  textStyle: const TextStyle(fontSize: 22, color: Colors.black),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black),
                  ),
                ),
                // Giao diện khi đang nhập (Focus)
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

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: _canResend
                      ? () {
                          // Gửi lại mã OTP ở đây
                          print("Đã gửi lại mã!");
                          startTimer(); // Reset bộ đếm
                        }
                      : null,
                  child: Text(
                    TTexts.resendOtp,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      // Nếu nút bị disable thì cho màu xám, nếu active thì màu xanh
                      color: _canResend ? Colors.green : Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (!_canResend) // Chỉ hiện khi đang đếm ngược
                  Text(
                    "(${_secondsRemaining}s)",
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(color: Colors.grey),
                  ),
              ],
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final pin = _pinController.text;
                  if (_keyForm.currentState!.validate()) {
                    setState(() => _hasError = false);
                    print('Mã OTP là: ' + pin);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ChangePasswordScreen(),
                      ),
                    );
                  } else {
                    // KHÔNG Hợp lệ -> Bật đèn đỏ lên
                    setState(() {
                      _hasError = true;
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[600],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(15),
                ),
                child: const Text(TTexts.verifyOtp),
              ),
            ),

            const SizedBox(height: 10),

            //Back to Login Page
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                  child: Text(
                    TTexts.backToLogin,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
