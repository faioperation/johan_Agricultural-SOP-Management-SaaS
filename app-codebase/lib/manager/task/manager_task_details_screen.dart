import 'package:farm_check_support/manager/task/controller/manager_task_controller.dart';
import 'package:farm_check_support/manager/task/model/manager_task_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'create_task_screen.dart';

class ManagerTaskDetailsScreen extends GetView<ManagerTaskController> {
  final ManagerTask task;
  const ManagerTaskDetailsScreen({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final w = mq.size.width;
    final h = mq.size.height;

    final scheduledDate = task.scheduledAt != null ? DateTime.parse(task.scheduledAt!) : null;

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
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Task Details',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black,
            fontSize: w * 0.045,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => _confirmDelete(context),
            icon: const Icon(Icons.delete_outline, color: Colors.red),
          ),
          TextButton.icon(
            onPressed: () {
              Get.to(() => CreateTaskScreen(
                    isEdit: true,
                    taskId: task.id,
                    title: task.title,
                    description: task.description,
                    employeeId: task.assignedToId,
                    shift: task.shift,
                    date: scheduledDate,
                    time: scheduledDate != null ? TimeOfDay.fromDateTime(scheduledDate) : null,
                  ));
            },
            icon: Icon(Icons.edit, size: w * 0.04, color: Colors.orange),
            label: Text(
              'Edit Task',
              style: TextStyle(
                color: Colors.orange,
                fontSize: w * 0.035,
              ),
            ),
          ),
        ],
      ),
      body: Obx(() {
        return Stack(
          children: [
            ListView(
              padding: EdgeInsets.all(w * 0.04),
              children: [
                _infoCard(w, h, scheduledDate),
                SizedBox(height: h * 0.02),
                if (task.status?.toUpperCase() == 'COMPLETED') _updateStatus(w, h),
              ],
            ),
            if (controller.isLoading.value)
              const Center(child: CircularProgressIndicator()),
          ],
        );
      }),
    );
  }

  void _confirmDelete(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Text("Delete Task"),
        content: const Text("Are you sure you want to delete this task?"),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              Get.back();
              controller.deleteTask(task.id!);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  /// ================= INFO CARD =================
  Widget _infoCard(double w, double h, DateTime? scheduledDate) {
    final status = task.status ?? 'PENDING';
    final Color color = status.toUpperCase() == 'COMPLETED' ? Colors.green : Colors.orange;

    return Container(
      padding: EdgeInsets.all(w * 0.04),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(w * 0.04),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// TITLE + STATUS
          Row(
            children: [
              Expanded(
                child: Text(
                  task.title ?? '',
                  style: TextStyle(
                    fontSize: w * 0.04,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: w * 0.03,
                  vertical: h * 0.004,
                ),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: w * 0.028,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: h * 0.015),
          Text(
            task.description ?? 'No description provided',
            style: TextStyle(
              fontSize: w * 0.032,
              color: Colors.black54,
            ),
          ),
          if (task.note != null && task.note!.isNotEmpty) ...[
            SizedBox(height: h * 0.02),
            Text(
              "Note:",
              style: TextStyle(
                fontSize: w * 0.035,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: h * 0.005),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(w * 0.03),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(w * 0.02),
                border: Border.all(color: Colors.black12),
              ),
              child: Text(
                task.note!,
                style: TextStyle(
                  fontSize: w * 0.032,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
          SizedBox(height: h * 0.025),
          Row(
            children: [
              _InfoItem(
                icon: Icons.person_outline,
                label: 'Assigned To',
                value: task.assignedTo?.name ?? 'Unassigned',
                w: w,
              ),
              _InfoItem(
                icon: Icons.access_time,
                label: 'Due Time',
                value: scheduledDate != null ? DateFormat.jm().format(scheduledDate) : 'N/A',
                w: w,
              ),
            ],
          ),
          SizedBox(height: h * 0.015),
          Row(
            children: [
              _InfoItem(
                icon: Icons.calendar_today_outlined,
                label: 'Date',
                value: scheduledDate != null ? DateFormat('MM/dd/yy').format(scheduledDate) : 'N/A',
                w: w,
              ),
              _InfoItem(
                icon: Icons.repeat,
                label: 'Shift',
                value: task.shift ?? 'N/A',
                w: w,
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// ================= UPDATE STATUS =================
  Widget _updateStatus(double w, double h) {
    return Container(
      padding: EdgeInsets.all(w * 0.04),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(w * 0.04),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Update Status:',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: w * 0.038,
            ),
          ),
          SizedBox(height: h * 0.02),
          SizedBox(
            width: double.infinity,
            height: h * 0.06,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.black12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(w * 0.03),
                ),
              ),
              onPressed: () => controller.resetTaskStatus(task.id!),
              child: Text(
                'Reset to Pending',
                style: TextStyle(
                  fontSize: w * 0.035,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ================= INFO ITEM =================
class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isLink;
  final double w;

  const _InfoItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.w,
    this.isLink = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          Icon(icon, size: w * 0.045, color: Colors.black54),
          SizedBox(width: w * 0.02),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: w * 0.028,
                    color: Colors.black54,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: w * 0.032,
                    fontWeight: FontWeight.w500,
                    color: isLink ? Colors.blue : Colors.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
