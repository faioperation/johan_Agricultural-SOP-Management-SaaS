import 'package:farm_check_support/manager/controller/employee_controller.dart';
import 'package:farm_check_support/manager/task/controller/manager_task_controller.dart';
import 'package:farm_check_support/manager/model/employee_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CreateTaskScreen extends StatefulWidget {
  final bool isEdit;
  final String? taskId;
  final String? title;
  final String? description;
  final String? employeeId;
  final String? shift;
  final DateTime? date;
  final TimeOfDay? time;

  const CreateTaskScreen({
    super.key,
    this.isEdit = false,
    this.taskId,
    this.title,
    this.description,
    this.employeeId,
    this.shift,
    this.date,
    this.time,
  });

  @override
  State<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  String? selectedEmployeeId;
  String selectedShift = 'MORNING';

  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  final EmployeeController employeeController = Get.find<EmployeeController>();
  final ManagerTaskController taskController = Get.find<ManagerTaskController>();

  @override
  void initState() {
    super.initState();
    titleController.text = widget.title ?? '';
    descriptionController.text = widget.description ?? '';
    selectedEmployeeId = widget.employeeId;
    selectedShift = widget.shift?.toUpperCase() ?? 'MORNING';
    selectedDate = widget.date;
    selectedTime = widget.time;
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
          widget.isEdit ? 'Edit Task' : 'Create Task',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black,
            fontSize: w * 0.045,
          ),
        ),
      ),

      /// ================= BODY =================
      body: ListView(
        padding: EdgeInsets.all(w * 0.04),
        children: [
          /// 📝 TASK TITLE
          _label(w, 'Task Title *'),
          _input(
            w,
            hint: 'e.g. Morning feeding schedule',
            controller: titleController,
          ),

          /// 🧾 DESCRIPTION
          _label(w, 'Description'),
          _input(
            w,
            hint: 'Detailed task instructions...',
            maxLines: 3,
            controller: descriptionController,
          ),

          /// 👤 ASSIGN EMPLOYEE
          _label(w, 'Assign Employee *', icon: Icons.people_outline),
          Obx(() {
            if (employeeController.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }
            final employees = employeeController.allEmployees;
            return _employeeDropdown(
              w,
              value: selectedEmployeeId,
              items: employees,
              onChanged: (v) => setState(() => selectedEmployeeId = v),
            );
          }),

          /// 📅 DATE & TIME
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label(w, 'Date *'),
                    _pickerInput(
                      w,
                      hint: selectedDate == null
                          ? 'Select Date'
                          : DateFormat('MM/dd/yy').format(selectedDate!),
                      icon: Icons.calendar_today,
                      onTap: _pickDate,
                    ),
                  ],
                ),
              ),
              SizedBox(width: w * 0.03),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label(w, 'Due Time *'),
                    _pickerInput(
                      w,
                      hint: selectedTime == null
                          ? 'Select Time'
                          : selectedTime!.format(context),
                      icon: Icons.access_time,
                      onTap: _pickTime,
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: h * 0.015),

          /// 🔄 SHIFT
          _label(w, 'Shift *'),
          _dropdown(
            w,
            value: selectedShift,
            items: const ['MORNING', 'AFTERNOON', 'EVENING'],
            onChanged: (v) => setState(() => selectedShift = v!),
          ),

          SizedBox(height: h * 0.03),

          /// 🟧 CREATE / SAVE BUTTON
          Obx(() {
            return SizedBox(
              height: w * 0.14,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFA726),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(w * 0.04),
                  ),
                ),
                icon: taskController.isLoading.value
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
                      )
                    : Icon(Icons.save, color: Colors.black, size: w * 0.05),
                label: Text(
                  widget.isEdit ? 'Save Changes' : 'Create Task',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: w * 0.04,
                  ),
                ),
                onPressed: taskController.isLoading.value ? null : _submitTask,
              ),
            );
          }),

          SizedBox(height: h * 0.015),

          /// ⬜ CANCEL
          SizedBox(
            height: w * 0.12,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.black12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(w * 0.04),
                ),
              ),
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(fontSize: w * 0.035, color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _submitTask() async {
    if (titleController.text.isEmpty) {
      Get.snackbar("Error", "Title is required");
      return;
    }
    if (selectedEmployeeId == null) {
      Get.snackbar("Error", "Please assign an employee");
      return;
    }
    if (selectedDate == null || selectedTime == null) {
      Get.snackbar("Error", "Date and Time are required");
      return;
    }

    final scheduledDateTime = DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      selectedTime!.hour,
      selectedTime!.minute,
    );

    bool success;
    if (widget.isEdit && widget.taskId != null) {
      success = await taskController.updateTask(
        widget.taskId!,
        {
          "title": titleController.text,
          "description": descriptionController.text,
          "assignedToId": selectedEmployeeId!,
          "scheduledAt": scheduledDateTime.toUtc().toIso8601String(),
          "shift": selectedShift,
        },
      );
    } else {
      success = await taskController.createTask(
        title: titleController.text,
        description: descriptionController.text,
        assignedToId: selectedEmployeeId!,
        scheduledAt: scheduledDateTime.toUtc().toIso8601String(),
        shift: selectedShift,
      );
    }

    if (success) {
      Navigator.pop(context);
      if (widget.isEdit) {
        Navigator.pop(context);
      }
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFFFA726),
              onPrimary: Colors.black,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: const TimePickerThemeData(
              backgroundColor: Colors.white,
              hourMinuteColor: Color(0xFFFFE0B2),
              hourMinuteTextColor: Colors.black,
              dialHandColor: Color(0xFFFFA726),
              dialBackgroundColor: Color(0xFFFFF3E0),
              dayPeriodColor: Color(0xFFFFE0B2),
              dayPeriodTextColor: Colors.black,
            ),
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFFFA726),
              onPrimary: Colors.black,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() => selectedTime = picked);
    }
  }

  Widget _label(double w, String text, {IconData? icon}) {
    return Padding(
      padding: EdgeInsets.only(bottom: w * 0.015),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: w * 0.045, color: Colors.black54),
            SizedBox(width: w * 0.015),
          ],
          Text(text, style: TextStyle(fontSize: w * 0.032, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _input(double w, {required String hint, int maxLines = 1, TextEditingController? controller}) {
    return Padding(
      padding: EdgeInsets.only(bottom: w * 0.03),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(fontSize: w * 0.032),
          filled: true,
          fillColor: const Color(0xFFF7F7F7),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(w * 0.04), borderSide: BorderSide.none),
        ),
      ),
    );
  }

  Widget _pickerInput(double w, {required String hint, required IconData icon, required VoidCallback onTap}) {
    return Padding(
      padding: EdgeInsets.only(bottom: w * 0.03),
      child: InkWell(
        onTap: onTap,
        child: IgnorePointer(
          child: TextField(
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(fontSize: w * 0.032),
              filled: true,
              fillColor: const Color(0xFFF7F7F7),
              prefixIcon: Icon(icon, size: w * 0.045, color: Colors.black54),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(w * 0.04), borderSide: BorderSide.none),
            ),
          ),
        ),
      ),
    );
  }

  Widget _dropdown(double w, {required String value, required List<String> items, required ValueChanged<String?> onChanged}) {
    return Padding(
      padding: EdgeInsets.only(bottom: w * 0.03),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: w * 0.04),
        decoration: BoxDecoration(
          color: const Color(0xFFF7F7F7),
          borderRadius: BorderRadius.circular(w * 0.04),
          border: Border.all(color: Colors.black12),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            dropdownColor: const Color(0xFFF7F7F7),
            icon: Icon(Icons.keyboard_arrow_down, size: w * 0.05),
            items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: TextStyle(fontSize: w * 0.032)))).toList(),
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }

  Widget _employeeDropdown(double w, {String? value, required List<Employee> items, required ValueChanged<String?> onChanged}) {
    return Padding(
      padding: EdgeInsets.only(bottom: w * 0.03),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: w * 0.04),
        decoration: BoxDecoration(
          color: const Color(0xFFF7F7F7),
          borderRadius: BorderRadius.circular(w * 0.04),
          border: Border.all(color: Colors.black12),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: value,
            hint: Text("Select Employee", style: TextStyle(fontSize: w * 0.032)),
            isExpanded: true,
            dropdownColor: const Color(0xFFF7F7F7),
            icon: Icon(Icons.keyboard_arrow_down, size: w * 0.05),
            items: items.map((e) => DropdownMenuItem(value: e.id, child: Text(e.name ?? '', style: TextStyle(fontSize: w * 0.032)))).toList(),
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }
}
