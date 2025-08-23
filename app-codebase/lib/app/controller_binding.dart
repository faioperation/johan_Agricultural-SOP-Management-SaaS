import 'package:farm_check_support/app/token_service.dart';
import 'package:farm_check_support/auth/controller/forgot_password_controller.dart';
import 'package:farm_check_support/auth/controller/login_controller.dart';
import 'package:farm_check_support/auth/controller/otp_verify_controller.dart';
import 'package:farm_check_support/auth/controller/reset_password_controller.dart';
import 'package:farm_check_support/auth/repo/auth_repository.dart';
import 'package:farm_check_support/core/services/network/network_client.dart';
import 'package:farm_check_support/auth/screen/login_screen.dart';
import 'package:farm_check_support/manager/controller/employee_controller.dart';
import 'package:farm_check_support/manager/controller/manager_home_controller.dart';
import 'package:farm_check_support/manager/controller/manager_profile_controller.dart';
import 'package:farm_check_support/manager/sop/controller/manager_sop_module_controller.dart';
import 'package:farm_check_support/manager/task/controller/manager_task_controller.dart';
import 'package:farm_check_support/manager/repo/manager_repository.dart';
import 'package:farm_check_support/manager/repo/manager_chat_repository.dart';
import 'package:farm_check_support/user/repo/user_chat_repository.dart';
import 'package:farm_check_support/core/services/socket_service.dart';
import 'package:farm_check_support/manager/messages/controller/manager_chat_controller.dart';
import 'package:farm_check_support/user/messages/controller/user_chat_controller.dart';
import 'package:farm_check_support/user/home/controller/user_home_controller.dart';
import 'package:farm_check_support/user/profile/controller/user_profile_controller.dart';
import 'package:farm_check_support/user/repo/user_repository.dart';
import 'package:farm_check_support/user/sops/controller/sop_controller.dart';
import 'package:farm_check_support/user/sops/repo/sop_repository.dart';
import 'package:farm_check_support/user/task/controller/employee_task_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ControllerBinder extends Bindings {
  @override
  void dependencies() {
    Get.put<NetworkClient>(
      NetworkClient(
        onUnAuthorize: () {
          TokenService.clear();
          Get.offAll(() => const LoginScreen());
        },
        commonHeaders: () => {
          "Content-Type": "application/json",
          if (TokenService.accessToken != null)
            "Authorization": "Bearer ${TokenService.accessToken}",
        },
      ),
      permanent: true,
    );

    // Repositories
    Get.lazyPut<AuthRepository>(() => AuthRepository(Get.find()), fenix: true);
    Get.lazyPut<ManagerRepository>(() => ManagerRepository(Get.find()), fenix: true);
    Get.lazyPut<UserRepository>(() => UserRepository(Get.find()), fenix: true);
    Get.lazyPut<SopRepository>(() => SopRepository(Get.find()), fenix: true);
    Get.lazyPut<ManagerChatRepository>(() => ManagerChatRepository(Get.find()), fenix: true);
    Get.lazyPut<UserChatRepository>(() => UserChatRepository(Get.find()), fenix: true);
    Get.put<SocketService>(SocketService(), permanent: true);

    // Controllers
    Get.lazyPut<LoginController>(() => LoginController(Get.find()), fenix: true);
    Get.lazyPut<ForgotPasswordController>(() => ForgotPasswordController(Get.find()), fenix: true);
    Get.lazyPut<OtpVerifyController>(() => OtpVerifyController(Get.find()), fenix: true);
    Get.lazyPut<ResetPasswordController>(() => ResetPasswordController(Get.find()), fenix: true);

    Get.lazyPut<ManagerHomeController>(() => ManagerHomeController(Get.find()), fenix: true);
    Get.lazyPut<EmployeeController>(() => EmployeeController(Get.find()), fenix: true);
    Get.lazyPut<EmployeeDetailsController>(() => EmployeeDetailsController(Get.find()), fenix: true);
    Get.lazyPut<ManagerProfileController>(() => ManagerProfileController(Get.find()), fenix: true);
    
    Get.lazyPut<ManagerTaskController>(() => ManagerTaskController(Get.find()), fenix: true);
    
    Get.lazyPut<UserHomeController>(() => UserHomeController(Get.find()), fenix: true);
    Get.lazyPut<UserProfileController>(() => UserProfileController(Get.find()), fenix: true);
    Get.lazyPut<EmployeeTaskController>(() => EmployeeTaskController(Get.find()), fenix: true);
    Get.lazyPut<SopController>(() => SopController(Get.find()), fenix: true);
    Get.lazyPut<ManagerChatController>(() => ManagerChatController(Get.find(), Get.find()), fenix: true);
    Get.lazyPut<UserChatController>(() => UserChatController(Get.find(), Get.find()), fenix: true);
    Get.lazyPut(
          () => ManagerSopModuleController(Get.find<ManagerRepository>()),
    );

  }
}

class AppInitializer {
  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    await TokenService.loadTokens();
  }
}
