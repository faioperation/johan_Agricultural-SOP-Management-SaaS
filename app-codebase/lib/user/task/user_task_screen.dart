import 'package:farm_check_support/user/task/controller/employee_task_controller.dart';
import 'package:farm_check_support/user/task/model/employee_task_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'task_details_screen.dart';

class UserTasksScreen extends GetView<EmployeeTaskController> {
  const UserTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final w = mq.size.width;
    final h = mq.size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'My Tasks',
          style: TextStyle(
            fontSize: w * 0.045,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => controller.fetchTasks(),
        child: Obx(() {
          if (controller.isLoading.value && controller.tasks.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          final visibleTasks = controller.selectedTab.value == 0
              ? controller.todayTasks
              : controller.selectedTab.value == 1
                  ? controller.upcomingTasks
                  : controller.completedTasks;

          return ListView(
            padding: EdgeInsets.all(w * 0.04),
            children: [
              /// 🔹 TABS
              Row(
                children: [
                  _tab(w, h, 'Today', 0),
                  _tab(w, h, 'Upcoming', 1),
                  _tab(w, h, 'Completed', 2),
                ],
              ),

              SizedBox(height: h * 0.02),

              /// 🔹 PROGRESS CARD
              if (controller.selectedTab.value == 0)
                _progressCard(w, h),

              SizedBox(height: h * 0.03),

              /// 🔹 TASK LIST
              if (visibleTasks.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 40.0),
                    child: Text("No tasks found"),
                  ),
                )
              else
                ...visibleTasks.map((t) => _taskItem(w, h, t, context)),
            ],
          );
        }),
      ),
    );
  }

  Widget _progressCard(double w, double h) {
    final completedCount = controller.completedTodayCount;
    final totalToday = controller.todayTasks.length;
    final progress = totalToday == 0 ? 0.0 : completedCount / totalToday;

    return Container(
      padding: EdgeInsets.all(w * 0.04),
      decoration: BoxDecoration(
        color: const Color(0xFFFFA726),
        borderRadius: BorderRadius.circular(w * 0.045),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Today's Progress",
            style: TextStyle(
              fontSize: w * 0.038,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: h * 0.01),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$completedCount/$totalToday',
                style: TextStyle(
                  fontSize: w * 0.06,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Tasks Completed',
                style: TextStyle(
                  fontSize: w * 0.032,
                ),
              ),
            ],
          ),
          SizedBox(height: h * 0.012),
          ClipRRect(
            borderRadius: BorderRadius.circular(w * 0.02),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: h * 0.008,
              backgroundColor: Colors.black26,
              valueColor: const AlwaysStoppedAnimation(Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  /// ================= TAB =================
  Widget _tab(double w, double h, String label, int index) {
    final active = controller.selectedTab.value == index;

    return GestureDetector(
      onTap: () => controller.selectTab(index),
      child: Container(
        margin: EdgeInsets.only(right: w * 0.025),
        padding: EdgeInsets.symmetric(
          horizontal: w * 0.04,
          vertical: h * 0.01,
        ),
        decoration: BoxDecoration(
          color: active ? const Color(0xFFFFE0B2) : const Color(0xFFF1F3F5),
          borderRadius: BorderRadius.circular(w * 0.06),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: w * 0.034,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  /// ================= TASK ITEM =================
  Widget _taskItem(double w, double h, EmployeeTask task, BuildContext context) {
    final scheduledDate = task.scheduledAt != null ? DateTime.parse(task.scheduledAt!).toLocal() : null;
    final timeStr = scheduledDate != null ? DateFormat.jm().format(scheduledDate) : "N/A";
    
    return GestureDetector(
      onTap: () async {
        Get.to(() => TaskDetailsScreen(task: task));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: h * 0.02),
        padding: EdgeInsets.all(w * 0.04),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(w * 0.045),
          border: Border(
            left: BorderSide(
              color: task.isCompleted ? Colors.green : const Color(0xFFFFA726),
              width: w * 0.015,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: w * 0.03,
              offset: Offset(0, h * 0.008),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              task.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
              color: task.isCompleted ? Colors.green : Colors.grey,
              size: w * 0.055,
            ),
            SizedBox(width: w * 0.03),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title ?? "Untitled",
                    style: TextStyle(
                      fontSize: w * 0.038,
                      fontWeight: FontWeight.w600,
                      decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  SizedBox(height: h * 0.006),
                  Text(
                    task.description ?? "No description",
                    style: TextStyle(
                      fontSize: w * 0.032,
                      color: Colors.black54,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: h * 0.012),
                  Row(
                    children: [
                      _chip(w, Icons.access_time, timeStr),
                      SizedBox(width: w * 0.02),
                      _chip(w, Icons.wb_sunny_outlined, task.shift ?? "N/A"),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chip(double w, IconData icon, String text) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: w * 0.03,
        vertical: w * 0.01,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF4FF),
        borderRadius: BorderRadius.circular(w * 0.06),
      ),
      child: Row(
        children: [
          Icon(icon, size: w * 0.04, color: Colors.blue),
          SizedBox(width: w * 0.01),
          Text(
            text,
            style: TextStyle(fontSize: w * 0.028),
          ),
        ],
      ),
    );
  }
}