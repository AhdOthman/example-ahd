import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CallToken {
  String? token;
  String? tenantID;
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      debugPrint("no data");
      return ''; // Return null if there's no data
    }

    debugPrint("data exists");

    final extractData = json.decode(prefs.getString('userData').toString())
        as Map<String, dynamic>;

    String? token = extractData['token']; // Get the token from the data

    debugPrint("token $token");
    return token; // Return the token
  }

  Future<bool> getTenant() async {
    final prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey('userTenant')) {
      print("no tentat data");
      return false;
    }

    print("tenatnt ex");

    final extractLanguageData =
        json.decode(prefs.getString('userTenant').toString())
            as Map<String, dynamic>;

    tenantID = extractLanguageData['id'];
    print('tenantID $tenantID');

    print(tenantID);
    return true;
  }
}
