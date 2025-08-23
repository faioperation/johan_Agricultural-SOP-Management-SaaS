import 'package:farm_check_support/auth/controller/reset_password_controller.dart';
import 'package:farm_check_support/auth/screen/password_change_success_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SetNewPasswordScreen extends StatefulWidget {
  const SetNewPasswordScreen({super.key});

  @override
  State<SetNewPasswordScreen> createState() => _SetNewPasswordScreenState();
}

class _SetNewPasswordScreenState extends State<SetNewPasswordScreen> {
  final _resetController = Get.find<ResetPasswordController>();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool hideNew = true;
  bool hideConfirm = true;

  void handleResetPassword() async {
    final newPass = newPasswordController.text.trim();
    final confirmPass = confirmPasswordController.text.trim();

    if (newPass.isEmpty || confirmPass.isEmpty) {
      Get.snackbar("Error", "Please fill all fields",
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    if (newPass != confirmPass) {
      Get.snackbar("Error", "Passwords do not match",
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    final success = await _resetController.resetPassword(newPass);

    if (success) {
      Get.offAll(() => const PasswordUpdatedSuccessScreen());
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// TITLE
                  Center(
                    child: Text(
                      'Set a New Password',
                      style: TextStyle(
                        fontSize: w * 0.045,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  SizedBox(height: h * 0.03),

                  /// NEW PASSWORD
                  Text(
                    'New Password',
                    style: TextStyle(
                      fontSize: w * 0.035,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: h * 0.008),
                  _passwordField(
                    controller: newPasswordController,
                    obscure: hideNew,
                    onToggle: () => setState(() => hideNew = !hideNew),
                  ),

                  SizedBox(height: h * 0.02),

                  /// CONFIRM PASSWORD
                  Text(
                    'Confirm Password',
                    style: TextStyle(
                      fontSize: w * 0.035,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: h * 0.008),
                  _passwordField(
                    controller: confirmPasswordController,
                    obscure: hideConfirm,
                    onToggle: () =>
                        setState(() => hideConfirm = !hideConfirm),
                  ),

                  SizedBox(height: h * 0.03),

                  /// RESET BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: h * 0.06,
                    child: Obx(() => ElevatedButton(
                      onPressed: _resetController.isLoading.value ? null : handleResetPassword,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFA726),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _resetController.isLoading.value
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.black,
                              ),
                            )
                          : Text(
                              'Reset Password',
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

  /// ================= PASSWORD FIELD =================
  Widget _passwordField({
    required TextEditingController controller,
    required bool obscure,
    required VoidCallback onToggle,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFF7F7F7),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            color: Colors.grey,
          ),
          onPressed: onToggle,
        ),
      ),
    );
  }
}
