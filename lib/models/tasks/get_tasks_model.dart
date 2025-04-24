class TaskDetailsModel {
  String? createdAt;
  String? updatedAt;
  String? id;
  String? taskId;
  String? tenantId;
  String? traineeId;
  String? status;
  String? attachment;
  String? groupId;
  var payoutId;
  Task? task;

  TaskDetailsModel(
      {this.createdAt,
      this.updatedAt,
      this.id,
      this.taskId,
      this.tenantId,
      this.traineeId,
      this.status,
      this.attachment,
      this.groupId,
      this.payoutId,
      this.task});

  TaskDetailsModel.fromJson(Map<String, dynamic> json) {
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    id = json['id'];
    taskId = json['taskId'];
    tenantId = json['tenantId'];
    traineeId = json['traineeId'];
    status = json['status'];
    attachment = json['attachment'];
    groupId = json['groupId'];
    payoutId = json['payoutId'];
    task = json['task'] != null ? new Task.fromJson(json['task']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['id'] = this.id;
    data['taskId'] = this.taskId;
    data['tenantId'] = this.tenantId;
    data['traineeId'] = this.traineeId;
    data['status'] = this.status;
    data['attachment'] = this.attachment;
    data['groupId'] = this.groupId;
    data['payoutId'] = this.payoutId;
    if (this.task != null) {
      data['task'] = this.task!.toJson();
    }
    return data;
  }
}

class Task {
  String? title;
  String? description;
  int? point;
  String? link;
  String? deadlineDate;
  List<Steps>? steps;

  Task({this.title, this.description, this.point, this.link, this.steps});

  Task.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    point = json['point'];
    link = json['link'];
    if (json['steps'] != null) {
      steps = <Steps>[];
      json['steps'].forEach((v) {
        steps!.add(new Steps.fromJson(v));
      });
    }
    deadlineDate = json['deadline'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['description'] = this.description;
    data['point'] = this.point;
    data['link'] = this.link;
    if (this.steps != null) {
      data['steps'] = this.steps!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Steps {
  String? id;
  String? title;
  String? description;

  Steps({this.id, this.title});

  Steps.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    return data;
  }
}
