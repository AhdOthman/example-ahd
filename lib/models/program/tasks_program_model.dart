class TasksByProgramModel {
  String? id;
  String? title;
  String? link;
  List<TasksByPrograms>? tasks;

  TasksByProgramModel({this.id, this.title, this.link, this.tasks});

  TasksByProgramModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    link = json['link'];
    if (json['tasks'] != null) {
      tasks = <TasksByPrograms>[];
      json['tasks'].forEach((v) {
        tasks!.add(new TasksByPrograms.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['link'] = this.link;
    if (this.tasks != null) {
      data['tasks'] = this.tasks!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TasksByPrograms {
  String? id;
  String? title;
  int? point;
  String? createdAt;
  String? description;
  List<Submissions>? submissions;
  String? deadline;
  TaskPrograms? taskPrograms;

  TasksByPrograms(
      {this.id,
      this.title,
      this.point,
      this.createdAt,
      this.submissions,
      this.taskPrograms});

  TasksByPrograms.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    point = json['point'];
    createdAt = json['createdAt'];
    description = json['description'];
    deadline = json['deadline'];
    if (json['submissions'] != null) {
      submissions = <Submissions>[];
      json['submissions'].forEach((v) {
        submissions!.add(new Submissions.fromJson(v));
      });
    }
    taskPrograms = json['task_programs'] != null
        ? new TaskPrograms.fromJson(json['task_programs'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['point'] = this.point;
    data['createdAt'] = this.createdAt;
    if (this.submissions != null) {
      data['submissions'] = this.submissions!.map((v) => v.toJson()).toList();
    }
    if (this.taskPrograms != null) {
      data['task_programs'] = this.taskPrograms!.toJson();
    }
    return data;
  }
}

class Submissions {
  String? id;

  Submissions({this.id});

  Submissions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
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
