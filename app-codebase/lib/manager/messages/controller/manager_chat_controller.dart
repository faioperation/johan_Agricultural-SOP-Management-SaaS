import 'dart:async';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:farm_check_support/core/services/network/network_client.dart';
import 'package:farm_check_support/core/services/socket_service.dart';
import 'package:farm_check_support/manager/messages/model/manager_chat_model.dart';
import 'package:farm_check_support/manager/repo/manager_chat_repository.dart';
import 'package:farm_check_support/app/token_service.dart';
import 'package:get/get.dart';

class ManagerChatController extends GetxController {
  final ManagerChatRepository _repository;
  final SocketService _socketService;
  Timer? _refreshTimer;

  ManagerChatController(this._repository, this._socketService);

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
      print('Error fetching contacts: $e');
    }
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
      print('❌ Silent refresh error: $e');
    }
  }

  // ================= FETCH CONVERSATIONS =================

  Future<void> fetchConversations() async {
    if (conversations.isEmpty) isLoadingConversations.value = true;
    try {
      final response = await _repository.getConversations();
      if (response.isSuccess && response.responseData != null) {
        final convResponse =
        ConversationResponse.fromJson(response.responseData);
        conversations.value = convResponse.data ?? [];
        if (!isSearching.value) {
          filteredConversations.value = conversations;
        }
      }
    } catch (e) {
      print('Error fetching conversations: $e');
    } finally {
      isLoadingConversations.value = false;
    }
  }

  // ================= FETCH CHAT HISTORY =================

  Future<void> fetchChatHistory(String userId) async {
    final bool isSameUser = currentChatUserId.value == userId;
    currentChatUserId.value = userId;
    
    if (!isSameUser) {
      chatMessages.clear();
      isLoadingHistory.value = true;
    }

    _startRefreshTimer(userId);
    
    print('🔄 Manager Fetching history and joining rooms for partner: $userId');
    _socketService.emit('join', userId);
    _socketService.emit('join', {'room': userId});
    if (TokenService.userId != null) {
      _socketService.emit('join', TokenService.userId);
      _socketService.emit('join', {'room': TokenService.userId});
    }

    try {
      final response = await _repository.getChatHistory(userId);
      if (response.isSuccess && response.responseData != null) {
        final historyResponse =
        ChatHistoryResponse.fromJson(response.responseData);
        final historyMessages = historyResponse.data ?? [];

        for (var msg in historyMessages) {
          _addOrUpdateMessage(msg);
        }
      }
    } catch (e) {
      print('❌ Error fetching manager chat history: $e');
    } finally {
      isLoadingHistory.value = false;
    }
  }

  // ================= SEND MESSAGE =================

  Future<void> sendMessage(String receiverId, String content,
      {String? imagePath}) async {
    if (content.trim().isEmpty && imagePath == null) return;

    final myId = TokenService.userId ?? "";

    // 🚀 Optimistic message
    final tempId = DateTime.now().millisecondsSinceEpoch.toString();
    final tempMessage = ChatMessageModel(
      id: tempId,
      content: content,
      imageUrl: imagePath,
      senderId: myId,
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

      if (!response.isSuccess) {
        chatMessages.removeWhere((m) => m.id == tempId);
        Get.snackbar(
            "Error", response.errorMassage ?? "Failed to send message");
      }
    } catch (e) {
      chatMessages.removeWhere((m) => m.id == tempId);
      print('Error sending message: $e');
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
        final belongsToThisChat = effectiveSenderId == partnerId || (newMessage.senderId == myId && partnerId.isNotEmpty); 

        if (belongsToThisChat) {
          _addOrUpdateMessage(newMessage);
        } else {
          _updateLastMessage(newMessage);
        }
      } catch (e) {
        print('❌ Error processing message package in Manager: $e');
      }
    });
  }

  void _addOrUpdateMessage(ChatMessageModel newMessage) {
    // 1. Check by ID (Official Server ID)
    int existingIndex = chatMessages.indexWhere((m) => m.id == newMessage.id);
    
    // 2. Fallback: Check for similar optimistic message (Same content, same sender, within 10s)
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
      // Update existing (e.g., swap temp ID with real ID)
      chatMessages[existingIndex] = newMessage;
      print('♻️ Updated/Merged message in Manager UI');
    } else {
      // Add new
      chatMessages.add(newMessage);
      chatMessages.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      print('✅ Added new message to Manager UI');
    }
    chatMessages.refresh();
    _updateLastMessage(newMessage);
  }

  @override
  void onClose() {
    _refreshTimer?.cancel();
    _socketService.disconnect();
    super.onClose();
  }

  // ================= UPDATE CONVERSATION LIST =================

  void _updateLastMessage(ChatMessageModel message) {
    final myId = TokenService.userId ?? "";

    final targetUserId =
    message.senderId == myId ? currentChatUserId.value : message.senderId;

    final index =
    conversations.indexWhere((c) => c.userId == targetUserId);

    if (index != -1) {
      final old = conversations[index];

      conversations[index] = ConversationModel(
        userId: old.userId,
        name: old.name,
        jobTitle: old.jobTitle,
        role: old.role, // ✅ Preserve role
        lastMessage: message.content,
        lastMessageAt: message.createdAt,
        unreadCount:
        message.senderId == myId ? old.unreadCount : old.unreadCount + 1,
      );
    } else {
      fetchConversations();
    }
  }
}
