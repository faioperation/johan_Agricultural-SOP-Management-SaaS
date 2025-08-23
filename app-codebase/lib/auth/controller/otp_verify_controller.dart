import 'package:farm_check_support/app/token_service.dart';
import 'package:farm_check_support/auth/repo/auth_repository.dart';
import 'package:get/get.dart';

class OtpVerifyController extends GetxController {
  final AuthRepository _authRepository;
  OtpVerifyController(this._authRepository);

  var isLoading = false.obs;

  Future<bool> verifyOtp(String email, String otp) async {
    if (otp.length != 6) {
      Get.snackbar("Error", "Enter 6 digit OTP",
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }

    isLoading.value = true;
    try {
      final response = await _authRepository.verifyForgotOtp(email: email, otp: otp);
      if (response.isSuccess) {
        final resetToken = response.responseData['data']?['resetToken'];
        if (resetToken != null) {
          // Temporarily save resetToken as accessToken for the reset call
          await TokenService.saveTokens(access: resetToken);
          return true;
        } else {
          Get.snackbar("Error", "Reset token not received",
              snackPosition: SnackPosition.BOTTOM);
          return false;
        }
      } else {
        Get.snackbar("Error", response.errorMassage ?? "Invalid OTP",
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
