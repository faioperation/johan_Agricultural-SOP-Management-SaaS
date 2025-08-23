import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:farm_check_support/core/services/network/network_client.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class FileService {
  static Future<void> downloadFile(String url, String fileName, NetworkClient networkClient) async {
    try {
      // 1. Check Permissions
      bool hasPermission = await _requestPermissions();
      if (!hasPermission) {
        Get.snackbar("Permission Denied", "Storage permission is required to download files.");
        return;
      }

      // 2. Download File
      Get.snackbar("Downloading...", "Please wait while the file is being downloaded.", 
          showProgressIndicator: true, duration: const Duration(seconds: 2));
      
      final response = await networkClient.getBinaryRequest(url);

      if (response.isSuccess && response.responseData is Uint8List) {
        // 3. Save File
        final directory = await _getDownloadDirectory();
        final filePath = '${directory.path}/$fileName';
        final file = File(filePath);
        await file.writeAsBytes(response.responseData as Uint8List);

        Get.snackbar(
          "Download Complete",
          "File saved to $filePath",
          mainButton: TextButton(
            onPressed: () => OpenFilex.open(filePath),
            child: const Text("Open"),
          ),
          duration: const Duration(seconds: 5),
        );
      } else {
        Get.snackbar("Download Failed", response.errorMassage ?? "Failed to download file.");
      }
    } catch (e) {
      debugPrint("❌ Download Error: $e");
      Get.snackbar("Error", "An unexpected error occurred during download: $e");
    }
  }

  static Future<bool> _requestPermissions() async {
    if (Platform.isAndroid) {
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;
      
      if (androidInfo.version.sdkInt >= 33) {
        // Android 13+ doesn't use WRITE_EXTERNAL_STORAGE
        // For documents, we might not need specific permissions for app-specific folder
        // but let's check media permissions just in case if user wants to save elsewhere
        return true; 
      } else {
        final status = await Permission.storage.request();
        return status.isGranted;
      }
    } else if (Platform.isIOS) {
      // iOS permissions are handled via Info.plist and usually don't need explicit runtime prompt for app documents
      return true;
    }
    return true;
  }

  static Future<Directory> _getDownloadDirectory() async {
    if (Platform.isAndroid) {
      // For ease of access, try external storage
      Directory? externalDir = await getExternalStorageDirectory();
      if (externalDir != null) return externalDir;
    }
    return await getApplicationDocumentsDirectory();
  }
}
