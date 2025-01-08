import 'package:flutter/material.dart';
import 'package:subrate/models/program/program_model.dart';
import 'package:subrate/models/program/tasks_program_model.dart';
import 'package:subrate/services/api/programs/get_programs_api.dart';
import 'package:subrate/services/api/programs/get_programs_tasks_api.dart';
import 'package:subrate/theme/failure.dart';

class ProgramProvider with ChangeNotifier {
  List<ProgramModel> programsList = [];
  List<ProgramModel>? get getProgramsList => programsList;
  setProgramsList(List<ProgramModel> value) {
    programsList = value;
    notifyListeners();
  }

  Future getPrograms() async {
    programsList.clear();
    try {
      final response = await GetProgramsApi().fetch();
      for (var type in response['result']) {
        programsList.add(ProgramModel.fromJson(type));
      }
      print('programList ${programsList.length}');
      setProgramsList(programsList);
      notifyListeners();
      return true;
    } on Failure catch (f) {
      return f;
    }
  }

  TasksByProgramModel? tasksByProgramModel;
  List<TasksByPrograms> tasksByProgramList = [];

  Future getTasksByPrograms({required String programId}) async {
    tasksByProgramList.clear();
    try {
      final response =
          await GetTasksByProgramsApi(programId: programId).fetch();
      tasksByProgramModel = TasksByProgramModel.fromJson(response['result']);
      for (var type in response['result']['tasks']) {
        tasksByProgramList.add(TasksByPrograms.fromJson(type));
      }
      print('tasksbyprogram ${tasksByProgramList.length}');
      notifyListeners();
      return true;
    } on Failure catch (f) {
      return f;
    }
  }
}
