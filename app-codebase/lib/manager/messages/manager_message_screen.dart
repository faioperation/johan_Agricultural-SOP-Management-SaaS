import 'package:farm_check_support/manager/messages/controller/manager_chat_controller.dart';
import 'package:farm_check_support/manager/messages/manager_chat_screen.dart';
import 'package:farm_check_support/manager/messages/model/manager_chat_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ManagerMessagesScreen extends StatelessWidget {
  const ManagerMessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final w = mq.size.width;
    final h = mq.size.height;

    final controller = Get.find<ManagerChatController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),

      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Messages',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: w * 0.045,
          ),
        ),
      ),

      body: Column(
        children: [
          /// 🔍 SEARCH (Always Visible)
          Padding(
            padding: EdgeInsets.fromLTRB(w * 0.04, w * 0.04, w * 0.04, 0),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: w * 0.035),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F3F5),
                borderRadius: BorderRadius.circular(w * 0.03),
              ),
              child: TextField(
                onChanged: (value) => controller.searchContacts(value),
                decoration: InputDecoration(
                  hintText: 'Search...',
                  hintStyle: TextStyle(fontSize: w * 0.035),
                  border: InputBorder.none,
                  icon: Icon(Icons.search, size: w * 0.05),
                ),
              ),
            ),
          ),

          Expanded(
            child: Obx(() {
              if (controller.isLoadingConversations.value) {
                return const Center(child: CircularProgressIndicator());
              }

              final list = controller.filteredConversations;

              if (list.isEmpty && !controller.isSearching.value) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.chat_bubble_outline,
                          size: w * 0.15, color: Colors.grey),
                      SizedBox(height: h * 0.02),
                      const Text("No conversations found",
                          style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () => controller.fetchConversations(),
                child: ListView.builder(
                  padding: EdgeInsets.all(w * 0.04),
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final conv = list[index];
                    return _messageCard(
                      context,
                      w: w,
                      conv: conv,
                      controller: controller,
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  /// ================= MESSAGE CARD (RESPONSIVE) =================
  Widget _messageCard(
      BuildContext context, {
        required double w,
        required ConversationModel conv,
        required ManagerChatController controller,
      }) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(
            builder: (_) => ManagerChatScreen(
              userId: conv.userId,
              userName: conv.name,
              jobTitle: conv.role ?? conv.jobTitle ?? "Employee",
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: w * 0.035),
        padding: EdgeInsets.all(w * 0.04),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(w * 0.04),
          border: Border(
            left: BorderSide(
              color: conv.unreadCount > 0 ? const Color(0xFFFFA726) : Colors.transparent,
              width: w * 0.015,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: w * 0.05,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// AVATAR
            Container(
              width: w * 0.11,
              height: w * 0.11,
              decoration: BoxDecoration(
                color: const Color(0xFFE8F0FF),
                borderRadius: BorderRadius.circular(w * 0.03),
              ),
              child: Icon(Icons.chat_bubble_outline,
                  color: Colors.blue, size: w * 0.06),
            ),

            SizedBox(width: w * 0.03),

            /// CONTENT
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// NAME + TIME
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        conv.name,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: w * 0.035,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            controller.formatChatTime(conv.lastMessageAt),
                            style: TextStyle(
                              fontSize: w * 0.028,
                              color: Colors.black54,
                            ),
                          ),
                          if (conv.unreadCount > 0) ...[
                            SizedBox(width: w * 0.015),
                            Icon(Icons.circle,
                                size: w * 0.02, color: Colors.green),
                          ],
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: w * 0.01),

                  Text(
                    conv.lastMessage ?? "Start a conversation",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: w * 0.032,
                      color: Colors.black87,
                    ),
                  ),

                  SizedBox(height: w * 0.012),

                  /// ROLE BADGE
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: w * 0.03,
                      vertical: w * 0.01,
                    ),
                    decoration: BoxDecoration(
                      color: (conv.role == "FARM_ADMIN" || conv.jobTitle == 'Farm Admin')
                          ? const Color(0xFFFFEFEA)
                          : const Color(0xFFEFF4FF),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      conv.role ?? conv.jobTitle ?? "Employee",
                      style: TextStyle(
                        fontSize: w * 0.028,
                        color:
                        (conv.role == "FARM_ADMIN" || conv.jobTitle == 'Farm Admin') ? Colors.orange : Colors.blue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
