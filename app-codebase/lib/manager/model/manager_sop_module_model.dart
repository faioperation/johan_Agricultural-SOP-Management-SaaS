class ManagerSopModuleResponse {
  final bool success;
  final List<ManagerSopModule> data;

  ManagerSopModuleResponse({
    required this.success,
    required this.data,
  });

  factory ManagerSopModuleResponse.fromJson(Map<String, dynamic> json) {
    return ManagerSopModuleResponse(
      success: json['success'] ?? false,
      data: (json['data'] as List)
          .map((e) => ManagerSopModule.fromJson(e))
          .toList(),
    );
  }
}

class ManagerSopModule {
  final String module;
  final int count;

  ManagerSopModule({
    required this.module,
    required this.count,
  });

  factory ManagerSopModule.fromJson(Map<String, dynamic> json) {
    return ManagerSopModule(
      module: json['module'] ?? '',
      count: json['count'] ?? 0,
    );
  }
}
