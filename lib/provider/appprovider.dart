import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:subrate/models/app/get_country_model.dart';
import 'package:subrate/services/api/app/get_country_list_api.dart';
import 'package:subrate/theme/failure.dart';

class AppProvider with ChangeNotifier {
  bool isFromHome = false;
  var dateFormat = DateFormat('dd MMM,yyyy', 'en');
  int selectedIndex = 0;
  void onItemTapped(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  bool isTablet(BuildContext context) {
    final sizew = MediaQuery.of(context).size.width;
    return sizew > 500;
  }

  List<GetCountryList> countryList = [];
  List<GetCountryList>? get getCountryList => countryList;
  setCountryList(List<GetCountryList> value) {
    countryList = value;
    notifyListeners();
  }

  Future getCountries() async {
    countryList.clear();
    try {
      final response = await GetCountryListApi().fetch();
      for (var type in response['result']) {
        countryList.add(GetCountryList.fromJson(type));
      }
      print('countryList ${countryList.length}');
      setCountryList(countryList);
      notifyListeners();
      return true;
    } on Failure catch (f) {
      return f;
    }
  }
}
