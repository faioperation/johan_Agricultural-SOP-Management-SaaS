class SopListResponse {
  final bool? success;
  final List<SopItem>? data;

  SopListResponse({this.success, this.data});

  factory SopListResponse.fromJson(Map<String, dynamic> json) {
    return SopListResponse(
      success: json['success'],
      data: json['data'] != null
          ? (json['data'] as List).map((i) => SopItem.fromJson(i)).toList()
          : null,
    );
  }
}

class SopItem {
  final String? id;
  final String? title;
  final String? thumbnail;
  final String? fileUrl;
  final String? updatedAt;

  SopItem({this.id, this.title, this.thumbnail, this.fileUrl, this.updatedAt});

  factory SopItem.fromJson(Map<String, dynamic> json) {
    return SopItem(
      id: json['id'],
      title: json['title'],
      thumbnail: json['thumbnail'],
      fileUrl: json['fileUrl'] ?? json['thumbnail'], // fallback to thumbnail
      updatedAt: json['updatedAt'],
    );
  }
}
