import 'package:farm_check_support/manager/controller/manager_profile_controller.dart';
import 'package:farm_check_support/manager/home/widget/edit_manager_profile_sheet.dart';
import 'package:farm_check_support/manager/home/widget/manager_password_change_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ManagerProfileScreen extends GetView<ManagerProfileController> {
  const ManagerProfileScreen({super.key});

  final String defaultProfileImage =
      'https://cdn-icons-png.flaticon.com/512/3135/3135715.png';

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final w = mq.size.width;
    final h = mq.size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        leadingWidth: w * 0.1,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: w * 0.045,
          ),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Profile',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black,
            fontSize: w * 0.045,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => controller.fetchProfile(),
        child: ListView(
          padding: EdgeInsets.all(w * 0.04),
          children: [
            Text(
              'Your account and preferences',
              style: TextStyle(
                fontSize: w * 0.032,
                color: Colors.black54,
              ),
            ),
            SizedBox(height: h * 0.02),

            /// ================= PROFILE CARD =================
            Obx(() {
              final data = controller.profileData.value;
              return Container(
                padding: EdgeInsets.all(w * 0.04),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(w * 0.04),
                ),
                child: Row(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: w * 0.09,
                          backgroundColor: const Color(0xFFD1FADF),
                          backgroundImage: NetworkImage(data?.avatarUrl ?? defaultProfileImage),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: InkWell(
                            onTap: () => _editProfileSheet(context, data?.name ?? ""),
                            child: Container(
                              width: w * 0.07,
                              height: w * 0.07,
                              decoration: const BoxDecoration(
                                color: Colors.orange,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.edit,
                                size: w * 0.04,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: w * 0.04),

                    /// INFO
                    Expanded(
                      child: controller.isLoading.value
                          ? const Center(child: CircularProgressIndicator())
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data?.name ?? 'Loading...',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: w * 0.04,
                                  ),
                                ),
                                SizedBox(height: h * 0.004),
                                Text(
                                  data?.email ?? '...',
                                  style: TextStyle(
                                    fontSize: w * 0.032,
                                    color: Colors.black54,
                                  ),
                                ),
                                SizedBox(height: h * 0.004),
                                Text(
                                  data?.farmName ?? '...',
                                  style: TextStyle(
                                    fontSize: w * 0.032,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ],
                ),
              );
            }),

            SizedBox(height: h * 0.03),

            /// ================= SETTINGS =================
            Text(
              'SETTINGS',
              style: TextStyle(
                fontSize: w * 0.03,
                fontWeight: FontWeight.w600,
                color: Colors.black45,
              ),
            ),
            SizedBox(height: h * 0.015),

            _item(
              w: w,
              icon: Icons.person_outline,
              color: Colors.blue,
              title: 'Edit Profile',
              subtitle: 'Update your name and photo',
              onTap: () => _editProfileSheet(context, controller.profileData.value?.name ?? ""),
            ),

            _item(
              w: w,
              icon: Icons.lock_outline,
              color: Colors.blue,
              title: 'Change Password',
              subtitle: 'Update your password',
              onTap: () => _changePasswordSheet(context),
            ),

            SizedBox(height: h * 0.03),

            /// ================= GENERAL =================
            Text(
              'GENERAL',
              style: TextStyle(
                fontSize: w * 0.03,
                fontWeight: FontWeight.w600,
                color: Colors.black45,
              ),
            ),
            SizedBox(height: h * 0.015),

            _item(
              w: w,
              icon: Icons.logout,
              color: Colors.red,
              title: 'Logout',
              subtitle: 'Sign out of your account',
              onTap: () => _logoutDialog(context, w),
            ),
          ],
        ),
      ),
    );
  }

  void _editProfileSheet(BuildContext context, String currentName) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => EditManagerProfileSheet(currentName: currentName),
    );
  }

  void _changePasswordSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const ManagerPasswordChangeSheet(),
    );
  }

  /// ================= ITEM TILE =================
  Widget _item({
    required double w,
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: w * 0.015),
        padding: EdgeInsets.all(w * 0.04),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(w * 0.04),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(w * 0.025),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(w * 0.03),
              ),
              child: Icon(icon, color: color, size: w * 0.05),
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
                      fontSize: w * 0.035,
                    ),
                  ),
                  SizedBox(height: w * 0.01),
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
                size: w * 0.035, color: Colors.black54),
          ],
        ),
      ),
    );
  }

  /// ================= LOGOUT DIALOG =================
  void _logoutDialog(BuildContext context, double w) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: Padding(
            padding: EdgeInsets.all(w * 0.05),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.logout, color: Colors.red, size: w * 0.12),
                SizedBox(height: w * 0.04),
                Text(
                  'Logout',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: w * 0.045,
                  ),
                ),
                SizedBox(height: w * 0.02),
                Text(
                  'Are you sure you want to logout?',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: w * 0.035),
                ),
                SizedBox(height: w * 0.06),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(dialogContext),
                        child: Text(
                          'Cancel',
                          style: TextStyle(fontSize: w * 0.035),
                        ),
                      ),
                    ),
                    SizedBox(width: w * 0.03),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFA726),
                        ),
                        onPressed: () {
                          Navigator.pop(dialogContext); // Close dialog
                          controller.logout(); // Use controller logout
                        },
                        child: Text(
                          'Logout',
                          style: TextStyle(
                            fontSize: w * 0.035,
                            color: Colors.black,
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
