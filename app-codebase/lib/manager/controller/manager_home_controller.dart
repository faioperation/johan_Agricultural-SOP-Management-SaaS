import 'package:farm_check_support/app/token_service.dart';
import 'package:farm_check_support/manager/model/manager_dashboard_model.dart';
import 'package:farm_check_support/manager/repo/manager_repository.dart';
import 'package:get/get.dart';

class ManagerHomeController extends GetxController {
  final ManagerRepository _managerRepository;

  ManagerHomeController(this._managerRepository);

  final RxBool isLoading = false.obs;
  final Rx<DashboardCards?> cards = Rx<DashboardCards?>(null);
  final RxList<TodayTask> todayTasks = <TodayTask>[].obs;

  @override
  void onInit() {
    super.onInit();
    if (TokenService.isManager) {
      fetchDashboardData();
    }
  }

  Future<void> fetchDashboardData() async {
    isLoading.value = true;
    try {
      final response = await _managerRepository.getDashboardData();
      if (response.isSuccess) {
        final model = ManagerDashboardModel.fromJson(response.responseData);
        cards.value = model.data?.cards;
        todayTasks.value = model.data?.todayTasks ?? [];
      } else {
        Get.snackbar("Error", response.errorMassage ?? "Failed to load dashboard data");
      }
    } catch (e) {
      Get.snackbar("Error", "An unexpected error occurred: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
