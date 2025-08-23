import 'package:farm_check_support/app/token_service.dart';
import 'package:farm_check_support/auth/repo/auth_repository.dart';
import 'package:farm_check_support/role/role_management.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final AuthRepository _authRepository;
  LoginController(this._authRepository);

  var isLoading = false.obs;

  Future<void> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      Get.snackbar("Error", "Email and Password are required",
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    isLoading.value = true;
    try {
      final response = await _authRepository.login(
        email: email,
        password: password,
      );

      if (response.isSuccess) {
        final data = response.responseData['data'];
        final accessToken = data['accessToken'];
        final refreshToken = data['refreshToken'];
        final user = data['user'];
        final role = user['role'];
        final userId = user['id'] ?? user['_id'];

        await TokenService.saveTokens(
          access: accessToken,
          refresh: refreshToken,
          role: role,
          id: userId?.toString(),
        );

        // Role based navigation logic preserving the UI structure
        final appShell = RoleManager.getAppShell(
          role: role,
        );

        if (appShell != null) {
          Get.offAll(() => appShell);
        } else {
          // Fallback if RoleManager doesn't handle the specific role yet
          Get.snackbar("Error", "Role not supported or invalid credentials mapping",
              snackPosition: SnackPosition.BOTTOM);
        }
      } else {
        Get.snackbar("Login Failed", response.errorMassage ?? "Invalid credentials",
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar("Error", "An unexpected error occurred: $e",
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }
}
