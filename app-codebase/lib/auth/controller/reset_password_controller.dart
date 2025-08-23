import 'package:farm_check_support/app/token_service.dart';
import 'package:farm_check_support/auth/repo/auth_repository.dart';
import 'package:get/get.dart';

class ResetPasswordController extends GetxController {
  final AuthRepository _authRepository;
  ResetPasswordController(this._authRepository);

  var isLoading = false.obs;

  Future<bool> resetPassword(String password) async {
    isLoading.value = true;
    try {
      final response = await _authRepository.resetPassword(password: password);
      if (response.isSuccess) {
        // Clear temporary reset token
        await TokenService.clear();
        return true;
      } else {
        Get.snackbar("Error", response.errorMassage ?? "Failed to reset password",
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
