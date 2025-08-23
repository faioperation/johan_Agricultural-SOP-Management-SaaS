import 'package:farm_check_support/app/urls.dart';
import 'package:farm_check_support/core/services/network/network_client.dart';

class ManagerRepository {
  final NetworkClient _client;

  ManagerRepository(this._client);

  Future<NetworkResponse> getDashboardData() {
    return _client.getRequest(ApiUrls.farmManagerHome);
  }

  Future<NetworkResponse> getAllTasks() {
    return _client.getRequest(ApiUrls.farmManagerAllTasks);
  }

  Future<NetworkResponse> getAllEmployees() {
    return _client.getRequest(ApiUrls.farmManagerEmployees);
  }

  Future<NetworkResponse> getEmployeeDetails(String id) {
    return _client.getRequest(ApiUrls.farmManagerEmployeeDetails(id));
  }

  Future<NetworkResponse> getEmployeeTasks(String id) {
    return _client.getRequest(ApiUrls.farmManagerEmployeeTasks(id));
  }

  Future<NetworkResponse> getProfile() {
    return _client.getRequest(ApiUrls.farmManagerProfile);
  }

  Future<NetworkResponse> getManagerTasks() {
    return _client.getRequest(ApiUrls.farmManagerTasks);
  }

  Future<NetworkResponse> createTask(Map<String, dynamic> body) {
    return _client.postRequest(ApiUrls.farmManagerTasks, body: body);
  }

  Future<NetworkResponse> updateTask(String id, Map<String, dynamic> body) {
    return _client.patchRequest(ApiUrls.farmManagerTaskDetails(id), body: body);
  }

  Future<NetworkResponse> deleteTask(String id) {
    return _client.deleteRequest(ApiUrls.farmManagerTaskDetails(id));
  }

  Future<NetworkResponse> getSopModules() {
    return _client.getRequest(ApiUrls.getManagerSops);
  }

  Future<NetworkResponse> getSopsByModule(String module) {
    return _client.getRequest("${ApiUrls.farmManagerSops}/$module");
  }

  Future<NetworkResponse> getSopDetail(String id) {
    return _client.getRequest(ApiUrls.farmManagerSopDetail(id));
  }




  Future<NetworkResponse> updateProfile(String name, {String? imagePath}) {
    if (imagePath != null) {
      return _client.patchMultipartRequest(
        ApiUrls.updateManagerProfile,
        body: {'name': name},
        files: {'avatar': imagePath},
      );
    }
    return _client.patchRequest(ApiUrls.updateManagerProfile, body: {'name': name});
  }

  Future<NetworkResponse> changePassword(String currentPassword, String newPassword) {
    return _client.postRequest(ApiUrls.changeManagerPassword, body: {
      'currentPassword': currentPassword,
      'newPassword': newPassword,
    });
  }
}
