class EmployeeHomeResponse {
  final bool? success;
  final EmployeeHomeData? data;

  EmployeeHomeResponse({this.success, this.data});

  factory EmployeeHomeResponse.fromJson(Map<String, dynamic> json) {
    return EmployeeHomeResponse(
      success: json['success'],
      data: json['data'] != null ? EmployeeHomeData.fromJson(json['data']) : null,
    );
  }
}

class EmployeeHomeData {
  final EmployeeInfo? employee;
  final EmployeeStats? stats;
  final List<dynamic>? recentActivity;

  EmployeeHomeData({this.employee, this.stats, this.recentActivity});

  factory EmployeeHomeData.fromJson(Map<String, dynamic> json) {
    return EmployeeHomeData(
      employee: json['employee'] != null ? EmployeeInfo.fromJson(json['employee']) : null,
      stats: json['stats'] != null ? EmployeeStats.fromJson(json['stats']) : null,
      recentActivity: json['recentActivity'],
    );
  }
}

class EmployeeInfo {
  final String? id;
  final String? name;
  final String? avatarUrl;
  final String? jobTitle;

  EmployeeInfo({this.id, this.name, this.avatarUrl, this.jobTitle});

  factory EmployeeInfo.fromJson(Map<String, dynamic> json) {
    return EmployeeInfo(
      id: json['id'],
      name: json['name'],
      avatarUrl: json['avatarUrl'],
      jobTitle: json['jobTitle'],
    );
  }
}

class EmployeeStats {
  final int? todaysTasks;

  EmployeeStats({this.todaysTasks});

  factory EmployeeStats.fromJson(Map<String, dynamic> json) {
    return EmployeeStats(
      todaysTasks: json['todaysTasks'],
    );
  }
}
