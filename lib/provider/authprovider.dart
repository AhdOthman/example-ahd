import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:subrate/models/auth/signin_model_request.dart';
import 'package:subrate/models/auth/signup_model_request.dart';
import 'package:subrate/models/auth/update_password_model.dart';
import 'package:subrate/provider/appprovider.dart';
import 'package:subrate/routers/routers.dart';
import 'package:subrate/services/api/auth/signin_api.dart';
import 'package:subrate/services/api/auth/signup_api.dart';
import 'package:subrate/services/api/auth/update_password_api.dart';
import 'package:subrate/theme/failure.dart';
import 'package:subrate/theme/ui_helper.dart';

import '../models/auth/signin_response_model.dart';

class AuthProvider with ChangeNotifier {
  String? token;
  String? userName;
  bool get isAuth {
    return token != null;
  }

  Future signUp({required SignupModelRequest signUpRequestModel}) async {
    final prefs = await SharedPreferences.getInstance();

    try {
      var response =
          await SignupApi(signUpRequestModel: signUpRequestModel).fetch();

      if (response['statusCode'] == 200) {
        token = response['result']['token'];

        final userData = json.encode({
          'token': token,
        });
        prefs.setString('userData', userData);
      } else {
        UIHelper.showNotification(response['error']['details']);
        return false;
      }

      print(response);
      notifyListeners();
      return true;
    } on Failure {
      return false;
    }
  }

  Future login({
    required SigninModelRequest loginRequestModel,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    try {
      var response =
          await SigninApi(signinModelRequest: loginRequestModel).fetch();
      if (response['statusCode'] == 200) {
        print('objssssect');
        LoginResponseModel authResponse =
            LoginResponseModel.fromJson(response['result']);

        token = authResponse.token;
        userName = authResponse.user?.username ?? '';
        print(token);
        final userData = json.encode({
          'token': token,
        });
        prefs.setString('userData', userData);
      } else {
        UIHelper.showNotification(response['error']['details']);
        return false;
      }

      return true;
    } on Failure catch (e) {
      return e;
    }
  }

  String? tenantID;

  void changeTenant(String tenant) {
    tenantID = tenant;
    print('$tenantID tenant');
    notifyListeners();
  }

  Future chooseTenant(String tenantID) async {
    changeTenant(tenantID);
    final prefs = await SharedPreferences.getInstance();
    final userTenant = json.encode({
      'id': tenantID,
    });
    prefs.setString('userTenant', userTenant);
    notifyListeners();
    return true;
  }

  Future<bool> autologin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userTenant')) {
      debugPrint("no tenant data");
      return false;
    } else {
      print(" data tenant ex");

      final extractTenantData =
          json.decode(prefs.getString('userTenant').toString())
              as Map<String, dynamic>;

      tenantID = extractTenantData['id'];
      print('$tenantID tenant');
    }
    if (!prefs.containsKey('userData')) {
      debugPrint("no data");
      return false;
    }

    debugPrint(" data ex");

    final extractData = json.decode(prefs.getString('userData').toString())
        as Map<String, dynamic>;

    token = extractData['token'];
    notifyListeners();

    return true;
  }

  Future<void> logout(
    BuildContext context,
  ) async {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    final Routers routers = Routers();
    token = null;
    userName = null;
    // appProvider.selectedIndex = 0;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userTenant');
    await prefs.remove('userData');
    appProvider.selectedIndex = 0;
    tenantID = null;
    notifyListeners();
    routers.navigateToSigninScreen(context);
  }

  Future updatePassword(
      {required UpdatePasswordModel updatePasswordModel}) async {
    try {
      var response =
          await UpdatePasswordApi(updatePasswordModel: updatePasswordModel)
              .fetch();

      print(response);
      return true;
    } on Failure {
      return false;
    }
  }
}
