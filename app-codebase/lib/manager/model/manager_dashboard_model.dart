class ManagerDashboardModel {
  final bool? success;
  final DashboardData? data;

  ManagerDashboardModel({this.success, this.data});

  factory ManagerDashboardModel.fromJson(Map<String, dynamic> json) {
    return ManagerDashboardModel(
      success: json['success'],
      data: json['data'] != null ? DashboardData.fromJson(json['data']) : null,
    );
  }
}

class DashboardData {
  final DashboardCards? cards;
  final List<TodayTask>? todayTasks;

  DashboardData({this.cards, this.todayTasks});

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    return DashboardData(
      cards: json['cards'] != null ? DashboardCards.fromJson(json['cards']) : null,
      todayTasks: json['todayTasks'] != null
          ? (json['todayTasks'] as List).map((i) => TodayTask.fromJson(i)).toList()
          : null,
    );
  }
}

class DashboardCards {
  final int? totalTasks;
  final int? pending;
  final int? messages;
  final int? sops;

  DashboardCards({this.totalTasks, this.pending, this.messages, this.sops});

  factory DashboardCards.fromJson(Map<String, dynamic> json) {
    return DashboardCards(
      totalTasks: json['totalTasks'],
      pending: json['pending'],
      messages: json['messages'],
      sops: json['sops'],
    );
  }
}

class TodayTask {
  final String? id;
  final String? title;
  final String? time;
  final String? status;
  final String? assignedTo;

  TodayTask({this.id, this.title, this.time, this.status, this.assignedTo});

  factory TodayTask.fromJson(Map<String, dynamic> json) {
    return TodayTask(
      id: json['id'],
      title: json['title'],
      time: json['time'],
      status: json['status'],
      assignedTo: json['assignedTo'],
    );
  }
}
