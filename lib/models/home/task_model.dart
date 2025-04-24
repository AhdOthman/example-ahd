class TaskModel {
  List<Tasks>? tasks;
  int? completedTaskCount;

  TaskModel({this.tasks, this.completedTaskCount});

  TaskModel.fromJson(Map<String, dynamic> json) {
    if (json['tasks'] != null) {
      tasks = <Tasks>[];
      json['tasks'].forEach((v) {
        tasks!.add(new Tasks.fromJson(v));
      });
    }
    completedTaskCount = json['completedTaskCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.tasks != null) {
      data['tasks'] = this.tasks!.map((v) => v.toJson()).toList();
    }
    data['completedTaskCount'] = this.completedTaskCount;
    return data;
  }
}

class Tasks {
  String? id;
  String? createdAt;
  String? traineeId;
  String? status;
  String? tenantId;
  Task? task;
  Group? group;

  Tasks(
      {this.id,
      this.createdAt,
      this.traineeId,
      this.status,
      this.tenantId,
      this.task,
      this.group});

  Tasks.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'];
    traineeId = json['traineeId'];
    status = json['status'];
    tenantId = json['tenantId'];
    task = json['task'] != null ? new Task.fromJson(json['task']) : null;
    group = json['group'] != null ? new Group.fromJson(json['group']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['createdAt'] = this.createdAt;
    data['traineeId'] = this.traineeId;
    data['status'] = this.status;
    data['tenantId'] = this.tenantId;
    if (this.task != null) {
      data['task'] = this.task!.toJson();
    }
    if (this.group != null) {
      data['group'] = this.group!.toJson();
    }
    return data;
  }
}

class Task {
  String? title;
  int? point;
  String? deadlineDate;
  String? description;
  List<Programs>? programs;

  Task({this.title, this.point, this.programs});

  Task.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    point = json['point'];
    description = json['description'];
    if (json['programs'] != null) {
      programs = <Programs>[];
      json['programs'].forEach((v) {
        programs!.add(new Programs.fromJson(v));
      });
    }
    deadlineDate = json['deadline'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['point'] = this.point;
    if (this.programs != null) {
      data['programs'] = this.programs!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Programs {
  String? id;
  TaskPrograms? taskPrograms;

  Programs({this.id, this.taskPrograms});

  Programs.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    taskPrograms = json['task_programs'] != null
        ? new TaskPrograms.fromJson(json['task_programs'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.taskPrograms != null) {
      data['task_programs'] = this.taskPrograms!.toJson();
    }
    return data;
  }
}

class TaskPrograms {
  String? createdAt;
  String? updatedAt;
  String? taskId;
  String? programId;

  TaskPrograms({this.createdAt, this.updatedAt, this.taskId, this.programId});

  TaskPrograms.fromJson(Map<String, dynamic> json) {
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    taskId = json['taskId'];
    programId = json['programId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['taskId'] = this.taskId;
    data['programId'] = this.programId;
    return data;
  }
}

class Group {
  String? id;
  String? name;

  Group({this.id, this.name});

  Group.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
