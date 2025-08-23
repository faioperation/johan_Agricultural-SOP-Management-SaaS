import 'package:farm_check_support/app/urls.dart';
import 'package:farm_check_support/core/services/network/network_client.dart';

class ManagerChatRepository {
  final NetworkClient _client;

  ManagerChatRepository(this._client);

  Future<NetworkResponse> getConversations() {
    return _client.getRequest(ApiUrls.managerConversations);
  }

  Future<NetworkResponse> getChatHistory(String userId) {
    return _client.getRequest(ApiUrls.managerChatHistory(userId));
  }

  Future<NetworkResponse> getContacts() {
    return _client.getRequest(ApiUrls.managerContacts);
  }

  Future<NetworkResponse> sendMessage({required String receiverId, required String content, String? imagePath}) {
    if (imagePath != null) {
      return _client.postMultipartRequest(
        ApiUrls.managerSendMessage,
        body: {
          'receiverId': receiverId,
          'content': content,
        },
        files: {'image': imagePath},
      );
    }
    return _client.postRequest(
      ApiUrls.managerSendMessage,
      body: {
        'receiverId': receiverId,
        'content': content,
      },
    );
  }
}
