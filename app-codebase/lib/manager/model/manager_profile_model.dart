class ManagerProfileResponse {
  final bool? success;
  final ManagerProfileData? data;

  ManagerProfileResponse({this.success, this.data});

  factory ManagerProfileResponse.fromJson(Map<String, dynamic> json) {
    return ManagerProfileResponse(
      success: json['success'],
      data: json['data'] != null ? ManagerProfileData.fromJson(json['data']) : null,
    );
  }
}

class ManagerProfileData {
  final String? id;
  final String? name;
  final String? email;
  final String? farmName;
  final String? language;
  final String? avatarUrl;

  ManagerProfileData({
    this.id,
    this.name,
    this.email,
    this.farmName,
    this.language,
    this.avatarUrl,
  });

  factory ManagerProfileData.fromJson(Map<String, dynamic> json) {
    return ManagerProfileData(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      farmName: json['farmName'],
      language: json['language'],
      avatarUrl: json['avatarUrl'],
    );
  }
}
