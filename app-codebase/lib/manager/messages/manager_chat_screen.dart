import 'dart:io';

import 'package:farm_check_support/manager/messages/controller/manager_chat_controller.dart';
import 'package:farm_check_support/manager/messages/model/manager_chat_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:farm_check_support/app/urls.dart';
import 'package:intl/intl.dart';

class ManagerChatScreen extends StatefulWidget {
  final String userId;
  final String userName;
  final String jobTitle;

  const ManagerChatScreen({
    super.key,
    required this.userId,
    required this.userName,
    required this.jobTitle,
  });

  @override
  State<ManagerChatScreen> createState() => _ManagerChatScreenState();
}

class _ManagerChatScreenState extends State<ManagerChatScreen> {
  final ManagerChatController _chatController = Get.find<ManagerChatController>();
  final TextEditingController _controller = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _chatController.fetchChatHistory(widget.userId);
    });
  }

  /// ================= PICK IMAGE =================
  Future<void> _pickImage() async {
    final XFile? img = await _picker.pickImage(source: ImageSource.gallery);

    if (img != null) {
      setState(() {
        _selectedImage = File(img.path);
      });
      // For now, API doesn't support image message in this flow, but setting up for future
    }
  }

  /// ================= SEND =================
  void _send() {
    final text = _controller.text.trim();
    if (text.isNotEmpty || _selectedImage != null) {
      _chatController.sendMessage(
        widget.userId, 
        text, 
        imagePath: _selectedImage?.path,
      );
      _controller.clear();
      setState(() => _selectedImage = null);
    }
  }

  /// ================= IMAGE VIEWER =================
  void _openImagePreview(String imagePath, {bool isNetwork = true}) {
    showDialog(
      context: context,
      barrierColor: Colors.black,
      builder: (_) => Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Center(
              child: InteractiveViewer(
                child: isNetwork 
                  ? Image.network(imagePath) 
                  : Image.file(File(imagePath))
              )
            ),
            Positioned(
              top: 40,
              right: 20,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.black54,
                  child: Icon(Icons.close, color: Colors.white, size: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final w = mq.size.width;
    final h = mq.size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),

      /// ================= APP BAR =================
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        titleSpacing: 0,
        leadingWidth: w * 0.12,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: w * 0.045,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: w * 0.05,
              backgroundColor: const Color(0xFFE8F0FF),
              child: Text(
                widget.userName.isNotEmpty ? widget.userName[0].toUpperCase() : "?",
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
              ),
            ),
            SizedBox(width: w * 0.025),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.userName,
                  style: TextStyle(
                    fontSize: w * 0.038,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Row(
                  children: [
                    Icon(Icons.circle, size: w * 0.018, color: Colors.green),
                    SizedBox(width: w * 0.01),
                    Text(
                      widget.jobTitle,
                      style: TextStyle(
                        fontSize: w * 0.028,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),

      /// ================= BODY =================
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (_chatController.isLoadingHistory.value) {
                return const Center(child: CircularProgressIndicator());
              }

              // Reverse the list for the UI so newest is at the bottom (index 0 for reverse: true)
              final messages = _chatController.chatMessages.reversed.toList();

              return ListView.builder(
                padding: EdgeInsets.fromLTRB(
                  w * 0.04,
                  h * 0.02,
                  w * 0.04,
                  h * 0.01,
                ),
                reverse: true, 
                itemCount: messages.length + 1,
                itemBuilder: (context, index) {
                   if (index == messages.length) {
                     return Center(
                       child: Container(
                         margin: EdgeInsets.symmetric(vertical: h * 0.02),
                         padding: EdgeInsets.symmetric(
                           horizontal: w * 0.03,
                           vertical: h * 0.006,
                         ),
                         decoration: BoxDecoration(
                           color: const Color(0xFFF1F3F5),
                           borderRadius: BorderRadius.circular(20),
                         ),
                         child: Text('Today', style: TextStyle(fontSize: w * 0.028)),
                       ),
                     );
                   }
                   final message = messages[index];
                   return _bubble(message, w);
                },
              );
            }),
          ),

          /// ================= IMAGE PREVIEW =================
          if (_selectedImage != null)
            Container(
              padding: EdgeInsets.all(w * 0.03),
              color: Colors.white,
              child: Stack(
                alignment: Alignment.topLeft, // 🔥 left side
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: h * 0.10,
                        maxWidth: w * 0.50,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(_selectedImage!, fit: BoxFit.cover),
                      ),
                    ),
                  ),

                  /// CLOSE BUTTON
                  Positioned(
                    top: 6,
                    left: 6, // 🔥 left side close icon
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedImage = null),
                      child: const CircleAvatar(
                        radius: 14,
                        backgroundColor: Colors.black54,
                        child: Icon(Icons.close, color: Colors.white, size: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),

          /// ================= INPUT =================
          Container(
            padding: EdgeInsets.fromLTRB(
              w * 0.03,
              h * 0.01,
              w * 0.03,
              h * 0.015,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.black12)),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.image,
                    size: w * 0.06,
                    color: Colors.black54,
                  ),
                  onPressed: _pickImage,
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: w * 0.035),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F3F5),
                      borderRadius: BorderRadius.circular(w * 0.08),
                    ),
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: 'Write a message...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: w * 0.02),
                GestureDetector(
                  onTap: _send,
                  child: CircleAvatar(
                    radius: w * 0.055,
                    backgroundColor: const Color(0xFFFFA726),
                    child: Icon(
                      Icons.send,
                      size: w * 0.05,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _bubble(ChatMessageModel m, double w) {
    return Padding(
      padding: EdgeInsets.only(bottom: w * 0.03),
      child: Column(
        crossAxisAlignment: m.isMine
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
            Container(
              constraints: BoxConstraints(maxWidth: w * 0.75),
              padding: EdgeInsets.all(w * 0.035),
              decoration: BoxDecoration(
                color: m.isMine ? const Color(0xFFFFA726) : Colors.white,
                borderRadius: BorderRadius.circular(w * 0.04),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (m.imageUrl != null) ...[
                    GestureDetector(
                      onTap: () {
                        final fullUrl = m.imageUrl!.startsWith('/') 
                          ? "${ApiUrls.serverUrl}${m.imageUrl}" 
                          : m.imageUrl!;
                        _openImagePreview(fullUrl, isNetwork: !m.imageUrl!.startsWith('/Users/'));
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(w * 0.02),
                        child: m.imageUrl!.startsWith('/Users/') || m.imageUrl!.startsWith('/data/')
                          ? Image.file(File(m.imageUrl!), fit: BoxFit.cover)
                          : Image.network(
                              m.imageUrl!.startsWith('/') 
                                ? "${ApiUrls.serverUrl}${m.imageUrl}" 
                                : m.imageUrl!,
                              fit: BoxFit.cover,
                            ),
                      ),
                    ),
                    if (m.content.isNotEmpty) SizedBox(height: w * 0.02),
                  ],
                  if (m.content.isNotEmpty)
                    Text(m.content, style: TextStyle(fontSize: w * 0.034)),
                ],
              ),
            ),
          SizedBox(height: w * 0.01),
          Text(
            _chatController.formatChatTime(m.createdAt),
            style: TextStyle(fontSize: w * 0.028, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}

