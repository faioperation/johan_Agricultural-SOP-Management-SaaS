class SopDetailResponse {
  final bool? success;
  final SopDetailData? data;

  SopDetailResponse({this.success, this.data});

  factory SopDetailResponse.fromJson(Map<String, dynamic> json) {
    return SopDetailResponse(
      success: json['success'],
      data: json['data'] != null ? SopDetailData.fromJson(json['data']) : null,
    );
  }
}

class SopDetailData {
  final String? id;
  final String? title;
  final String? module;
  final String? language;
  final String? updatedAt;
  final bool? isOfflineAvailable;
  final String? thumbnail;
  final SopContent? content;

  SopDetailData({
    this.id,
    this.title,
    this.module,
    this.language,
    this.updatedAt,
    this.isOfflineAvailable,
    this.thumbnail,
    this.content,
  });

  factory SopDetailData.fromJson(Map<String, dynamic> json) {
    return SopDetailData(
      id: json['id'],
      title: json['title'],
      module: json['module'],
      language: json['language'],
      updatedAt: json['updatedAt'],
      isOfflineAvailable: json['isOfflineAvailable'],
      thumbnail: json['thumbnail'],
      content: json['content'] != null ? SopContent.fromJson(json['content']) : null,
    );
  }
}

class SopContent {
  final List<SopSection>? sections;

  SopContent({this.sections});

  factory SopContent.fromJson(Map<String, dynamic> json) {
    return SopContent(
      sections: json['sections'] != null
          ? (json['sections'] as List).map((i) => SopSection.fromJson(i)).toList()
          : null,
    );
  }
}

class SopSection {
  final String? title;
  final List<String>? steps;

  SopSection({this.title, this.steps});

  factory SopSection.fromJson(Map<String, dynamic> json) {
    return SopSection(
      title: json['title'],
      steps: json['steps'] != null ? List<String>.from(json['steps']) : null,
    );
  }
}
