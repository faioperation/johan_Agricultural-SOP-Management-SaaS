import 'package:farm_check_support/user/profile/controller/user_profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangePasswordSheet extends StatefulWidget {
  const ChangePasswordSheet({super.key});

  @override
  State<ChangePasswordSheet> createState() => _ChangePasswordSheetState();
}

class _ChangePasswordSheetState extends State<ChangePasswordSheet> {
  final UserProfileController controller = Get.find<UserProfileController>();
  
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool hideCurrent = true;
  bool hideNew = true;
  bool hideConfirm = true;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final w = mq.size.width;
    final h = mq.size.height;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        w * 0.04,
        h * 0.02,
        w * 0.04,
        mq.viewInsets.bottom + h * 0.02,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔘 TITLE
          Center(
            child: Column(
              children: [
                Container(
                  width: w * 0.12,
                  height: h * 0.006,
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                SizedBox(height: h * 0.015),
                Text(
                  'Change Password',
                  style: TextStyle(
                    fontSize: w * 0.045,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: h * 0.025),

          /// CURRENT PASSWORD
          _passwordField(
            w: w,
            controller: _currentPasswordController,
            hint: 'Current Password',
            obscure: hideCurrent,
            onToggle: () => setState(() => hideCurrent = !hideCurrent),
          ),

          /// NEW PASSWORD
          _passwordField(
            w: w,
            controller: _newPasswordController,
            hint: 'New Password',
            obscure: hideNew,
            onToggle: () => setState(() => hideNew = !hideNew),
          ),

          /// CONFIRM PASSWORD
          _passwordField(
            w: w,
            controller: _confirmPasswordController,
            hint: 'Confirm Password',
            obscure: hideConfirm,
            onToggle: () => setState(() => hideConfirm = !hideConfirm),
          ),

          SizedBox(height: h * 0.02),

          /// BUTTONS
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: h * 0.055,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.black12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(w * 0.035),
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: w * 0.038,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: w * 0.03),
              Expanded(
                child: SizedBox(
                  height: h * 0.055,
                  child: Obx(() => ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFA726),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(w * 0.035),
                      ),
                    ),
                    onPressed: controller.isLoadingPassword.value ? null : () async {
                      final current = _currentPasswordController.text;
                      final newPass = _newPasswordController.text;
                      final confirm = _confirmPasswordController.text;

                      if (current.isEmpty || newPass.isEmpty) {
                        Get.snackbar("Error", "Fields cannot be empty");
                        return;
                      }

                      if (newPass != confirm) {
                        Get.snackbar("Error", "Passwords do not match");
                        return;
                      }

                      final success = await controller.changePassword(current, newPass);
                      if (success) {
                        Navigator.pop(context);
                      }
                    },
                    child: controller.isLoadingPassword.value
                        ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
                    )
                        : Text(
                      'Save',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: w * 0.038,
                      ),
                    ),
                  )),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// ================= PASSWORD FIELD =================
  Widget _passwordField({
    required double w,
    required TextEditingController controller,
    required String hint,
    required bool obscure,
    required VoidCallback onToggle,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: w * 0.03),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(fontSize: w * 0.036),
          filled: true,
          fillColor: const Color(0xFFF7F7F7),
          suffixIcon: IconButton(
            icon: Icon(
              obscure ? Icons.visibility_off : Icons.visibility,
              size: w * 0.055,
              color: Colors.black54,
            ),
            onPressed: onToggle,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(w * 0.035),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
