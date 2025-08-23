import 'package:farm_check_support/app/token_service.dart';
import 'package:farm_check_support/manager/repo/manager_repository.dart';
import 'package:farm_check_support/manager/task/model/manager_task_model.dart';
import 'package:get/get.dart';

class ManagerTaskController extends GetxController {
  final ManagerRepository _managerRepository;

  ManagerTaskController(this._managerRepository);

  final RxBool isLoading = false.obs;
  final RxList<ManagerTask> allTasks = <ManagerTask>[].obs;
  final RxList<ManagerTask> filteredTasks = <ManagerTask>[].obs;
  final RxInt selectedTab = 0.obs; // 0=ALL, 1=Pending, 2=Completed
  final RxString searchText = ''.obs;

  @override
  void onInit() {
    super.onInit();
    if (TokenService.isManager) {
      fetchTasks();
    }
  }

  Future<void> fetchTasks() async {
    isLoading.value = true;
    try {
      final response = await _managerRepository.getManagerTasks();
      if (response.isSuccess) {
        final model = ManagerTaskResponse.fromJson(response.responseData);
        allTasks.value = model.data ?? [];
        applyFilter();
      } else {
        Get.snackbar("Error", response.errorMassage ?? "Failed to load tasks");
      }
    } catch (e) {
      Get.snackbar("Error", "An unexpected error occurred: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void setFilter(int index) {
    selectedTab.value = index;
    applyFilter();
  }

  void searchTasks(String query) {
    searchText.value = query;
    applyFilter();
  }

  void applyFilter() {
    List<ManagerTask> tempTasks = allTasks;

    // 1. Filter by Tab
    if (selectedTab.value == 1) {
      tempTasks = tempTasks
          .where((t) => t.status?.toUpperCase() == 'PENDING')
          .toList();
    } else if (selectedTab.value == 2) {
      tempTasks = tempTasks
          .where((t) => t.status?.toUpperCase() == 'COMPLETED')
          .toList();
    }

    // 2. Filter by Search Query
    if (searchText.value.isNotEmpty) {
      final query = searchText.value.toLowerCase();
      tempTasks = tempTasks.where((t) {
        final title = t.title?.toLowerCase() ?? '';
        final description = t.description?.toLowerCase() ?? '';
        final assignee = t.assignedTo?.name?.toLowerCase() ?? '';
        return title.contains(query) ||
            description.contains(query) ||
            assignee.contains(query);
      }).toList();
    }

    filteredTasks.value = tempTasks;
  }

  Future<bool> createTask({
    required String title,
    required String description,
    required String assignedToId,
    required String scheduledAt,
    required String shift,
  }) async {
    isLoading.value = true;
    try {
      final response = await _managerRepository.createTask({
        "title": title,
        "description": description,
        "assignedToId": assignedToId,
        "scheduledAt": scheduledAt,
        "shift": shift,
      });

      if (response.isSuccess) {
        Get.snackbar("Success", "Task created successfully");
        fetchTasks(); // Refresh list
        return true;
      } else {
        Get.snackbar("Error", response.errorMassage ?? "Failed to create task");
        return false;
      }
    } catch (e) {
      Get.snackbar("Error", "An unexpected error occurred: $e");
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateTask(String id, Map<String, dynamic> body) async {
    isLoading.value = true;
    try {
      final response = await _managerRepository.updateTask(id, body);
      if (response.isSuccess) {
        Get.snackbar("Success", "Task updated successfully");
        fetchTasks();
        return true;
      } else {
        Get.snackbar("Error", response.errorMassage ?? "Failed to update task");
        return false;
      }
    } catch (e) {
      Get.snackbar("Error", "An unexpected error occurred: $e");
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteTask(String id) async {
    isLoading.value = true;
    try {
      final response = await _managerRepository.deleteTask(id);
      if (response.isSuccess) {
        Get.snackbar("Success", "Task deleted successfully");
        fetchTasks();
        Get.back(); // Go back from details screen
      } else {
        Get.snackbar("Error", response.errorMassage ?? "Failed to delete task");
      }
    } catch (e) {
      Get.snackbar("Error", "An unexpected error occurred: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resetTaskStatus(String id) async {
    isLoading.value = true;
    try {
      final response = await _managerRepository.updateTask(id, {"status": "PENDING"});
      if (response.isSuccess) {
        Get.snackbar("Success", "Task status reset to pending");
        fetchTasks();
      } else {
        Get.snackbar("Error", response.errorMassage ?? "Failed to reset status");
      }
    } catch (e) {
      Get.snackbar("Error", "An unexpected error occurred: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
