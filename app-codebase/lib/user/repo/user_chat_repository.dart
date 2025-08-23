import 'package:farm_check_support/app/urls.dart';
import 'package:farm_check_support/core/services/network/network_client.dart';

class UserChatRepository {
  final NetworkClient _client;

  UserChatRepository(this._client);

  Future<NetworkResponse> getConversations() {
    return _client.getRequest(ApiUrls.employeeConversations);
  }

  Future<NetworkResponse> getChatHistory(String userId) {
    return _client.getRequest(ApiUrls.employeeChatHistory(userId));
  }

  Future<NetworkResponse> getContacts() {
    return _client.getRequest(ApiUrls.employeeContacts);
  }

  Future<NetworkResponse> sendMessage({required String receiverId, required String content, String? imagePath}) {
    if (imagePath != null) {
      return _client.postMultipartRequest(
        ApiUrls.employeeSendMessage,
        body: {
          'receiverId': receiverId,
          'content': content,
        },
        files: {'image': imagePath},
      );
    }
    return _client.postRequest(
      ApiUrls.employeeSendMessage,
      body: {
        'receiverId': receiverId,
        'content': content,
      },
    );
  }
}
