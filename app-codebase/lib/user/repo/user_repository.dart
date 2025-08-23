import 'package:farm_check_support/app/urls.dart';
import 'package:farm_check_support/core/services/network/network_client.dart';

class UserRepository {
  final NetworkClient _client;

  UserRepository(this._client);

  Future<NetworkResponse> getEmployeeHomeData() {
    return _client.getRequest(ApiUrls.employeeHome);
  }

  Future<NetworkResponse> getProfile() {
    return _client.getRequest(ApiUrls.employeeProfile);
  }

  Future<NetworkResponse> getEmployeeTasks() {
    return _client.getRequest(ApiUrls.employeeAllTasks);
  }

  Future<NetworkResponse> updateProfile(String name, {String? imagePath}) {
    if (imagePath != null) {
      return _client.patchMultipartRequest(
        ApiUrls.updateProfile,
        body: {'name': name},
        files: {'avatar': imagePath},
      );
    }
    return _client.patchRequest(ApiUrls.updateProfile, body: {'name': name});
  }

  Future<NetworkResponse> changePassword(String oldPassword, String newPassword) {
    return _client.patchRequest(ApiUrls.changePassword, body: {
      'oldPassword': oldPassword,
      'newPassword': newPassword,
    });
  }

  Future<NetworkResponse> completeTask(String id, String? note) {
    return _client.patchRequest(ApiUrls.employeeTaskComplete(id), body: {
      if (note != null && note.isNotEmpty) 'note': note,
    });
  }
}
