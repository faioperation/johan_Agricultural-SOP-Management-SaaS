import 'package:farm_check_support/app/token_service.dart';
import 'package:farm_check_support/auth/screen/login_screen.dart';
import 'package:farm_check_support/user/profile/model/employee_profile_model.dart';
import 'package:farm_check_support/user/repo/user_repository.dart';
import 'package:get/get.dart';

class UserProfileController extends GetxController {
  final UserRepository _userRepository;

  UserProfileController(this._userRepository);

  final RxBool isLoading = false.obs;
  final RxBool isLoadingUpdate = false.obs;
  final RxBool isLoadingPassword = false.obs;
  final Rx<EmployeeProfileData?> profileData = Rx<EmployeeProfileData?>(null);

  @override
  void onInit() {
    super.onInit();
    if (TokenService.isEmployee) {
      fetchProfile();
    }
  }

  Future<void> fetchProfile() async {
    isLoading.value = true;
    try {
      final response = await _userRepository.getProfile();
      if (response.isSuccess) {
        final model = EmployeeProfileResponse.fromJson(response.responseData);
        profileData.value = model.data;
      } else {
        Get.snackbar("Error", response.errorMassage ?? "Failed to load profile");
      }
    } catch (e) {
      Get.snackbar("Error", "An unexpected error occurred: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateProfile(String newName, {String? imagePath}) async {
    isLoadingUpdate.value = true;
    try {
      final response = await _userRepository.updateProfile(newName, imagePath: imagePath);
      if (response.isSuccess) {
        Get.snackbar("Success", "Profile updated successfully");
        fetchProfile(); // Refresh profile data
        return true;
      } else {
        Get.snackbar("Error", response.errorMassage ?? "Failed to update profile");
        return false;
      }
    } catch (e) {
      Get.snackbar("Error", "An unexpected error occurred: $e");
      return false;
    } finally {
      isLoadingUpdate.value = false;
    }
  }

  Future<bool> changePassword(String oldPassword, String newPassword) async {
    isLoadingPassword.value = true;
    try {
      final response = await _userRepository.changePassword(oldPassword, newPassword);
      if (response.isSuccess) {
        Get.snackbar("Success", "Password changed successfully");
        return true;
      } else {
        Get.snackbar("Error", response.errorMassage ?? "Failed to change password");
        return false;
      }
    } catch (e) {
      Get.snackbar("Error", "An unexpected error occurred: $e");
      return false;
    } finally {
      isLoadingPassword.value = false;
    }
  }

  Future<void> logout() async {
    await TokenService.clear();
    Get.offAll(() => const LoginScreen());
  }
}
