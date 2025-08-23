import 'package:farm_check_support/manager/controller/employee_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmployeeDetailsScreen extends GetView<EmployeeDetailsController> {
  final String employeeId;
  final String employeeName;
  final String employeeRole;
  final String employeeEmail;
  final String employeeJoined;
  final String status;
  final String? avatarUrl;

  const EmployeeDetailsScreen({
    super.key,
    required this.employeeId,
    required this.employeeName,
    required this.employeeRole,
    required this.employeeEmail,
    required this.employeeJoined,
    required this.status,
    this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    // Fetch tasks when screen is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchEmployeeTasks(employeeId);
    });

    final mq = MediaQuery.of(context);
    final w = mq.size.width;
    final h = mq.size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        leadingWidth: w * 0.1,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: w * 0.045,
          ),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Employee Details',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black,
            fontSize: w * 0.045,
          ),
        ),
      ),

      body: RefreshIndicator(
        onRefresh: () => controller.fetchEmployeeTasks(employeeId),
        child: ListView(
          padding: EdgeInsets.all(w * 0.04),
          children: [
            /// ================= HEADER CARD =================
            Container(
              padding: EdgeInsets.all(w * 0.04),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(w * 0.04),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: w * 0.07,
                    backgroundColor: const Color(0xFFE8F0FF),
                    backgroundImage: avatarUrl != null && avatarUrl!.isNotEmpty
                        ? NetworkImage(avatarUrl!)
                        : null,
                    child: avatarUrl == null || avatarUrl!.isEmpty
                        ? Text(
                            employeeName.isNotEmpty
                                ? employeeName.substring(0, 1).toUpperCase()
                                : '?',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w600,
                              fontSize: w * 0.04,
                            ),
                          )
                        : null,
                  ),

                  SizedBox(width: w * 0.04),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                employeeName,
                                style: TextStyle(
                                  fontSize: w * 0.04,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(width: w * 0.02),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: w * 0.025,
                                vertical: h * 0.004,
                              ),
                              decoration: BoxDecoration(
                                color: (status == 'active' ? Colors.green : Colors.grey).withOpacity(0.15),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                status,
                                style: TextStyle(
                                  fontSize: w * 0.028,
                                  color: status == 'active' ? Colors.green : Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: h * 0.006),
                        Text(
                          employeeRole,
                          style: TextStyle(
                            fontSize: w * 0.032,
                            color: Colors.black54,
                          ),
                        ),
                        SizedBox(height: h * 0.004),
                        Text(
                          employeeEmail,
                          style: TextStyle(
                            fontSize: w * 0.03,
                            color: Colors.black45,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: h * 0.02),

            /// ================= STATS =================
            Obx(() {
              final stats = controller.employee.value?.stats;
              return Container(
                padding: EdgeInsets.symmetric(vertical: h * 0.02),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(w * 0.04),
                ),
                child: Row(
                  children: [
                    _StatItem(value: '${stats?.currentTasks ?? 0}', label: 'Current Tasks', color: Colors.blue),
                    const _Divider(),
                    _StatItem(value: '${stats?.completed ?? 0}', label: 'Completed', color: Colors.green),
                    const _Divider(),
                    _StatItem(value: '${stats?.total ?? 0}', label: 'Total Tasks', color: Colors.purple),
                  ],
                ),
              );
            }),

            SizedBox(height: h * 0.025),

            /// ================= TABS =================
            Obx(() => Row(
              children: [
                _TabItem(
                  icon: Icons.access_time,
                  text: 'Current (${controller.currentTasks.length})',
                  selected: controller.selectedTab.value == 0,
                  onTap: () => controller.selectTab(0),
                  w: w,
                ),
                SizedBox(width: w * 0.06),
                _TabItem(
                  icon: Icons.check_circle_outline,
                  text: 'Completed (${controller.completedTasks.length})',
                  selected: controller.selectedTab.value == 1,
                  onTap: () => controller.selectTab(1),
                  w: w,
                ),
              ],
            )),

            SizedBox(height: h * 0.02),

            /// ================= TASK LIST =================
            Obx(() {
              if (controller.isLoading.value && 
                  (controller.selectedTab.value == 0 ? controller.currentTasks.isEmpty : controller.completedTasks.isEmpty)) {
                return const Center(child: CircularProgressIndicator());
              }
              
              final tasks = controller.selectedTab.value == 0 
                  ? controller.currentTasks 
                  : controller.completedTasks;
                  
              if (tasks.isEmpty) {
                return const Center(child: Padding(
                  padding: EdgeInsets.only(top: 40.0),
                  child: Text("No tasks found"),
                ));
              }

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return _taskCard(
                    w,
                    title: task.title ?? "Untitled",
                    time: task.time ?? "N/A",
                    shift: task.shift ?? "N/A",
                    status: task.status ?? "PENDING",
                  );
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  /// ================= TASK CARD =================
  Widget _taskCard(
      double w, {
        required String title,
        required String time,
        required String shift,
        required String status,
      }) {
    Color color =
    status.toUpperCase() == 'COMPLETED' ? Colors.green : status.toUpperCase() == 'IN-PROGRESS'
        ? Colors.blue
        : Colors.orange;

    return Container(
      margin: EdgeInsets.only(bottom: w * 0.03),
      padding: EdgeInsets.all(w * 0.04),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(w * 0.04),
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
              const SizedBox(width: 8),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: w * 0.03,
                  vertical: w * 0.01,
                ),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: TextStyle(fontSize: w * 0.028, color: color),
                ),
              ),
            ],
          ),

          SizedBox(height: w * 0.02),

          Row(
            children: [
              Icon(Icons.access_time,
                  size: w * 0.035, color: Colors.black54),
              SizedBox(width: w * 0.01),
              Text(
                time,
                style: TextStyle(
                  fontSize: w * 0.028,
                  color: Colors.black54,
                ),
              ),
              SizedBox(width: w * 0.04),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: w * 0.025,
                  vertical: w * 0.01,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F3F5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  shift,
                  style: TextStyle(
                    fontSize: w * 0.028,
                    color: Colors.black54,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// ================= STAT ITEM =================
class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final Color color;

  const _StatItem({
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: w * 0.05,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
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

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Container(height: 36, width: 1, color: Colors.black12);
  }
}

/// ================= TAB ITEM =================
class _TabItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool selected;
  final VoidCallback onTap;
  final double w;

  const _TabItem({
    required this.icon,
    required this.text,
    required this.selected,
    required this.onTap,
    required this.w,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: w * 0.04,
                color: selected ? Colors.orange : Colors.black54,
              ),
              SizedBox(width: w * 0.015),
              Text(
                text,
                style: TextStyle(
                  fontSize: w * 0.032,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                  color: selected ? Colors.orange : Colors.black54,
                ),
              ),
            ],
          ),
          SizedBox(height: w * 0.015),
          if (selected)
            Container(height: 2, width: w * 0.32, color: Colors.orange),
        ],
      ),
    );
  }
}
