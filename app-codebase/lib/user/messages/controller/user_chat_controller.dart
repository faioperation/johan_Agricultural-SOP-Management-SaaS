import 'dart:async';
import 'package:intl/intl.dart';
import 'package:farm_check_support/app/token_service.dart';
import 'package:image_picker/image_picker.dart';

import 'package:farm_check_support/core/services/socket_service.dart';
import 'package:farm_check_support/manager/messages/model/manager_chat_model.dart';
import 'package:farm_check_support/user/repo/user_chat_repository.dart';
import 'package:get/get.dart';

class UserChatController extends GetxController {
  final UserChatRepository _repository;
  final SocketService _socketService;
  Timer? _refreshTimer;

  UserChatController(this._repository, this._socketService);

  final RxBool isLoadingConversations = false.obs;
  final RxList<ConversationModel> conversations = <ConversationModel>[].obs;
  final RxList<ConversationModel> filteredConversations = <ConversationModel>[].obs;
  final List<ConversationModel> allContacts = []; // Cache for contacts
  final RxBool isSearching = false.obs;

  final RxBool isLoadingHistory = false.obs;
  final RxList<ChatMessageModel> chatMessages = <ChatMessageModel>[].obs;

  final RxString currentChatUserId = "".obs;

  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    fetchConversations();
    fetchContacts(); // ✅ Load contacts for search
    _socketService.connect();
    _setupMessageStreamListener();
  }

  // ================= UTILS =================

  String formatChatTime(String? timestamp) {
    if (timestamp == null || timestamp.isEmpty) return "";
    try {
      final dt = DateTime.parse(timestamp).toLocal();
      return DateFormat('h:mma').format(dt).toLowerCase(); // "10:30am"
    } catch (e) {
      return "";
    }
  }

  void searchContacts(String query) {
    if (query.trim().isEmpty) {
      isSearching.value = false;
      filteredConversations.value = conversations;
      return;
    }

    isSearching.value = true;
    final lowercaseQuery = query.toLowerCase();
    
    // Search in existing conversations AND cached contacts
    final results = <ConversationModel>[];
    final seenIds = <String>{};

    for (var c in conversations) {
      if (c.name.toLowerCase().contains(lowercaseQuery)) {
        results.add(c);
        seenIds.add(c.userId);
      }
    }

    for (var c in allContacts) {
      if (!seenIds.contains(c.userId) && c.name.toLowerCase().contains(lowercaseQuery)) {
        results.add(c);
        seenIds.add(c.userId);
      }
    }

    filteredConversations.value = results;
  }

  Future<void> fetchContacts() async {
    try {
      final response = await _repository.getContacts();
      if (response.isSuccess && response.responseData != null) {
        final convResponse = ConversationResponse.fromJson(response.responseData);
        allContacts.clear();
        allContacts.addAll(convResponse.data ?? []);
      }
    } catch (e) {
      print('Error fetching user contacts: $e');
    }
  }

  void _setupMessageStreamListener() {
    _socketService.messageStream.listen((package) {
      if (package == null) return;

      final data = package.data;
      final eventName = package.event;

      try {
        final newMessage = ChatMessageModel.fromJson(data);
        final partnerId = currentChatUserId.value;
        final myId = TokenService.userId ?? "";

        final effectiveSenderId = newMessage.senderId.isEmpty ? eventName : newMessage.senderId;
        final belongsToThisChat = effectiveSenderId == partnerId || newMessage.senderId == myId || newMessage.senderId == "me";

        if (belongsToThisChat) {
          _addOrUpdateMessage(newMessage);
        } else {
          _updateLastMessage(newMessage);
        }
      } catch (e) {
        print('❌ Error processing message package in User: $e');
      }
    });
  }

  void _addOrUpdateMessage(ChatMessageModel newMessage) {
    int existingIndex = chatMessages.indexWhere((m) => m.id == newMessage.id);
    
    if (existingIndex == -1 && newMessage.isMine) {
      existingIndex = chatMessages.indexWhere((m) {
        if (!m.isMine || m.content != newMessage.content) return false;
        try {
          final t1 = DateTime.parse(m.createdAt);
          final t2 = DateTime.parse(newMessage.createdAt);
          return t1.difference(t2).inSeconds.abs() < 10;
        } catch (_) {
          return false;
        }
      });
    }

    if (existingIndex != -1) {
      chatMessages[existingIndex] = newMessage;
      print('♻️ Updated/Merged message in User UI');
    } else {
      chatMessages.add(newMessage);
      chatMessages.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    }
  }

  @override
  void onClose() {
    _refreshTimer?.cancel();
    _socketService.disconnect();
    super.onClose();
  }

  // ================= REFRESH TIMER =================

  void _startRefreshTimer(String userId) {
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(const Duration(seconds: 5), (timer) { // ✅ Reduced to 5s
      if (currentChatUserId.value == userId) {
        _refreshHistorySilence(userId);
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> _refreshHistorySilence(String userId) async {
    try {
      final response = await _repository.getChatHistory(userId);
      if (response.isSuccess && response.responseData != null) {
        final historyResponse = ChatHistoryResponse.fromJson(response.responseData);
        final historyMessages = historyResponse.data ?? [];

        for (var msg in historyMessages) {
          _addOrUpdateMessage(msg);
        }
      }
    } catch (e) {
      print('❌ User silent refresh error: $e');
    }
  }

  Future<void> fetchConversations() async {
    if (conversations.isEmpty) isLoadingConversations.value = true;
    try {
      final response = await _repository.getConversations();
      if (response.isSuccess && response.responseData != null) {
        final convResponse = ConversationResponse.fromJson(response.responseData);
        conversations.value = convResponse.data ?? [];
        if (!isSearching.value) {
          filteredConversations.value = conversations;
        }
      }
    } catch (e) {
      print('Error fetching user conversations: $e');
    } finally {
      isLoadingConversations.value = false;
    }
  }

  Future<void> fetchChatHistory(String userId) async {
    final bool isSameUser = currentChatUserId.value == userId;
    currentChatUserId.value = userId;
    
    if (!isSameUser) {
      chatMessages.clear();
      isLoadingHistory.value = true;
    }
    
    _startRefreshTimer(userId);

    _socketService.emit('join', userId);
    if (TokenService.userId != null) {
      _socketService.emit('join', TokenService.userId);
    }

    try {
      final response = await _repository.getChatHistory(userId);
      if (response.isSuccess && response.responseData != null) {
        final historyResponse = ChatHistoryResponse.fromJson(response.responseData);
        final historyMessages = historyResponse.data ?? [];

        for (var msg in historyMessages) {
          _addOrUpdateMessage(msg);
        }
      }
    } catch (e) {
      print('Error fetching user chat history: $e');
    } finally {
      isLoadingHistory.value = false;
    }
  }

  Future<void> pickAndSendImage(String receiverId) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
    if (image != null) {
      await sendMessage(receiverId, "", imagePath: image.path);
    }
  }

  Future<void> sendMessage(String receiverId, String content, {String? imagePath}) async {
    if (content.trim().isEmpty && imagePath == null) return;

    // 🚀 Optimistic Update
    final tempId = DateTime.now().millisecondsSinceEpoch.toString();
    final tempMessage = ChatMessageModel(
      id: tempId,
      content: content,
      imageUrl: imagePath,
      senderId: "me",
      isMine: true,
      createdAt: DateTime.now().toIso8601String(),
    );
    
    chatMessages.add(tempMessage);

    try {
      final response = await _repository.sendMessage(
        receiverId: receiverId, 
        content: content,
        imagePath: imagePath,
      );
      if (response.isSuccess) {
        // Handled by socket
      } else {
        chatMessages.removeWhere((m) => m.id == tempId);
        Get.snackbar("Error", response.errorMassage ?? "Failed to send message");
      }
    } catch (e) {
      chatMessages.removeWhere((m) => m.id == tempId);
      print('Error sending user message: $e');
    }
  }


  void _updateLastMessage(ChatMessageModel message) {
    final myId = TokenService.userId ?? "";
    final targetUserId = message.senderId == myId || message.senderId == "me" ? currentChatUserId.value : message.senderId;

    if (targetUserId.isEmpty) return;

    final index = conversations.indexWhere((c) => c.userId == targetUserId);
    if (index != -1) {
      final old = conversations[index];
      conversations[index] = ConversationModel(
        userId: old.userId,
        name: old.name,
        jobTitle: old.jobTitle,
        role: old.role, // ✅ Preserve role
        lastMessage: message.content,
        lastMessageAt: message.createdAt,
        unreadCount: (message.senderId == myId || message.senderId == "me") ? old.unreadCount : old.unreadCount + 1,
      );
    } else {
      fetchConversations();
    }
  }
}
