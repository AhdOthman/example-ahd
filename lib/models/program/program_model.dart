class ProgramModel {
  String? id;
  String? title;
  List<Tasks>? tasks;

  ProgramModel({this.id, this.title, this.tasks});

  ProgramModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    if (json['tasks'] != null) {
      tasks = <Tasks>[];
      json['tasks'].forEach((v) {
        tasks!.add(new Tasks.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    if (this.tasks != null) {
      data['tasks'] = this.tasks!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Tasks {
  String? id;
  String? title;
  TaskPrograms? taskPrograms;

  Tasks({this.id, this.title, this.taskPrograms});

  Tasks.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    taskPrograms = json['task_programs'] != null
        ? new TaskPrograms.fromJson(json['task_programs'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
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
