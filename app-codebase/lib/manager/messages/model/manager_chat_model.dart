import 'package:farm_check_support/app/token_service.dart';

class ConversationModel {
  final String userId;
  final String name;
  final String? jobTitle;
  final String? role;   // ✅ Added role
  final String? lastMessage;
  final String? lastMessageAt;
  final int unreadCount;

  ConversationModel({
    required this.userId,
    required this.name,
    this.jobTitle,
    this.role,
    this.lastMessage,
    this.lastMessageAt,
    this.unreadCount = 0,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    final String myId = TokenService.userId ?? "";
    String partnerId = "";

    // 1. If we have a specific userId or id field, use it
    if (json['userId'] != null && json['userId'].toString().isNotEmpty) {
      partnerId = json['userId'].toString();
    } else if (json['id'] != null && json['id'].toString().isNotEmpty) {
      partnerId = json['id'].toString();
    }
    // 2. Otherwise, deduce from sender/receiver IDs
    else {
      final String sId = json['senderId']?.toString() ?? "";
      final String rId = json['receiverId']?.toString() ?? "";

      if (sId.isNotEmpty && sId != myId) {
        partnerId = sId;
      } else if (rId.isNotEmpty && rId != myId) {
        partnerId = rId;
      } else {
        // Fallback for contacts list or edge cases
        partnerId = (json['partnerId'] ??
                json['employeeId'] ??
                json['participantId'] ??
                "")
            .toString();
      }
    }

    return ConversationModel(
      userId: partnerId,
      name: json['name'] ?? "",
      jobTitle: json['jobTitle'],
      role: json['role']?.toString(), // Ensure it's a string
      lastMessage: json['lastMessage'],
      lastMessageAt: json['lastMessageAt'],
      unreadCount: json['unreadCount'] ?? 0,
    );
  }
}

class ConversationResponse {
  final bool success;
  final List<ConversationModel>? data;

  ConversationResponse({required this.success, this.data});

  factory ConversationResponse.fromJson(Map<String, dynamic> json) {
    return ConversationResponse(
      success: json['success'],
      data: json['data'] != null
          ? (json['data'] as List).map((i) => ConversationModel.fromJson(i)).toList()
          : null,
    );
  }
}

class ChatMessageModel {
  final String id;
  final String content;
  final String? imageUrl;
  final String senderId;
  final bool isMine;
  final String createdAt;

  ChatMessageModel({
    required this.id,
    required this.content,
    this.imageUrl,
    required this.senderId,
    required this.isMine,
    required this.createdAt,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    // Handle both direct object and wrapped data object
    final Map<String, dynamic> data = json['data'] is Map ? json['data'] : json;
    
    // Resilient senderId extraction
    String extractedSenderId = "";
    if (data['senderId'] != null) {
      extractedSenderId = data['senderId'].toString();
    } else if (data['from'] != null) {
      extractedSenderId = data['from'].toString();
    } else if (data['sender'] != null) {
      if (data['sender'] is Map) {
        extractedSenderId = (data['sender']['_id'] ?? data['sender']['id'] ?? "").toString();
      } else {
        extractedSenderId = data['sender'].toString();
      }
    } else if (data['user'] != null && data['user'] is Map) {
      extractedSenderId = (data['user']['_id'] ?? data['user']['id'] ?? "").toString();
    }

    // Reliable isMine logic
    final myUserId = TokenService.userId?.toString() ?? "";
    bool calculatedIsMine = (extractedSenderId == myUserId && myUserId.isNotEmpty) || 
                           extractedSenderId == "me" ||
                           data['isMine'] == true || 
                           data['isMine'] == 1 || 
                           data['isMine'] == "true";

    return ChatMessageModel(
      id: (data['id'] ?? data['_id'] ?? data['messageId'] ?? DateTime.now().millisecondsSinceEpoch.toString()).toString(),
      content: data['content'] ?? data['message'] ?? data['text'] ?? "",
      imageUrl: data['imageUrl'] ?? data['image'],
      senderId: extractedSenderId,
      isMine: calculatedIsMine,
      createdAt: data['createdAt'] ?? data['timestamp'] ?? data['date'] ?? DateTime.now().toIso8601String(),
    );
  }
}

class ChatHistoryResponse {
  final bool success;
  final List<ChatMessageModel>? data;

  ChatHistoryResponse({required this.success, this.data});

  factory ChatHistoryResponse.fromJson(Map<String, dynamic> json) {
    return ChatHistoryResponse(
      success: json['success'],
      data: json['data'] != null
          ? (json['data'] as List).map((i) => ChatMessageModel.fromJson(i)).toList()
          : null,
    );
  }
}
