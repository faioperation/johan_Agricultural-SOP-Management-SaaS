class EmployeeProfileResponse {
  final bool? success;
  final EmployeeProfileData? data;

  EmployeeProfileResponse({this.success, this.data});

  factory EmployeeProfileResponse.fromJson(Map<String, dynamic> json) {
    return EmployeeProfileResponse(
      success: json['success'],
      data: json['data'] != null ? EmployeeProfileData.fromJson(json['data']) : null,
    );
  }
}

class EmployeeProfileData {
  final String? id;
  final String? name;
  final String? email;
  final String? role;
  final String? jobTitle;
  final String? avatarUrl;
  final String? language;
  final FarmInfo? farm;

  EmployeeProfileData({
    this.id,
    this.name,
    this.email,
    this.role,
    this.jobTitle,
    this.avatarUrl,
    this.language,
    this.farm,
  });

  factory EmployeeProfileData.fromJson(Map<String, dynamic> json) {
    return EmployeeProfileData(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
      jobTitle: json['jobTitle'],
      avatarUrl: json['avatarUrl'],
      language: json['language'],
      farm: json['farm'] != null ? FarmInfo.fromJson(json['farm']) : null,
    );
  }
}

class FarmInfo {
  final String? id;
  final String? name;

  FarmInfo({this.id, this.name});

  factory FarmInfo.fromJson(Map<String, dynamic> json) {
    return FarmInfo(
      id: json['id'],
      name: json['name'],
    );
  }
}
