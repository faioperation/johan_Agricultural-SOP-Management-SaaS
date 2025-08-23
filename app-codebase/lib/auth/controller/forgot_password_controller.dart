import 'package:farm_check_support/auth/repo/auth_repository.dart';
import 'package:get/get.dart';

class ForgotPasswordController extends GetxController {
  final AuthRepository _authRepository;
  ForgotPasswordController(this._authRepository);

  var isLoading = false.obs;

  Future<bool> forgotPassword(String email) async {
    if (email.isEmpty) {
      Get.snackbar("Error", "Email is required",
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }

    isLoading.value = true;
    try {
      final response = await _authRepository.forgotPassword(email: email);
      if (response.isSuccess) {
        Get.snackbar("Success", response.responseData?['message'] ?? "OTP sent to your email",
            snackPosition: SnackPosition.BOTTOM);
        return true;
      } else {
        Get.snackbar("Error", response.errorMassage ?? "Failed to send OTP",
            snackPosition: SnackPosition.BOTTOM);
        return false;
      }
    } catch (e) {
      Get.snackbar("Error", e.toString(),
          snackPosition: SnackPosition.BOTTOM);
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
