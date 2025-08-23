import 'package:farm_check_support/manager/controller/manager_home_controller.dart';
import 'package:farm_check_support/manager/controller/manager_profile_controller.dart';
import 'package:farm_check_support/manager/home/manager_profile-screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ManagerHomeScreen extends GetView<ManagerHomeController> {
  final VoidCallback onViewAllTasks;

  const ManagerHomeScreen({
    super.key,
    required this.onViewAllTasks,
  });

  @override
  Widget build(BuildContext context) {
    final profileController = Get.find<ManagerProfileController>();
    final mq = MediaQuery.of(context);
    final w = mq.size.width;
    final h = mq.size.height;
    final isTablet = w > 600;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),

      /// ================= APP BAR =================
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: w * 0.04,
        leadingWidth: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: w * 0.045,
              backgroundColor: const Color(0xFFE9FFF1),
              backgroundImage: const NetworkImage(
                'https://cdn-icons-png.flaticon.com/512/3135/3135715.png',
              ),
            ),
            SizedBox(width: w * 0.025),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() => Text(
                  profileController.profileData.value?.name ?? 'Loading...',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: w * 0.035,
                  ),
                )),
                Text(
                  'MANAGER PORTAL',
                  style: TextStyle(
                    fontSize: w * 0.028,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.settings_outlined,
              color: Colors.black,
              size: w * 0.06,
            ),
            onPressed: () {
              Get.to(() => const ManagerProfileScreen());
            },
          ),
        ],
      ),

      /// ================= BODY =================
      body: RefreshIndicator(
        onRefresh: () => controller.fetchDashboardData(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.all(w * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// DASHBOARD TITLE
              Text(
                'Dashboard',
                style: TextStyle(
                  fontSize: w * 0.045,
                  fontWeight: FontWeight.w700,
                ),
              ),

              SizedBox(height: h * 0.02),

              /// ================= STATS GRID =================
              Obx(() {
                final cards = controller.cards.value;
                return GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: isTablet ? 3 : 2,
                  mainAxisSpacing: w * 0.03,
                  crossAxisSpacing: w * 0.03,
                  childAspectRatio: isTablet ? 2.4 : 1.6,
                  children: [
                    _StatCard(
                      title: 'TOTAL TASKS',
                      value: '${cards?.totalTasks ?? 0}',
                      color: Colors.blue,
                      icon: Icons.check_circle_outline,
                    ),
                    _StatCard(
                      title: 'PENDING',
                      value: '${cards?.pending ?? 0}',
                      color: Colors.orange,
                      icon: Icons.access_time,
                    ),
                    _StatCard(
                      title: 'MESSAGES',
                      value: '${cards?.messages ?? 0}',
                      color: Colors.green,
                      icon: Icons.chat_bubble_outline,
                    ),
                    _StatCard(
                      title: 'SOPS',
                      value: '${cards?.sops ?? 0}',
                      color: Colors.purple,
                      icon: Icons.description_outlined,
                    ),
                  ],
                );
              }),

              SizedBox(height: h * 0.03),

              /// ================= TODAY TASKS =================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Today's Tasks",
                    style: TextStyle(
                      fontSize: w * 0.04,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextButton(
                    onPressed: onViewAllTasks,
                    child: Text(
                      'View All →',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: w * 0.035,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: h * 0.015),

              Obx(() {
                if (controller.isLoading.value && controller.todayTasks.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.todayTasks.isEmpty) {
                  return const Center(child: Text("No tasks for today"));
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.todayTasks.length,
                  itemBuilder: (context, index) {
                    final task = controller.todayTasks[index];
                    return _TaskTile(
                      title: task.title ?? "Untitled Task",
                      assigned: 'Assigned to: ${task.assignedTo ?? "Unknown"}',
                      time: task.time ?? "N/A",
                      status: task.status ?? "pending",
                    );
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

/// ================= STAT CARD =================
class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  final IconData icon;

  const _StatCard({
    required this.title,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.all(w * 0.035),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(w * 0.04),
        border: Border(left: BorderSide(color: color, width: 4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: w * 0.03,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: w * 0.028,
                  color: Colors.black54,
                ),
              ),
              SizedBox(height: w * 0.015),
              Text(
                value,
                style: TextStyle(
                  fontSize: w * 0.055,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Icon(icon, color: color, size: w * 0.07),
        ],
      ),
    );
  }
}

/// ================= TASK TILE =================
class _TaskTile extends StatelessWidget {
  final String title;
  final String assigned;
  final String time;
  final String status;

  const _TaskTile({
    required this.title,
    required this.assigned,
    required this.time,
    required this.status,
  });

  Color get _statusColor {
    switch (status) {
      case 'completed':
        return Colors.green;
      case 'in-progress':
        return Colors.blue;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Container(
      margin: EdgeInsets.only(bottom: w * 0.03),
      padding: EdgeInsets.all(w * 0.035),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(w * 0.04),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: w * 0.03,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: w * 0.035,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: w * 0.03,
                  vertical: w * 0.01,
                ),
                decoration: BoxDecoration(
                  color: _statusColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: w * 0.028,
                    color: _statusColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: w * 0.02),
          Text(
            assigned,
            style: TextStyle(
              fontSize: w * 0.03,
              color: Colors.black54,
            ),
          ),
          SizedBox(height: w * 0.01),
          Text(
            time,
            style: TextStyle(
              fontSize: w * 0.03,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}