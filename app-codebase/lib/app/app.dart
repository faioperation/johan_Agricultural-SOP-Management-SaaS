import 'package:farm_check_support/app/controller_binding.dart';
import 'package:farm_check_support/app/token_service.dart';
import 'package:farm_check_support/auth/screen/login_screen.dart';
import 'package:farm_check_support/role/role_management.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FarmCheckSupport extends StatelessWidget {
  const FarmCheckSupport({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: ControllerBinder(),
      home: _getInitialScreen(),
    );
  }

  Widget _getInitialScreen() {
    if (TokenService.isLoggedIn) {
      final shell = RoleManager.getAppShell(role: TokenService.userRole);
      if (shell != null) {
        return shell;
      }
    }
    return const LoginScreen();
  }
}
