import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myfschools/screens/forget_password/forget_password.dart';
import 'package:myfschools/screens/home.dart';
import 'package:myfschools/controllers/auth/auth_controller.dart';
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
  bool _rememberPassword = false;

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  Future<void> _loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final savedPhone = prefs.getString('REMEMBER_PHONE');
    final savedPassword = prefs.getString('REMEMBER_PASSWORD');
    
    if (savedPhone != null && savedPassword != null) {
      if (mounted) {
        setState(() {
          _phoneController.text = savedPhone;
          _passwordController.text = savedPassword;
          _rememberPassword = true;
        });
      }
    }
  }

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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Checkbox(
                                      value: _rememberPassword,
                                      onChanged: (value) {
                                        setState(() {
                                          _rememberPassword = value ?? false;
                                        });
                                      },
                                      activeColor: Colors.green,
                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    const Text("Nhớ mật khẩu"),
                                  ],
                                ),
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

                            Row(
                              children: [
                                Expanded(
                                  child: PrimaryButton(
                                    text: TTexts.signIn,
                                    trailingIcon: Icons.arrow_forward_ios,
                                    onPressed: () async {
                                      if (_keyForm.currentState!.validate()) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text('Đang đăng nhập...'),
                                          ),
                                        );

                                        bool isSuccess =
                                            await AuthController.loginUser(
                                              _phoneController.text.trim(),
                                              _passwordController.text,
                                            );

                                        if (context.mounted) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).hideCurrentSnackBar(); // Ẩn snackbar loading
                                          if (isSuccess) {
                                              final prefs = await SharedPreferences.getInstance();
                                              if (_rememberPassword) {
                                                await prefs.setString('REMEMBER_PHONE', _phoneController.text.trim());
                                                await prefs.setString('REMEMBER_PASSWORD', _passwordController.text);
                                              } else {
                                                await prefs.remove('REMEMBER_PHONE');
                                                await prefs.remove('REMEMBER_PASSWORD');
                                              }

                                              if (!context.mounted) return;
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const HomeScreen(),
                                                ),
                                              );
                                            } else {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  'Sai số điện thoại hoặc mật khẩu!',
                                                ),
                                              ),
                                            );
                                          }
                                        }
                                      }
                                    },
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Container(
                                  width: 54,
                                  height: 54,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: Colors.grey.shade200,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.05,
                                        ),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(16),
                                      onTap: () {
                                        // Xử lý đăng nhập bằng vân tay
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Chức năng đăng nhập vân tay đang phát triển',
                                            ),
                                          ),
                                        );
                                      },
                                      child: const Icon(
                                        Icons.fingerprint,
                                        color: Colors.green,
                                        size: 32,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
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
