import 'package:flutter/material.dart';
import 'package:subrate/models/tasks/get_tasks_model.dart';
import 'package:subrate/models/tasks/submit_task_model.dart';
import 'package:subrate/services/api/tasks/get_task_details_api.dart';
import 'package:subrate/services/api/tasks/submit_task_api.dart';
import 'package:subrate/theme/failure.dart';

class TaskProvider with ChangeNotifier {
  TaskDetailsModel? taskDetailsModel;
  Future getTaskDetails({required String taskID}) async {
    try {
      final response = await GetTaskDetailsApi(taskID: taskID).fetch();

      taskDetailsModel = TaskDetailsModel.fromJson(response['result']);
      notifyListeners();
      return true;
    } on Failure catch (f) {
      return f;
    }
  }

  Future submitTask({required SubmitTaskModel submitTaskModel}) async {
    try {
      var response =
          await SubmitTaskApi(submitTaskModel: submitTaskModel).fetch();

      print(response);
      return true;
    } on Failure {
      return false;
    }
  }
}
