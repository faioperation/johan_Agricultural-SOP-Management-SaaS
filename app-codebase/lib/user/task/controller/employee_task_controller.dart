import 'package:farm_check_support/app/token_service.dart';
import 'package:farm_check_support/user/repo/user_repository.dart';
import 'package:farm_check_support/user/task/model/employee_task_model.dart';
import 'package:get/get.dart';

class EmployeeTaskController extends GetxController {
  final UserRepository _userRepository;

  EmployeeTaskController(this._userRepository);

  final RxBool isLoading = false.obs;
  final RxList<EmployeeTask> tasks = <EmployeeTask>[].obs;
  final RxInt selectedTab = 0.obs;

  @override
  void onInit() {
    super.onInit();
    if (!TokenService.isManager) {
      fetchTasks();
    }
  }

  Future<void> fetchTasks() async {
    isLoading.value = true;
    try {
      final response = await _userRepository.getEmployeeTasks();
      if (response.isSuccess) {
        final model = EmployeeTaskResponse.fromJson(response.responseData);
        tasks.assignAll(model.data ?? []);
      } else {
        Get.snackbar("Error", response.errorMassage ?? "Failed to load tasks");
      }
    } catch (e) {
      Get.snackbar("Error", "An unexpected error occurred: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void selectTab(int index) {
    selectedTab.value = index;
  }

  List<EmployeeTask> get todayTasks => tasks.where((t) {
    if (t.scheduledAt == null) return false;
    final scheduledDate = DateTime.parse(t.scheduledAt!).toLocal();
    final now = DateTime.now();
    return scheduledDate.year == now.year &&
           scheduledDate.month == now.month &&
           scheduledDate.day == now.day &&
           !isUpcoming(t);
  }).toList();

  List<EmployeeTask> get upcomingTasks => tasks.where((t) => isUpcoming(t)).toList();

  List<EmployeeTask> get completedTasks => tasks.where((t) => t.isCompleted).toList();

  bool isUpcoming(EmployeeTask task) {
    if (task.scheduledAt == null) return false;
    final scheduledDate = DateTime.parse(task.scheduledAt!).toLocal();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final taskDay = DateTime(scheduledDate.year, scheduledDate.month, scheduledDate.day);
    return taskDay.isAfter(today);
  }

  int get completedTodayCount => todayTasks.where((t) => t.isCompleted).length;

  Future<void> completeTask(String id, String? note) async {
    isLoading.value = true;
    try {
      final response = await _userRepository.completeTask(id, note);
      if (response.isSuccess) {
        Get.snackbar("Success", "Task marked as completed");
        await fetchTasks(); // Refresh list
      } else {
        Get.snackbar("Error", response.errorMassage ?? "Failed to complete task");
      }
    } catch (e) {
      Get.snackbar("Error", "An unexpected error occurred: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
