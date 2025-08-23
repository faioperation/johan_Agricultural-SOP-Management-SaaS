class ApiUrls {
  static const String serverUrl = "http://172.252.13.90:8031";
  static const String baseUrl = "$serverUrl/api";

  // Auth
  static const String login = "$baseUrl/auth/login";
  static const String employeeLogin = "$baseUrl/employee/auth/login";
  static const String refreshToken = "$baseUrl/auth/refresh-token";
  static const String forgotPassword = "$baseUrl/auth/forgot-password";
  static const String verifyForgotOtp = "$baseUrl/auth/verify-forgot-password-otp";
  static const String resetPassword = "$baseUrl/auth/reset-password";
  // Manager Home
  static const String farmManagerHome = "$baseUrl/farm-manager/home";
  static const String farmManagerAllTasks = "$baseUrl/farm-manager/home/task-all";
  static const String farmManagerTasks = "$baseUrl/farm-manager/tasks";
  static String farmManagerTaskDetails(String id) => "$baseUrl/farm-manager/tasks/$id";

  // Employees
  static const String farmManagerEmployees = "$baseUrl/farm-manager/employees";
  static String farmManagerEmployeeDetails(String id) => "$baseUrl/farm-manager/employees/$id";
  static String farmManagerEmployeeTasks(String id) => "$baseUrl/farm-manager/employees/$id/tasks";

  // Profile
  static const String farmManagerProfile = "$baseUrl/farm-manager/profile";
  static const String employeeProfile = "$baseUrl/employee/profile";

  // Employee/User Home
  static const String employeeHome = "$baseUrl/employee/home";
  static const String employeeAllTasks = "$baseUrl/employee/home/view-all-tasks";
  // SOP
  static const String employeeSops = "$baseUrl/employee/sops";
  static String employeeSopList(String module) => "$baseUrl/employee/sops/$module";

  static String employeeSopRead(String id) => "$baseUrl/employee/sops/$id/read";
  static String employeeSopDetail(String id) => "$baseUrl/employee/sops/detail/$id";


  static const String getManagerSops = "$baseUrl/farm-manager/sops";
  static const String farmManagerSops = "$baseUrl/farm-manager/sops";
  static String farmManagerSopDetail(String id) => "$baseUrl/farm-manager/sops/detail/$id";

  // Manager Chat
  static const String managerConversations = "$baseUrl/farm-manager/messages/";
  static String managerChatHistory(String userId) => "$baseUrl/farm-manager/messages/history/$userId";
  static const String managerSendMessage = "$baseUrl/farm-manager/messages/";
  static const String managerContacts = "$baseUrl/farm-manager/messages/contacts/";

  // Employee Chat Endpoints
  static const String employeeConversations = "$baseUrl/employee/messages";
  static String employeeChatHistory(String userId) => "$baseUrl/employee/messages/conversation/$userId";
  static const String employeeSendMessage = "$baseUrl/employee/messages/send";
  static const String employeeContacts = "$baseUrl/employee/messages/contacts";

  // Profile Update
  static const String updateProfile = "$baseUrl/employee/profile/update";
  static const String changePassword = "$baseUrl/employee/profile/change-password";
  static const String updateManagerProfile = "$baseUrl/farm-manager/profile/update";
  static const String changeManagerPassword = "$baseUrl/farm-manager/auth/change-password";
  static String employeeTaskComplete(String id) => "$baseUrl/employee/tasks/$id/complete";
}
