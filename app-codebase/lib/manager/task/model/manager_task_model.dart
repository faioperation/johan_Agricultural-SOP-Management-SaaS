class ManagerTaskResponse {
  final bool? success;
  final List<ManagerTask>? data;

  ManagerTaskResponse({this.success, this.data});

  factory ManagerTaskResponse.fromJson(Map<String, dynamic> json) {
    return ManagerTaskResponse(
      success: json['success'],
      data: json['data'] != null
          ? (json['data'] as List).map((i) => ManagerTask.fromJson(i)).toList()
          : null,
    );
  }
}

class ManagerTask {
  final String? id;
  final String? title;
  final String? description;
  final String? status;
  final String? scheduledAt;
  final String? shift;
  final String? farmId;
  final String? createdById;
  final String? assignedToId;
  final String? completedAt;
  final String? createdAt;
  final String? updatedAt;
  final AssignedTo? assignedTo;
  final String? note;

  ManagerTask({
    this.id,
    this.title,
    this.description,
    this.status,
    this.scheduledAt,
    this.shift,
    this.farmId,
    this.createdById,
    this.assignedToId,
    this.completedAt,
    this.createdAt,
    this.updatedAt,
    this.assignedTo,
    this.note,
  });

  factory ManagerTask.fromJson(Map<String, dynamic> json) {
    return ManagerTask(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      status: json['status'],
      scheduledAt: json['scheduledAt'],
      shift: json['shift'],
      farmId: json['farmId'],
      createdById: json['createdById'],
      assignedToId: json['assignedToId'],
      completedAt: json['completedAt'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      assignedTo: json['assignedTo'] != null
          ? AssignedTo.fromJson(json['assignedTo'])
          : null,
      note: json['note'],
    );
  }
}

class AssignedTo {
  final String? name;

  AssignedTo({this.name});

  factory AssignedTo.fromJson(Map<String, dynamic> json) {
    return AssignedTo(
      name: json['name'],
    );
  }
}
