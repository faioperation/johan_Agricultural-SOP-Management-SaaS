import 'package:farm_check_support/manager/controller/employee_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'employee_details_screen.dart';

class EmployeeListScreen extends GetView<EmployeeController> {
  const EmployeeListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final w = mq.size.width;
    final h = mq.size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Employee',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black,
            fontSize: w * 0.045,
          ),
        ),
      ),

      body: RefreshIndicator(
        onRefresh: () => controller.fetchEmployees(),
        child: ListView(
          padding: EdgeInsets.all(w * 0.04),
          children: [
            /// ================= SEARCH =================
            Container(
              padding: EdgeInsets.symmetric(horizontal: w * 0.035),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F3F5),
                borderRadius: BorderRadius.circular(w * 0.03),
              ),
              child: TextField(
                onChanged: (v) => controller.searchTeam(v),
                decoration: InputDecoration(
                  hintText: 'Search team...',
                  hintStyle: TextStyle(fontSize: w * 0.035),
                  border: InputBorder.none,
                  icon: Icon(Icons.search, size: w * 0.05),
                ),
              ),
            ),

            SizedBox(height: h * 0.02),

            /// ================= FILTER =================
            Obx(() => Row(
              children: [
                _FilterChip(
                  text: 'All',
                  selected: controller.selectedFilter.value == 0,
                  onTap: () => controller.setFilter(0),
                  w: w,
                ),
                SizedBox(width: w * 0.02),
                _FilterChip(
                  text: 'Active',
                  selected: controller.selectedFilter.value == 1,
                  onTap: () => controller.setFilter(1),
                  w: w,
                ),
                SizedBox(width: w * 0.02),
                _FilterChip(
                  text: 'Inactive',
                  selected: controller.selectedFilter.value == 2,
                  onTap: () => controller.setFilter(2),
                  w: w,
                ),
              ],
            )),

            SizedBox(height: h * 0.03),

            /// ================= EMPLOYEE LIST =================
            Obx(() {
              if (controller.isLoading.value && controller.filteredEmployees.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.filteredEmployees.isEmpty) {
                return const Center(child: Padding(
                  padding: EdgeInsets.only(top: 100.0),
                  child: Text("No employees found"),
                ));
              }
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.filteredEmployees.length,
                itemBuilder: (context, index) {
                  final employee = controller.filteredEmployees[index];
                  return _employeeCard(
                    context,
                    w: w,
                    name: employee.name ?? "Unknown",
                    role: employee.role ?? "N/A",
                    email: employee.email ?? "N/A",
                    joined: employee.joinedAt ?? "N/A",
                    tasksDone: employee.tasksDone ?? 0,
                    currentTasks: employee.currentTasks ?? 0,
                    id: employee.id ?? "",
                    status: employee.status?.toLowerCase() ?? "inactive",
                    avatarUrl: employee.avatarUrl,
                  );
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  /// ================= EMPLOYEE CARD =================
  Widget _employeeCard(
      BuildContext context, {
        required double w,
        required String name,
        required String role,
        required String email,
        required String joined,
        required int tasksDone,
        required int currentTasks,
        required String id,
        required String status,
        String? avatarUrl,
      }) {
    return Container(
      margin: EdgeInsets.only(bottom: w * 0.04),
      padding: EdgeInsets.all(w * 0.04),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(w * 0.04),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: w * 0.04,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER
          Row(
            children: [
              CircleAvatar(
                radius: w * 0.055,
                backgroundColor: const Color(0xFFE8F0FF),
                backgroundImage: avatarUrl != null && avatarUrl.isNotEmpty
                    ? NetworkImage(avatarUrl)
                    : null,
                child: avatarUrl == null || avatarUrl.isEmpty
                    ? Icon(Icons.person, color: Colors.blue, size: w * 0.06)
                    : null,
              ),
              SizedBox(width: w * 0.03),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: w * 0.038,
                      ),
                    ),
                    Text(
                      role,
                      style: TextStyle(
                        fontSize: w * 0.032,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.check_circle,
                  color: status == 'active' ? Colors.green : Colors.grey,
                  size: w * 0.05),
            ],
          ),

          SizedBox(height: w * 0.03),

          Text(
            email,
            style: TextStyle(
              fontSize: w * 0.032,
              color: Colors.black54,
            ),
          ),

          SizedBox(height: w * 0.035),
          const Divider(height: 1),
          SizedBox(height: w * 0.035),

          /// STATS
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _stat(
                w,
                'Tasks Done',
                tasksDone.toString(),
                color: Colors.green,
              ),
              _stat(
                w,
                'Current Tasks',
                currentTasks.toString(),
                color: Colors.blue,
              ),
            ],
          ),

          SizedBox(height: w * 0.035),

          /// BUTTON
          SizedBox(
            width: double.infinity,
            height: w * 0.12,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.black12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(w * 0.025),
                ),
              ),
              onPressed: () {
                Get.to(() => EmployeeDetailsScreen(
                  employeeId: id,
                  employeeName: name,
                  employeeRole: role,
                  employeeEmail: email,
                  employeeJoined: joined,
                  status: status,
                  avatarUrl: avatarUrl,
                ));
              },
              icon: Icon(Icons.remove_red_eye,
                  size: w * 0.045, color: Colors.black),
              label: Text(
                'View Tasks',
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

  Widget _stat(double w, String label, String value,
      {required Color color}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: w * 0.045,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: w * 0.03,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }
}

/// ================= FILTER CHIP =================
class _FilterChip extends StatelessWidget {
  final String text;
  final bool selected;
  final VoidCallback onTap;
  final double w;

  const _FilterChip({
    required this.text,
    required this.selected,
    required this.onTap,
    required this.w,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: w * 0.05,
          vertical: w * 0.025,
        ),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFFFA726) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.black12),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: w * 0.032,
            fontWeight: FontWeight.w500,
            color: selected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}
