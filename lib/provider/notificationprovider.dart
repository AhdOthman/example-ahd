import 'package:flutter/material.dart';
import 'package:subrate/models/notification/notification_model.dart';
import 'package:subrate/services/api/notification/accept_invite_api.dart';
import 'package:subrate/services/api/notification/get_notifications_api.dart';
import 'package:subrate/services/api/notification/reject_invite_api.dart';
import 'package:subrate/theme/failure.dart';

class NotificationProvider with ChangeNotifier {
  List<NotificationModel> notificationList = [];
  List<NotificationModel>? get getNotificationList => notificationList;
  setNotificationList(List<NotificationModel> value) {
    notificationList = value;
    notifyListeners();
  }

  Future getNotifications() async {
    notificationList.clear();
    try {
      final response = await GetNotificationsApi().fetch();
      for (var type in response['result']['notifications']) {
        notificationList.add(NotificationModel.fromJson(type));
      }
      print('notifications ${notificationList.length}');
      setNotificationList(notificationList);
      notifyListeners();
      return true;
    } on Failure catch (f) {
      return f;
    }
  }

  Future acceptInvite({required String id}) async {
    try {
      var response = await AcceptInvitationApi(id: id).fetch();

      print(response);
      notifyListeners();
      return true;
    } on Failure {
      return false;
    }
  }

  Future rejectInvite({required String id}) async {
    try {
      var response = await RejectInviteApi(id: id).fetch();

      print(response);
      notifyListeners();
      return true;
    } on Failure {
      return false;
    }
  }
}
