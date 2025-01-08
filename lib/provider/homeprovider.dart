import 'package:flutter/material.dart';
import 'package:subrate/models/home/task_model.dart';
import 'package:subrate/models/home/tenant_model.dart';
import 'package:subrate/services/api/home/get_task_api.dart';
import 'package:subrate/services/api/home/get_tenant_api.dart';
import 'package:subrate/theme/failure.dart';

class HomeProvider with ChangeNotifier {
  List<TenantModel> tenantList = [];
  List<TenantModel>? get getTenantList => tenantList;
  setTenantList(List<TenantModel> value) {
    tenantList = value;
    notifyListeners();
  }

  Future getTenants() async {
    tenantList.clear();
    try {
      final response = await GetTenantApi().fetch();

      // Parse response and populate tenantList
      for (var type in response['result']) {
        tenantList.add(TenantModel.fromJson(type));
      }

      // Update each tenant's fullName to "Workspace index"
      // for (int i = 0; i < tenantList.length; i++) {
      //   tenantList[i].tenant?.fullName = 'Workspace ${i + 1}';
      // }

      print('tenantList ${tenantList.length}');
      setTenantList(tenantList);
      notifyListeners();
      return true;
    } on Failure catch (f) {
      return f;
    }
  }

  TaskModel? taskModel;
  List<Tasks> tasksList = [];

  Future getTasks() async {
    tasksList.clear();
    try {
      final response = await GetTaskApi().fetch();
      taskModel = TaskModel.fromJson(response['result']);
      for (var type in response['result']['tasks']) {
        tasksList.add(Tasks.fromJson(type));
      }
      print('tasksList.length ${tasksList.length}');

      print(taskModel);

      notifyListeners();
      return true;
    } on Failure catch (f) {
      return f;
    }
  }
}
