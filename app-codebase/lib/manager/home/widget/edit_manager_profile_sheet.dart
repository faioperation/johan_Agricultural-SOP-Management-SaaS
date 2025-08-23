import 'dart:io';
import 'package:farm_check_support/manager/controller/manager_profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class EditManagerProfileSheet extends StatefulWidget {
  final String currentName;
  const EditManagerProfileSheet({super.key, required this.currentName});

  @override
  State<EditManagerProfileSheet> createState() => _EditManagerProfileSheetState();
}

class _EditManagerProfileSheetState extends State<EditManagerProfileSheet> {
  final ManagerProfileController controller = Get.find<ManagerProfileController>();
  late final TextEditingController _nameController;
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.currentName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final w = mq.size.width;
    final h = mq.size.height;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        w * 0.04,
        h * 0.02,
        w * 0.04,
        mq.viewInsets.bottom + h * 0.02,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Column(
              children: [
                Container(
                  width: w * 0.12,
                  height: h * 0.006,
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                SizedBox(height: h * 0.015),
                Text(
                  'Edit Profile',
                  style: TextStyle(
                    fontSize: w * 0.045,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: h * 0.025),

          Center(
            child: Stack(
              children: [
                CircleAvatar(
                  radius: w * 0.12,
                  backgroundColor: Colors.grey[200],
                  backgroundImage: _imageFile != null
                      ? FileImage(File(_imageFile!.path))
                      : (controller.profileData.value?.avatarUrl != null
                          ? NetworkImage(controller.profileData.value!.avatarUrl!) as ImageProvider
                          : null),
                  child: _imageFile == null && controller.profileData.value?.avatarUrl == null
                      ? Icon(Icons.person, size: w * 0.1, color: Colors.grey)
                      : null,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Color(0xFFFFA726),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.camera_alt, size: w * 0.04, color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: h * 0.02),

          Text(
            'Full Name',
            style: TextStyle(
              fontSize: w * 0.035,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: h * 0.01),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              hintText: 'Enter your name',
              filled: true,
              fillColor: const Color(0xFFF7F7F7),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(w * 0.035),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          SizedBox(height: h * 0.02),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: h * 0.055,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.black12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(w * 0.035),
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel', style: TextStyle(color: Colors.black)),
                  ),
                ),
              ),
              SizedBox(width: w * 0.03),
              Expanded(
                child: SizedBox(
                  height: h * 0.055,
                  child: Obx(() => ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFA726),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(w * 0.035),
                          ),
                        ),
                        onPressed: controller.isLoadingUpdate.value
                            ? null
                            : () async {
                                if (_nameController.text.trim().isNotEmpty) {
                                  final success = await controller.updateProfile(
                                    _nameController.text.trim(),
                                    imagePath: _imageFile?.path,
                                  );
                                  if (success) {
                                    Navigator.pop(context);
                                  }
                                } else {
                                  Get.snackbar("Error", "Name cannot be empty");
                                }
                              },
                        child: controller.isLoadingUpdate.value
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
                              )
                            : const Text(
                                'Update',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      )),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
