class EmployeeTaskResponse {
  final bool? success;
  final List<EmployeeTask>? data;

  EmployeeTaskResponse({this.success, this.data});

  factory EmployeeTaskResponse.fromJson(Map<String, dynamic> json) {
    return EmployeeTaskResponse(
      success: json['success'],
      data: json['data'] != null
          ? (json['data'] as List).map((i) => EmployeeTask.fromJson(i)).toList()
          : null,
    );
  }
}

class EmployeeTask {
  final String? id;
  final String? title;
  final String? description;
  final String? status;
  final String? scheduledAt;
  final String? completedAt;
  final String? shift;
  final String? note;

  EmployeeTask({
    this.id,
    this.title,
    this.description,
    this.status,
    this.scheduledAt,
    this.completedAt,
    this.shift,
    this.note,
  });

  factory EmployeeTask.fromJson(Map<String, dynamic> json) {
    return EmployeeTask(
      id: json['id'] ?? json['_id'],
      title: json['title'],
      description: json['description'],
      status: json['status'],
      scheduledAt: json['scheduledAt'],
      completedAt: json['completedAt'],
      shift: json['shift'],
      note: json['completionNote'] ?? json['note'],
    );
  }

  // To match UI's logic
  bool get isCompleted => status?.toUpperCase() == 'COMPLETED';
}
