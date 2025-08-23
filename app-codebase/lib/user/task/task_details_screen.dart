import 'package:farm_check_support/user/task/controller/employee_task_controller.dart';
import 'package:farm_check_support/user/task/model/employee_task_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TaskDetailsScreen extends StatefulWidget {
  final EmployeeTask task;

  const TaskDetailsScreen({super.key, required this.task});

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  final EmployeeTaskController controller = Get.find<EmployeeTaskController>();
  final TextEditingController _noteController = TextEditingController();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final w = mq.size.width;
    final h = mq.size.height;

    return Obx(() {
      // Find the latest version of the task from the list to reflect status updates
      final currentTask = controller.tasks.firstWhere(
        (t) => t.id == widget.task.id,
        orElse: () => widget.task,
      );

      final scheduledDate = currentTask.scheduledAt != null
          ? DateTime.parse(currentTask.scheduledAt!).toLocal()
          : null;
      final timeStr = scheduledDate != null ? DateFormat.jm().format(scheduledDate) : "N/A";

      return Scaffold(
        backgroundColor: const Color(0xFFF9FAFB),
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              size: w * 0.045,
              color: Colors.black,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'Task Details',
            style: TextStyle(
              fontSize: w * 0.045,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(w * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ================= STATUS =================
              Container(
                padding: EdgeInsets.all(w * 0.035),
                decoration: BoxDecoration(
                  color: currentTask.isCompleted
                      ? const Color(0xFFE9FFF1)
                      : const Color(0xFFFFF1E6),
                  borderRadius: BorderRadius.circular(w * 0.04),
                  border: Border.all(
                    color: currentTask.isCompleted ? Colors.green : const Color(0xFFFFC08A),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      currentTask.isCompleted ? Icons.check_circle : Icons.error_outline,
                      size: w * 0.055,
                      color: currentTask.isCompleted ? Colors.green : Colors.orange,
                    ),
                    SizedBox(width: w * 0.03),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          currentTask.isCompleted ? 'Completed' : 'Pending',
                          style: TextStyle(
                            fontSize: w * 0.038,
                            fontWeight: FontWeight.w600,
                            color: currentTask.isCompleted ? Colors.green : Colors.orange,
                          ),
                        ),
                        SizedBox(height: h * 0.004),
                        Text(
                          currentTask.isCompleted
                              ? 'This task has been completed'
                              : 'This task is not yet completed',
                          style: TextStyle(
                            fontSize: w * 0.03,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: h * 0.02),

              /// ================= TASK INFO =================
              Container(
                padding: EdgeInsets.all(w * 0.04),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(w * 0.045),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currentTask.title ?? "Untitled",
                      style: TextStyle(
                        fontSize: w * 0.045,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: h * 0.015),
                    Text(
                      'Description',
                      style: TextStyle(
                        fontSize: w * 0.03,
                        color: Colors.black54,
                      ),
                    ),
                    SizedBox(height: h * 0.005),
                    Text(
                      currentTask.description ?? "No description provided",
                      style: TextStyle(fontSize: w * 0.034),
                    ),
                    SizedBox(height: h * 0.02),
                    Row(
                      children: [
                        _info(w, Icons.access_time, 'Time', timeStr),
                        SizedBox(width: w * 0.06),
                        _info(w, Icons.calendar_today, 'Shift', currentTask.shift ?? "N/A"),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: h * 0.02),

              /// ================= INSTRUCTIONS =================
              Container(
                padding: EdgeInsets.all(w * 0.04),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(w * 0.045),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '📘 Instructions',
                      style: TextStyle(
                        fontSize: w * 0.038,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: h * 0.01),
                    const _Bullet('Read the related SOP before starting work'),
                    const _Bullet('Follow all safety regulations'),
                    const _Bullet('Click the button below when task is complete'),
                    const _Bullet('Notify manager if any problems occur'),
                  ],
                ),
              ),

              SizedBox(height: h * 0.02),

              /// ================= NOTE =================
              if (currentTask.note != null && currentTask.note!.isNotEmpty)
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(bottom: h * 0.02),
                  padding: EdgeInsets.all(w * 0.04),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(w * 0.045),
                    border: Border.all(color: Colors.blue.withOpacity(0.1)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.note_alt_outlined, size: w * 0.04, color: Colors.blue),
                          SizedBox(width: w * 0.02),
                          Text(
                            'Note',
                            style: TextStyle(
                              fontSize: w * 0.038,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: h * 0.01),
                      Text(
                        currentTask.note!,
                        style: TextStyle(
                          fontSize: w * 0.034,
                          color: Colors.black87,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),

              if (!currentTask.isCompleted)
                Container(
                  padding: EdgeInsets.all(w * 0.04),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(w * 0.045),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Add Note (Optional)',
                        style: TextStyle(
                          fontSize: w * 0.038,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: h * 0.01),
                      TextField(
                        controller: _noteController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: 'Write any comments or notes about this task...',
                          filled: true,
                          fillColor: const Color(0xFFF7F7F7),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(w * 0.03),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              SizedBox(height: h * 0.03),

              /// ================= COMPLETE BUTTON =================
              if (!currentTask.isCompleted)
                SizedBox(
                  width: double.infinity,
                  height: h * 0.065,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFA726),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(w * 0.04),
                      ),
                    ),
                    onPressed: controller.isLoading.value
                        ? null
                        : () async {
                            if (currentTask.id == null || currentTask.id!.isEmpty) {
                              Get.snackbar("Error", "Invalid Task ID");
                              return;
                            }
                            await controller.completeTask(
                              currentTask.id!,
                              _noteController.text.trim(),
                            );
                            if (!controller.isLoading.value) {
                              Navigator.pop(context, true);
                            }
                          },
                    child: controller.isLoading.value
                        ? const CircularProgressIndicator(color: Colors.black)
                        : Text(
                            'Mark as Complete',
                            style: TextStyle(
                              fontSize: w * 0.04,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
            ],
          ),
        ),
      );
    });
  }

  /// ================= INFO ITEM =================
  static Widget _info(
      double w, IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: w * 0.045, color: Colors.blue),
        SizedBox(width: w * 0.015),
        Column(
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
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// ================= BULLET =================
class _Bullet extends StatelessWidget {
  final String text;
  const _Bullet(this.text);

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.only(bottom: w * 0.02),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('• ',
              style: TextStyle(fontSize: w * 0.045)),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: w * 0.034),
            ),
          ),
        ],
      ),
    );
  }
}
