import 'package:farm_check_support/app/token_service.dart';
import 'package:farm_check_support/core/services/socket_service.dart';
import 'package:farm_check_support/user/home/model/employee_home_model.dart';
import 'package:farm_check_support/user/repo/user_repository.dart';
import 'package:get/get.dart';

class UserHomeController extends GetxController {
  final UserRepository _userRepository;

  UserHomeController(this._userRepository);

  final RxBool isLoading = false.obs;
  final Rx<EmployeeHomeData?> homeData = Rx<EmployeeHomeData?>(null);

  @override
  void onInit() {
    super.onInit();
    if (TokenService.isEmployee) {
      fetchHomeData();
    }
  }

  Future<void> fetchHomeData() async {
    isLoading.value = true;
    try {
      final response = await _userRepository.getEmployeeHomeData();
      if (response.isSuccess) {
        final model = EmployeeHomeResponse.fromJson(response.responseData);
        homeData.value = model.data;
        
        if (model.data?.employee?.id != null) {
          TokenService.userId = model.data!.employee!.id;
          try {
            Get.find<SocketService>().reidentify();
          } catch (e) {
            print('Could not find SocketService for re-identification: $e');
          }
        }
      } else {
        Get.snackbar("Error", response.errorMassage ?? "Failed to load home data");
      }
    } catch (e) {
      Get.snackbar("Error", "An unexpected error occurred: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
