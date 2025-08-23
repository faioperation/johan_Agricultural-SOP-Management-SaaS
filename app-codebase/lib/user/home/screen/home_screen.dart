import 'package:farm_check_support/user/home/controller/user_home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserHomeScreen extends GetView<UserHomeController> {
  final VoidCallback onViewAllTasks;
  final VoidCallback onViewSop;
  final VoidCallback onViewMessage;

  const UserHomeScreen({
    super.key,
    required this.onViewAllTasks,
    required this.onViewSop,
    required this.onViewMessage,
  });

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final w = mq.size.width;
    final h = mq.size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: RefreshIndicator(
        onRefresh: () => controller.fetchHomeData(),
        child: Column(
          children: [
            /// ================= HEADER =================
            Obx(() {
              final employee = controller.homeData.value?.employee;
              return Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(
                  w * 0.04,
                  mq.padding.top + h * 0.01,
                  w * 0.04,
                  h * 0.015,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF6A62D),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(w * 0.06),
                    bottomRight: Radius.circular(w * 0.06),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: CircleAvatar(
                        radius: w * 0.055,
                        backgroundColor: Colors.white,
                        backgroundImage: NetworkImage(
                          employee?.avatarUrl ?? 'https://cdn-icons-png.flaticon.com/512/3135/3135715.png'
                        ),
                        onBackgroundImageError: (_, __) {},
                      ),
                    ),
                    SizedBox(width: w * 0.03),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getGreeting(),
                          style: TextStyle(
                            fontSize: w * 0.032,
                            color: Colors.black54,
                          ),
                        ),
                        SizedBox(height: h * 0.004),
                        Text(
                          employee?.name ?? '...',
                          style: TextStyle(
                            fontSize: w * 0.05,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: h * 0.002),
                        Text(
                          employee?.jobTitle ?? 'Employee Portal',
                          style: TextStyle(
                            fontSize: w * 0.032,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),

            /// ================= BODY =================
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value && controller.homeData.value == null) {
                  return const Center(child: CircularProgressIndicator());
                }

                final stats = controller.homeData.value?.stats;
                final recentActivity = controller.homeData.value?.recentActivity ?? [];

                return SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.all(w * 0.04),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// ================= TODAY TASK CARD =================
                      Container(
                        padding: EdgeInsets.all(w * 0.04),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF6A62D),
                          borderRadius: BorderRadius.circular(w * 0.05),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Today's Tasks",
                                  style: TextStyle(
                                    fontSize: w * 0.04,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Container(
                                  height: w * 0.08,
                                  width: w * 0.08,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border:
                                    Border.all(color: Colors.black),
                                  ),
                                  child: Icon(
                                    Icons.check,
                                    size: w * 0.045,
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: h * 0.015),
                            Text(
                              '${stats?.todaysTasks ?? 0}',
                              style: TextStyle(
                                fontSize: w * 0.08,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: h * 0.02),

                            /// VIEW ALL TASKS
                            GestureDetector(
                              onTap: onViewAllTasks,
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                    vertical: h * 0.015),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                  BorderRadius.circular(w * 0.04),
                                ),
                                child: Center(
                                  child: Text(
                                    'View All Tasks',
                                    style: TextStyle(
                                      fontSize: w * 0.04,
                                      color: Colors.orange,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: h * 0.035),

                      /// ================= QUICK ACCESS =================
                      Text(
                        'Quick Access',
                        style: TextStyle(
                          fontSize: w * 0.045,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: h * 0.02),

                      Row(
                        children: [
                          _quickItem(
                            context,
                            onTap: onViewSop,
                            icon: Icons.description_outlined,
                            title: 'View Sops',
                            subtitle: 'Work procedures',
                            iconBg: const Color(0xFFE8F0FF),
                            iconColor: Colors.blue,
                          ),
                          SizedBox(width: w * 0.04),
                          _quickItem(
                            context,
                            onTap: onViewMessage,
                            icon: Icons.chat_bubble_outline,
                            title: 'Messages',
                            subtitle: 'Contact manager',
                            iconBg: const Color(0xFFF3E8FF),
                            iconColor: Colors.purple,
                          ),
                        ],
                      ),

                      SizedBox(height: h * 0.04),

                      /// ================= RECENT ACTIVITY =================
                      Text(
                        'Recent Activity',
                        style: TextStyle(
                          fontSize: w * 0.045,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: h * 0.02),

                      if (recentActivity.isEmpty)
                         Padding(
                           padding: EdgeInsets.only(top: h * 0.05),
                           child: const Center(child: Text('No recent activity found')),
                         )
                      else
                        ...recentActivity.map((activity) => _activity(
                          context,
                          activity['title'] ?? 'Activity',
                          activity['time'] ?? activity['subtitle'] ?? '',
                          completed: activity['status'] == 'completed',
                          pending: activity['status'] == 'pending',
                        )),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  /// ================= QUICK ITEM =================
  Widget _quickItem(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String subtitle,
        required Color iconBg,
        required Color iconColor,
        required VoidCallback onTap,
      }) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(w * 0.04),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(w * 0.05),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: w * 0.04,
                offset: Offset(0, h * 0.006),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(w * 0.03),
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(w * 0.035),
                ),
                child: Icon(icon, color: iconColor, size: w * 0.06),
              ),
              SizedBox(height: h * 0.02),
              Text(
                title,
                style: TextStyle(
                  fontSize: w * 0.04,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: h * 0.006),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: w * 0.032,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ================= ACTIVITY ITEM =================
  Widget _activity(
      BuildContext context,
      String title,
      String subtitle, {
        bool pending = false,
        bool completed = false,
      }) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Container(
      margin: EdgeInsets.only(bottom: h * 0.018),
      padding: EdgeInsets.all(w * 0.04),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(w * 0.05),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: w * 0.04,
            offset: Offset(0, h * 0.006),
          )
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: w * 0.04,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: h * 0.006),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: w * 0.032,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          if (completed)
            Icon(Icons.check_circle,
                color: Colors.green, size: w * 0.07)
          else if (pending)
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: w * 0.04,
                vertical: h * 0.006,
              ),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Pending',
                style: TextStyle(
                  fontSize: w * 0.03,
                  color: Colors.orange,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}