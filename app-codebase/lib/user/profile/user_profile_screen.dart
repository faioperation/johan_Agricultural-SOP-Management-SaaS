import 'package:farm_check_support/user/profile/controller/user_profile_controller.dart';
import 'package:farm_check_support/user/profile/widget/edit_profile_sheet.dart';
import 'package:farm_check_support/user/profile/widget/language_sheet.dart';
import 'package:farm_check_support/user/profile/widget/password_change_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserProfileScreen extends GetView<UserProfileController> {
  const UserProfileScreen({super.key});

  final String defaultProfileImage =
      'https://cdn-icons-png.flaticon.com/512/3135/3135715.png';

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final w = mq.size.width;
    final h = mq.size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: RefreshIndicator(
        onRefresh: () => controller.fetchProfile(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              /// ================= HEADER =================
              Obx(() {
                final data = controller.profileData.value;
                return Container(
                  width: double.infinity,
                  padding: EdgeInsets.fromLTRB(
                    w * 0.04,
                    mq.padding.top + h * 0.02,
                    w * 0.04,
                    h * 0.025,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFA726),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(w * 0.07),
                      bottomRight: Radius.circular(w * 0.07),
                    ),
                  ),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: w * 0.1,
                            backgroundColor: Colors.white,
                            backgroundImage: NetworkImage(
                                data?.avatarUrl ?? defaultProfileImage
                            ),
                          ),

                          /// CAMERA ICON → (UI ONLY FOR NOW AS API DOESNT SUPPORT)
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () => _editProfileSheet(context, data?.name ?? ""),
                              child: Container(
                                padding: EdgeInsets.all(w * 0.02),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.edit,
                                  size: w * 0.045,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: h * 0.015),

                      Text(
                        data?.name ?? '...',
                        style: TextStyle(
                          fontSize: w * 0.045,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: h * 0.005),
                      Text(
                        data?.email ?? '...',
                        style: TextStyle(
                          fontSize: w * 0.032,
                          color: Colors.black87,
                        ),
                      ),

                      SizedBox(height: h * 0.015),

                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: w * 0.05,
                          vertical: h * 0.006,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          data?.farm?.name ?? 'Farm check',
                          style: TextStyle(fontSize: w * 0.03),
                        ),
                      ),
                    ],
                  ),
                );
              }),

              SizedBox(height: h * 0.02),

              /// ================= EMPLOYEE INFO =================
              Container(
                margin: EdgeInsets.symmetric(horizontal: w * 0.04),
                padding: EdgeInsets.all(w * 0.04),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF4FF),
                  borderRadius: BorderRadius.circular(w * 0.045),
                  border: Border.all(color: const Color(0xFFBFD4FF)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline,
                        color: Colors.blue, size: w * 0.05),
                    SizedBox(width: w * 0.02),
                    Expanded(
                      child: Text(
                        'Employee Account\nYour account has limited access.',
                        style: TextStyle(fontSize: w * 0.03),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: h * 0.025),

              /// ================= SETTINGS =================
              _item(
                context,
                icon: Icons.lock_outline,
                color: Colors.blue,
                title: 'Change Password',
                subtitle: 'Update your password',
                onTap: () => _changePasswordSheet(context),
              ),
              _item(
                context,
                icon: Icons.logout,
                color: Colors.red,
                title: 'Logout',
                subtitle: 'Sign out of your account',
                onTap: () => _logoutDialog(context),
              ),

              SizedBox(height: h * 0.03),
            ],
          ),
        ),
      ),
    );
  }

  /// ================= LIST ITEM =================
  Widget _item(
      BuildContext context, {
        required IconData icon,
        required Color color,
        required String title,
        required String subtitle,
        required VoidCallback onTap,
      }) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return InkWell(
      onTap: onTap,
      child: Container(
        margin:
        EdgeInsets.symmetric(horizontal: w * 0.04, vertical: h * 0.01),
        padding: EdgeInsets.all(w * 0.04),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(w * 0.045),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(w * 0.025),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(w * 0.03),
              ),
              child: Icon(icon, color: color, size: w * 0.055),
            ),
            SizedBox(width: w * 0.03),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: w * 0.038,
                    ),
                  ),
                  SizedBox(height: h * 0.004),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: w * 0.03,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios,
                size: w * 0.035, color: Colors.black45),
          ],
        ),
      ),
    );
  }

  /// ================= PASSWORD SHEET =================
  void _changePasswordSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const ChangePasswordSheet(),
    );
  }

  /// ================= EDIT PROFILE SHEET =================
  void _editProfileSheet(BuildContext context, String currentName) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => EditProfileSheet(currentName: currentName),
    );
  }

  /// ================= LOGOUT DIALOG =================
  void _logoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFE0E0),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.logout,
                    color: Colors.red,
                    size: 28,
                  ),
                ),

                const SizedBox(height: 14),

                /// TITLE
                const Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 8),

                /// DESCRIPTION
                const Text(
                  'Are you sure you want to logout\nfrom your account?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 22),

                /// ACTION BUTTONS
                Row(
                  children: [
                    /// CANCEL
                    Expanded(
                      child: SizedBox(
                        height: 46,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.black12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(dialogContext);
                          },
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    /// LOGOUT
                    Expanded(
                      child: SizedBox(
                        height: 46,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFFA726),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(dialogContext);
                            controller.logout();
                          },

                          child: const Text(
                            'Logout',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}