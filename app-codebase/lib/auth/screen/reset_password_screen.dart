import 'package:farm_check_support/auth/controller/forgot_password_controller.dart';
import 'package:farm_check_support/auth/screen/otp_verify_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _forgotPasswordController = Get.find<ForgotPasswordController>();
  final emailController = TextEditingController();

  void handleSend() async {
    final success = await _forgotPasswordController.forgotPassword(
      emailController.text.trim(),
    );

    if (success) {
      Get.to(() => OtpVerifyScreen(email: emailController.text.trim()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final w = mq.size.width;
    final h = mq.size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF6E9),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: h * 0.12),

            /// LOGO
            Center(
              child: Image.asset(
                'assets/images/logo.png',
                height: h * 0.16,
              ),
            ),

            SizedBox(height: h * 0.12),

            /// CARD
            Container(
              margin: EdgeInsets.symmetric(horizontal: w * 0.06),
              padding: EdgeInsets.all(w * 0.05),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  /// TITLE
                  Text(
                    'Reset Password',
                    style: TextStyle(
                      fontSize: w * 0.045,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  SizedBox(height: h * 0.008),

                  /// SUBTITLE
                  Text(
                    'Enter your email to receive a reset link',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: w * 0.032,
                      color: Colors.black54,
                    ),
                  ),

                  SizedBox(height: h * 0.025),

                  /// EMAIL LABEL
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Email Address',
                      style: TextStyle(
                        fontSize: w * 0.035,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  SizedBox(height: h * 0.008),

                  /// EMAIL FIELD
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: 'admin@example.com',
                      prefixIcon: Icon(
                        Icons.email_outlined,
                        size: w * 0.05,
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF7F7F7),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  SizedBox(height: h * 0.03),

                  /// SEND BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: h * 0.06,
                    child: Obx(() => ElevatedButton(
                      onPressed: _forgotPasswordController.isLoading.value ? null : handleSend,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFA726),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: _forgotPasswordController.isLoading.value
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.black,
                              ),
                            )
                          : Text(
                              'Send',
                              style: TextStyle(
                                fontSize: w * 0.04,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                    )),
                  ),
                ],
              ),
            ),

            const Spacer(),
            SizedBox(height: h * 0.02),
          ],
        ),
      ),
    );
  }
}
