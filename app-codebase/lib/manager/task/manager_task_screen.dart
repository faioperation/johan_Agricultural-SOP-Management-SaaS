import 'package:farm_check_support/manager/task/controller/manager_task_controller.dart';
import 'package:farm_check_support/manager/task/model/manager_task_model.dart';
import 'package:farm_check_support/manager/task/widgets/task_filter_tabs.dart';
import 'package:flutter/material.dart';
import 'package:farm_check_support/manager/task/manager_task_details_screen.dart';
import 'package:get/get.dart';
import 'create_task_screen.dart';

class ManagerTasksScreen extends GetView<ManagerTaskController> {
  const ManagerTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final w = mq.size.width;
    final h = mq.size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),

      /// ================= APP BAR =================
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Tasks',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black,
            fontSize: w * 0.045,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: w * 0.03),
            child: SizedBox(
              height: h * 0.045,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFA726),
                  elevation: 0,
                  padding: EdgeInsets.symmetric(horizontal: w * 0.04),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(w * 0.03),
                  ),
                ),
                icon: Icon(Icons.add,
                    color: Colors.black, size: w * 0.045),
                label: Text(
                  'Create Task',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: w * 0.032,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onPressed: () {
                  Get.to(() => const CreateTaskScreen());
                },
              ),
            ),
          ),
        ],
      ),

      /// ================= BODY =================
      body: RefreshIndicator(
        onRefresh: () => controller.fetchTasks(),
        child: Obx(() {
          if (controller.isLoading.value && controller.allTasks.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView(
            padding: EdgeInsets.all(w * 0.04),
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              /// 🔍 SEARCH
              Container(
                padding: EdgeInsets.symmetric(horizontal: w * 0.04),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F3F5),
                  borderRadius: BorderRadius.circular(w * 0.035),
                ),
                child: TextField(
                  onChanged: (val) => controller.searchTasks(val),
                  decoration: InputDecoration(
                    hintText: 'Search tasks...',
                    hintStyle: TextStyle(fontSize: w * 0.032),
                    border: InputBorder.none,
                    icon: Icon(Icons.search, size: w * 0.05),
                  ),
                ),
              ),

              SizedBox(height: h * 0.02),

              /// 🔘 FILTER TABS
              TaskFilterTabs(
                selectedIndex: controller.selectedTab.value,
                onChanged: (i) => controller.setFilter(i),
              ),

              SizedBox(height: h * 0.025),

              /// 📋 TASK LIST
              if (controller.filteredTasks.isEmpty)
                const Center(child: Text("No tasks found"))
              else
                ...controller.filteredTasks.map(
                      (task) => _taskCard(
                    context,
                    w: w,
                    h: h,
                    task: task,
                  ),
                ),
            ],
          );
        }),
      ),
    );
  }

  /// ================= TASK CARD =================
  Widget _taskCard(
      BuildContext context, {
        required double w,
        required double h,
        required ManagerTask task,
      }) {
    final String status = task.status ?? 'PENDING';
    final Color color =
    status.toUpperCase() == 'COMPLETED' ? Colors.green : Colors.orange;

    return InkWell(
      borderRadius: BorderRadius.circular(w * 0.04),
      onTap: () {
        Get.to(() => ManagerTaskDetailsScreen(task: task));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: h * 0.018),
        padding: EdgeInsets.all(w * 0.04),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(w * 0.04),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title ?? '',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: w * 0.038,
                    ),
                  ),
                  SizedBox(height: h * 0.006),
                  Text(
                    '${task.assignedTo?.name ?? 'Unassigned'} · ${task.shift ?? ''}',
                    style: TextStyle(
                      fontSize: w * 0.03,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: w * 0.03,
                vertical: h * 0.004,
              ),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                status,
                style: TextStyle(
                  fontSize: w * 0.028,
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
