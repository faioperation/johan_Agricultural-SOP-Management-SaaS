import 'package:farm_check_support/app/token_service.dart';
import 'package:farm_check_support/manager/model/employee_model.dart';
import 'package:farm_check_support/manager/repo/manager_repository.dart';
import 'package:get/get.dart';

class EmployeeController extends GetxController {
  final ManagerRepository _managerRepository;

  EmployeeController(this._managerRepository);

  final RxBool isLoading = false.obs;
  final RxList<Employee> allEmployees = <Employee>[].obs;
  final RxList<Employee> filteredEmployees = <Employee>[].obs;
  final RxInt selectedFilter = 0.obs; // 0: All, 1: Active, 2: Inactive

  @override
  void onInit() {
    super.onInit();
    if (TokenService.isManager) {
      fetchEmployees();
    }
  }

  Future<void> fetchEmployees() async {
    isLoading.value = true;
    try {
      final response = await _managerRepository.getAllEmployees();
      if (response.isSuccess) {
        final model = EmployeeListResponse.fromJson(response.responseData);
        allEmployees.value = model.data ?? [];
        applyFilter();
      } else {
        Get.snackbar("Error", response.errorMassage ?? "Failed to load employees");
      }
    } catch (e) {
      Get.snackbar("Error", "An unexpected error occurred: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void setFilter(int index) {
    selectedFilter.value = index;
    applyFilter();
  }

  void applyFilter() {
    if (selectedFilter.value == 0) {
      filteredEmployees.value = allEmployees;
    } else if (selectedFilter.value == 1) {
      filteredEmployees.value = allEmployees.where((e) => e.status?.toUpperCase() == 'ACTIVE').toList();
    } else {
      filteredEmployees.value = allEmployees.where((e) => e.status?.toUpperCase() == 'INACTIVE').toList();
    }
  }

  void searchTeam(String query) {
    if (query.isEmpty) {
      applyFilter();
    } else {
      filteredEmployees.value = allEmployees.where((e) =>
          (e.name?.toLowerCase().contains(query.toLowerCase()) ?? false) ||
          (e.email?.toLowerCase().contains(query.toLowerCase()) ?? false)
      ).toList();
    }
  }
}

class EmployeeDetailsController extends GetxController {
  final ManagerRepository _managerRepository;

  EmployeeDetailsController(this._managerRepository);

  final RxBool isLoading = false.obs;
  final Rx<Employee?> employee = Rx<Employee?>(null);
  final RxList<EmployeeTask> currentTasks = <EmployeeTask>[].obs;
  final RxList<EmployeeTask> completedTasks = <EmployeeTask>[].obs;
  final RxInt selectedTab = 0.obs;

  Future<void> fetchEmployeeTasks(String id) async {
    isLoading.value = true;
    try {
      final detailsResponse = await _managerRepository.getEmployeeDetails(id);
      if (detailsResponse.isSuccess) {
        employee.value = Employee.fromJson(detailsResponse.responseData['data']);
      }

      final response = await _managerRepository.getEmployeeTasks(id);
      if (response.isSuccess) {
        final model = EmployeeTasksResponse.fromJson(response.responseData);
        final allTasks = model.data ?? [];
        currentTasks.value = allTasks.where((t) => (t.status?.toUpperCase() ?? '') != 'COMPLETED').toList();
        completedTasks.value = allTasks.where((t) => (t.status?.toUpperCase() ?? '') == 'COMPLETED').toList();
      } else {
        Get.snackbar("Error", response.errorMassage ?? "Failed to load employee tasks");
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
}
