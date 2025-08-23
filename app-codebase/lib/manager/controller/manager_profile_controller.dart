import 'package:farm_check_support/app/token_service.dart';
import 'package:farm_check_support/core/services/socket_service.dart';
import 'package:farm_check_support/auth/screen/login_screen.dart';
import 'package:farm_check_support/manager/model/manager_profile_model.dart';
import 'package:farm_check_support/manager/repo/manager_repository.dart';
import 'package:get/get.dart';

class ManagerProfileController extends GetxController {
  final ManagerRepository _managerRepository;

  ManagerProfileController(this._managerRepository);

  final RxBool isLoading = false.obs;
  final RxBool isLoadingUpdate = false.obs;
  final RxBool isLoadingPassword = false.obs;
  final Rx<ManagerProfileData?> profileData = Rx<ManagerProfileData?>(null);

  @override
  void onInit() {
    super.onInit();
    if (TokenService.isManager) {
      fetchProfile();
    }
  }

  Future<void> fetchProfile() async {
    isLoading.value = true;
    try {
      final response = await _managerRepository.getProfile();
      if (response.isSuccess) {
        final model = ManagerProfileResponse.fromJson(response.responseData);
        profileData.value = model.data;
        if (model.data?.id != null) {
          TokenService.userId = model.data!.id;
          // Trigger socket identity since ID is now available
          try {
            Get.find<SocketService>().reidentify();
          } catch (e) {
            print('Could not find SocketService for re-identification: $e');
          }
        }
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
      final response = await _managerRepository.updateProfile(newName, imagePath: imagePath);
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

  Future<bool> changePassword(String currentPassword, String newPassword) async {
    isLoadingPassword.value = true;
    try {
      final response = await _managerRepository.changePassword(currentPassword, newPassword);
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
