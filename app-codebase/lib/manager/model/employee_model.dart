class EmployeeListResponse {
  final bool? success;
  final List<Employee>? data;

  EmployeeListResponse({this.success, this.data});

  factory EmployeeListResponse.fromJson(Map<String, dynamic> json) {
    return EmployeeListResponse(
      success: json['success'],
      data: json['data'] != null
          ? (json['data'] as List).map((i) => Employee.fromJson(i)).toList()
          : null,
    );
  }
}

class Employee {
  final String? id;
  final String? name;
  final String? role;
  final String? email;
  final String? status;
  final String? joinedAt;
   final int? tasksDone;
  final int? currentTasks;
  final String? avatarUrl;
  final EmployeeStats? stats;

  Employee({
    this.id,
    this.name,
    this.role,
    this.email,
    this.status,
    this.joinedAt,
    this.tasksDone,
    this.currentTasks,
    this.avatarUrl,
    this.stats,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'],
      name: json['name'],
      role: json['role'],
      email: json['email'],
      status: json['status'],
      joinedAt: json['joinedAt'],
       tasksDone: json['tasksDone'],
      currentTasks: json['currentTasks'],
      avatarUrl: json['avatarUrl'] ?? json['image'],
      stats: json['stats'] != null ? EmployeeStats.fromJson(json['stats']) : null,
    );
  }
}

class EmployeeStats {
  final int? currentTasks;
  final int? completed;
  final int? total;

  EmployeeStats({this.currentTasks, this.completed, this.total});

  factory EmployeeStats.fromJson(Map<String, dynamic> json) {
    return EmployeeStats(
      currentTasks: json['currentTasks'],
      completed: json['completed'],
      total: json['total'],
    );
  }
}

class EmployeeTasksResponse {
  final bool? success;
  final List<EmployeeTask>? data;

  EmployeeTasksResponse({this.success, this.data});

  factory EmployeeTasksResponse.fromJson(Map<String, dynamic> json) {
    return EmployeeTasksResponse(
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
  final String? time;
  final String? shift;
  final String? status;

  EmployeeTask({this.id, this.title, this.time, this.shift, this.status});

  factory EmployeeTask.fromJson(Map<String, dynamic> json) {
    return EmployeeTask(
      id: json['id'],
      title: json['title'],
      time: json['time'],
      shift: json['shift'],
      status: json['status'],
    );
  }
}
