import 'package:farm_check_support/app/app_shell.dart';
import 'package:farm_check_support/manager/employee/employee_list_screen.dart';
import 'package:farm_check_support/manager/home/home_screen.dart';
import 'package:farm_check_support/manager/messages/manager_message_screen.dart';
import 'package:farm_check_support/manager/sop/manager_sop_modules_screen.dart';
import 'package:farm_check_support/manager/sop/manager_sop_screen.dart';
import 'package:farm_check_support/manager/task/manager_task_screen.dart';
import 'package:farm_check_support/user/home/screen/home_screen.dart';
import 'package:farm_check_support/user/messages/user_message_screen.dart';
import 'package:farm_check_support/user/profile/user_profile_screen.dart';
import 'package:farm_check_support/user/sops/user_sop_modules_screen.dart';
import 'package:farm_check_support/user/task/user_task_screen.dart';
import 'package:flutter/material.dart';

class RoleManager {
  static Widget? getAppShell({
    String? email,
    String? password,
    String? role,
  }) {
    // API BASED ROLE
    if (role == 'MANAGER') {
      return _buildManagerShell();
    } else if (role == 'USER' || role == 'CUSTOMER' || role == 'EMPLOYEE') {
      return _buildUserShell();
    }

    return null;
  }

  static Widget _buildUserShell() {
    return AppShell(
      isManager: false,
      initialIndex: 0,
      pages: [
        Builder(
          builder: (context) {
            final shellState =
            context.findAncestorStateOfType<AppShellState>();

            return UserHomeScreen(
              onViewAllTasks: () {
                shellState?.setIndex(2);
              },
              onViewSop: (){
                shellState?.setIndex(1);
              },
              onViewMessage: (){
                shellState?.setIndex(3);
              },
            );
          },
        ),
        const UserSopModulesScreen(),
        const UserTasksScreen(),
        const UserMessagesScreen(),
        const UserProfileScreen(),
      ],
    );
  }

  static Widget _buildManagerShell() {
    return AppShell(
      isManager: true,
      pages: [
        Builder(
          builder: (context) {
            final shellState =
            context.findAncestorStateOfType<AppShellState>();

            return ManagerHomeScreen(
              onViewAllTasks: () {
                shellState?.setIndex(2);
              },
            );
          },
        ),
        const ManagerSopModulesScreen(),
        const ManagerTasksScreen(),
        const ManagerMessagesScreen(),
        const EmployeeListScreen(),
      ],
    );
  }
}

