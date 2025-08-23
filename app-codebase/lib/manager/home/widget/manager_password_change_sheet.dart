import 'package:farm_check_support/manager/controller/manager_profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ManagerPasswordChangeSheet extends StatefulWidget {
  const ManagerPasswordChangeSheet({super.key});

  @override
  State<ManagerPasswordChangeSheet> createState() => _ManagerPasswordChangeSheetState();
}

class _ManagerPasswordChangeSheetState extends State<ManagerPasswordChangeSheet> {
  final ManagerProfileController controller = Get.find<ManagerProfileController>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscureOld = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _oldPasswordController.dispose();
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
          SizedBox(height: h * 0.03),

          _label('Old Password', w),
          _field(_oldPasswordController, _obscureOld, (v) => setState(() => _obscureOld = v), w),
          SizedBox(height: h * 0.02),

          _label('New Password', w),
          _field(_newPasswordController, _obscureNew, (v) => setState(() => _obscureNew = v), w),
          SizedBox(height: h * 0.02),

          _label('Confirm New Password', w),
          _field(_confirmPasswordController, _obscureConfirm, (v) => setState(() => _obscureConfirm = v), w),
          SizedBox(height: h * 0.04),

          SizedBox(
            width: double.infinity,
            height: h * 0.06,
            child: Obx(() => ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFA726),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(w * 0.035),
                    ),
                  ),
                  onPressed: controller.isLoadingPassword.value
                      ? null
                      : () async {
                          if (_oldPasswordController.text.isEmpty ||
                              _newPasswordController.text.isEmpty ||
                              _confirmPasswordController.text.isEmpty) {
                            Get.snackbar("Error", "Please fill all fields");
                            return;
                          }
                          if (_newPasswordController.text != _confirmPasswordController.text) {
                            Get.snackbar("Error", "Passwords do not match");
                            return;
                          }
                          final success = await controller.changePassword(
                            _oldPasswordController.text,
                            _newPasswordController.text,
                          );
                          if (success) Navigator.pop(context);
                        },
                  child: controller.isLoadingPassword.value
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
                        )
                      : const Text(
                          'Update Password',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                )),
          ),
        ],
      ),
    );
  }

  Widget _label(String text, double w) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: w * 0.035,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _field(TextEditingController ctrl, bool obscure, Function(bool) toggle, double w) {
    return TextField(
      controller: ctrl,
      obscureText: obscure,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFF7F7F7),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(w * 0.035),
          borderSide: BorderSide.none,
        ),
        suffixIcon: IconButton(
          icon: Icon(obscure ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
          onPressed: () => toggle(!obscure),
        ),
      ),
    );
  }
}
