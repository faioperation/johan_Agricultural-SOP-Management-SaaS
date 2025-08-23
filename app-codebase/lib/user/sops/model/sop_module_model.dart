class SopModuleResponse {
  final bool? success;
  final List<SopModule>? data;

  SopModuleResponse({this.success, this.data});

  factory SopModuleResponse.fromJson(Map<String, dynamic> json) {
    return SopModuleResponse(
      success: json['success'],
      data: json['data'] != null
          ? (json['data'] as List).map((i) => SopModule.fromJson(i)).toList()
          : null,
    );
  }
}

class SopModule {
  final String? module;
  final int? count;

  SopModule({this.module, this.count});

  factory SopModule.fromJson(Map<String, dynamic> json) {
    return SopModule(
      module: json['module'],
      count: json['count'],
    );
  }
}
