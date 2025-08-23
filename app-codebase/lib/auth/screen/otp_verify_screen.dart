import 'package:farm_check_support/auth/controller/otp_verify_controller.dart';
import 'package:farm_check_support/auth/screen/set_new_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpVerifyScreen extends StatefulWidget {
  final String email;
  const OtpVerifyScreen({super.key, required this.email});

  @override
  State<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends State<OtpVerifyScreen> {
  final _otpController = Get.find<OtpVerifyController>();
  String otpCode = '';

  void handleVerify() async {
    final success = await _otpController.verifyOtp(widget.email, otpCode);

    if (success) {
      Get.to(() => const SetNewPasswordScreen());
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
            SizedBox(height: h * 0.08),

            /// LOGO
            Center(
              child: Image.asset(
                'assets/images/logo.png',
                height: h * 0.16,
              ),
            ),

            const Spacer(),

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
                    'Verify OTP',
                    style: TextStyle(
                      fontSize: w * 0.045,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  SizedBox(height: h * 0.008),

                  /// SUBTITLE
                  Text(
                    'Enter the 6 digit code sent to your email',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: w * 0.032,
                      color: Colors.black54,
                    ),
                  ),

                  SizedBox(height: h * 0.03),

                  /// OTP INPUT
                  PinCodeTextField(
                    appContext: context,
                    length: 6,
                    keyboardType: TextInputType.number,
                    animationType: AnimationType.fade,
                    cursorColor: Colors.black,
                    animationDuration:
                    const Duration(milliseconds: 300),
                    enableActiveFill: true,
                    textStyle: TextStyle(
                      fontSize: w * 0.045,
                      fontWeight: FontWeight.w600,
                    ),
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(10),
                      fieldHeight: w * 0.13,
                      fieldWidth: w * 0.11,
                      activeFillColor: const Color(0xFFF7F7F7),
                      inactiveFillColor: const Color(0xFFF7F7F7),
                      selectedFillColor: const Color(0xFFF7F7F7),
                      activeColor: Colors.transparent,
                      inactiveColor: Colors.transparent,
                      selectedColor: const Color(0xFFFFA726),
                    ),
                    onChanged: (value) {
                      otpCode = value;
                    },
                  ),

                  SizedBox(height: h * 0.03),

                  /// VERIFY BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: h * 0.06,
                    child: Obx(() => ElevatedButton(
                      onPressed: _otpController.isLoading.value ? null : handleVerify,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFA726),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: _otpController.isLoading.value
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.black,
                              ),
                            )
                          : Text(
                              'Verify',
                              style: TextStyle(
                                fontSize: w * 0.04,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                    )),
                  ),

                  SizedBox(height: h * 0.015),

                  /// RESEND
                  TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('OTP Resent')),
                      );
                    },
                    child: Text(
                      'Resend Code',
                      style: TextStyle(
                        fontSize: w * 0.032,
                        color: Colors.black54,
                      ),
                    ),
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
