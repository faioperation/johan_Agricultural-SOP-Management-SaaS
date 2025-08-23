import 'package:farm_check_support/manager/sop/controller/manager_sop_module_controller.dart';
import 'package:farm_check_support/manager/sop/manager_sop_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ManagerSopModulesScreen extends StatefulWidget {
  const ManagerSopModulesScreen({super.key});

  @override
  State<ManagerSopModulesScreen> createState() =>
      _ManagerSopModulesScreenState();
}

class _ManagerSopModulesScreenState
    extends State<ManagerSopModulesScreen> {

  final controller = Get.find<ManagerSopModuleController>();
  int selectedIndex = -1;

  final List<Map<String, dynamic>> _moduleExtras = [
    {'image': 'assets/images/milking.png', 'bg': const Color(0xFFE8F0FF), 'subtitle': 'Daily Milking Procedures'},
    {'image': 'assets/images/feeding.png', 'bg': const Color(0xFFE9FFF1), 'subtitle': 'Animal health guidelines'},
    {'image': 'assets/images/animal_health.png', 'bg': const Color(0xFFFFEAEA), 'subtitle': 'Feeding & Nutrition SOPs'},
    {'image': 'assets/images/cow.png', 'bg': const Color(0xFFF1E8FF), 'subtitle': 'Equipment & Farm Maintenance'},
    {'image': 'assets/images/service.png', 'bg': const Color(0xFFFFEAEA), 'subtitle': 'Emergency Protocol'},
    {'image': 'assets/images/emergency.png', 'bg': const Color(0xFFE9FFF1), 'subtitle': 'Daily Calves SOPs'},
  ];

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
        title: const Text(
          'SOP Modules',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoadingModules.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.sopModules.isEmpty) {
          return const Center(child: Text("No SOP modules found"));
        }

        return RefreshIndicator(
          onRefresh: () => controller.fetchSopModules(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(w * 0.04),
            child: Column(
              children: [
                ...List.generate(controller.sopModules.length, (index) {
                  final module = controller.sopModules[index];
                  final extra = _moduleExtras[index % _moduleExtras.length];
                  return _sopItem(
                    context,
                    index: index,
                    title: module.module ?? "",
                    subtitle: extra['subtitle'],
                    sopCount: '${module.count ?? 0} SOP',
                    imagePath: extra['image'],
                    imageBg: extra['bg'],
                  );
                }),
                SizedBox(height: h * 0.03),

                /// ABOUT SOPs
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(w * 0.04),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF4FF),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFBFD4FF)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.info_outline, color: Colors.blue),
                          SizedBox(width: w * 0.02),
                          Text(
                            'About SOPs',
                            style: TextStyle(
                              fontSize: w * 0.04,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: h * 0.01),
                      const Text(
                        'SOP (Standard Operating Procedure) is a standard work method. '
                        'Follow these guidelines to do each task correctly.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _sopItem(
      BuildContext context, {
        required int index,
        required String title,
        required String subtitle,
        required String sopCount,
        required String imagePath,
        required Color imageBg,
      }) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    final bool isSelected = selectedIndex == index;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        setState(() {
          selectedIndex = index;
        });

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ManagerSopsScreen(
              moduleName: title,
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: h * 0.02),
        padding: EdgeInsets.all(w * 0.035),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border(
            top: BorderSide(
              color: isSelected ? Colors.orange : Colors.black12,
              width: 1,
            ),
            right: BorderSide(
              color: isSelected ? Colors.orange : Colors.black12,
              width: 1,
            ),
            bottom: BorderSide(
              color: isSelected ? Colors.orange : Colors.black12,
              width: 1,
            ),
            left: BorderSide(
              color: isSelected ? Colors.orange : Colors.black12,
              width: 8,
            ),
          ),
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
            Container(
              padding: EdgeInsets.all(w * 0.025),
              decoration: BoxDecoration(
                color: imageBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Image.asset(
                imagePath,
                width: w * 0.07,
                height: w * 0.07,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(width: w * 0.04),
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
                  SizedBox(height: h * 0.004),
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
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: w * 0.03,
                vertical: h * 0.006,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F3F5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                sopCount,
                style: TextStyle(
                  fontSize: w * 0.03,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
