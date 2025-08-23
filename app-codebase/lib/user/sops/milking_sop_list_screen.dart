import 'package:farm_check_support/app/urls.dart';
import 'package:farm_check_support/user/sops/controller/sop_controller.dart';
import 'package:farm_check_support/user/sops/sop_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MilkingSopListScreen extends StatefulWidget {
  final String moduleName;
  const MilkingSopListScreen({super.key, required this.moduleName});

  @override
  State<MilkingSopListScreen> createState() => _MilkingSopListScreenState();
}

class _MilkingSopListScreenState extends State<MilkingSopListScreen> {
  final SopController _sopController = Get.find<SopController>();
  int selectedIndex = -1;

  @override
  void initState() {
    super.initState();
    _sopController.fetchSopList(widget.moduleName);
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final w = mq.size.width;
    final h = mq.size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 18,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Obx(() => Row(
              children: [
                Text(
                  widget.moduleName,
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 18),
                ),
                SizedBox(width: w * 0.02),
                if (!_sopController.isLoadingSopList.value)
                  Text(
                    '(${_sopController.sopList.length} SOPs found)',
                    style: TextStyle(
                      fontSize: w * 0.032,
                      color: Colors.black54,
                    ),
                  ),
              ],
            )),
      ),
      body: Obx(() {
        if (_sopController.isLoadingSopList.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (_sopController.sopList.isEmpty) {
          return const Center(child: Text("No SOPs found for this module"));
        }

        return RefreshIndicator(
          onRefresh: () => _sopController.fetchSopList(widget.moduleName),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(w * 0.04),
            child: Column(
              children: [
                ...List.generate(_sopController.sopList.length, (index) {
                  final sop = _sopController.sopList[index];
                  return _sopCard(
                    context,
                    index: index,
                    id: sop.id ?? "",
                    title: sop.title ?? "",
                    offline: true, // Assuming offline for now as per image logic
                    updatedDate: sop.updatedAt?.split('T').first ?? "",
                    fileUrl: sop.fileUrl ?? "",
                  );
                }),
                SizedBox(height: h * 0.03),

                /// TIP BOX
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(w * 0.04),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF6E5),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFFFD38A)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.lightbulb_outline,
                        color: Colors.orange,
                      ),
                      SizedBox(width: w * 0.03),
                      Expanded(
                        child: Text(
                          'Tip: Offline SOPs can be read without internet. '
                          'Tap on a SOP to view details.',
                          style: TextStyle(
                            fontSize: w * 0.034,
                            color: Colors.black87,
                            height: 1.4,
                          ),
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

  /// ================= SOP CARD =================
  Widget _sopCard(
    BuildContext context, {
    required int index,
    required String id,
    required String title,
    required bool offline,
    required String updatedDate,
    required String fileUrl,
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
            builder: (_) => SopDetailScreen(
              sopId: id,
              title: title,
              fileUrl: fileUrl.startsWith('http') 
                  ? fileUrl 
                  : "${ApiUrls.serverUrl}${fileUrl.startsWith('/') ? fileUrl : '/$fileUrl'}",
              originalUrl: fileUrl,
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

          /// 🔥 SAME LEFT BOLD BORDER
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
              width: 8, // 👈 BOLD LEFT
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(w * 0.03),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F0FF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.description_outlined,
                color: Colors.blue,
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
                  SizedBox(height: h * 0.01),
                  Row(
                    children: [
                      _badge(
                        context,
                        text: offline ? 'Available Offline' : 'Download',
                        bg: offline ? const Color(0xFFE9FFF1) : const Color(0xFFFFEFEA),
                        textColor: offline ? Colors.green : Colors.orange,
                        icon: offline ? Icons.cloud_done : Icons.download,
                      ),
                    ],
                  ),
                  SizedBox(height: h * 0.012),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        size: 14,
                        color: Colors.black54,
                      ),
                      SizedBox(width: w * 0.02),
                      Text(
                        'Last updated: $updatedDate',
                        style: TextStyle(
                          fontSize: w * 0.032,
                          color: Colors.black54,
                        ),
                      ),
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

  /// ================= BADGE =================
  Widget _badge(
    BuildContext context, {
    required String text,
    required Color bg,
    required Color textColor,
    IconData? icon,
  }) {
    final w = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: w * 0.025,
        vertical: w * 0.012,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: textColor),
            SizedBox(width: w * 0.01),
          ],
          Text(
            text,
            style: TextStyle(
              fontSize: w * 0.03,
              color: textColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
