import 'package:flutter/material.dart';
import 'package:subrate/models/wallet/dynamic_form_model.dart';
import 'package:subrate/models/wallet/dynamic_payment_request.dart';
import 'package:subrate/models/wallet/payout_history_model.dart';
import 'package:subrate/models/wallet/payout_mdethod_model.dart';
import 'package:subrate/models/wallet/trainee_pmethods_model.dart';
import 'package:subrate/services/api/wallet/add_payment_method_api.dart';
import 'package:subrate/services/api/wallet/create_payout_api.dart';
import 'package:subrate/services/api/wallet/get_payout_details_api.dart';
import 'package:subrate/services/api/wallet/get_payout_history_api.dart';
import 'package:subrate/services/api/wallet/get_payout_method_api.dart';
import 'package:subrate/services/api/wallet/get_trainee_pmethods_api.dart';
import 'package:subrate/services/api/wallet/get_wallet_api.dart';
import 'package:subrate/theme/failure.dart';

class WalletProvider with ChangeNotifier {
  num totalPoints = 0;
  num totalMoney = 0;
  Future getWallet() async {
    try {
      var response = await GetWalletApi().fetch();
      totalMoney = response['result']['totalMoney'];
      totalPoints = response['result']['totalPoints'];
      print(response);
      notifyListeners();
      return true;
    } on Failure {
      return false;
    }
  }

  List<PayoutMethodModel> payoutMethodList = [];
  List<PayoutMethodModel>? get getPayoutMethodList => payoutMethodList;
  setPayoutMethodList(List<PayoutMethodModel> value) {
    payoutMethodList = value;
    notifyListeners();
  }

  Future getPayoutMethod() async {
    payoutMethodList.clear();
    try {
      final response = await GetPayoutMethodApi().fetch();
      for (var type in response['result']) {
        payoutMethodList.add(PayoutMethodModel.fromJson(type));
      }
      print('payoutMethodList ${payoutMethodList.length}');
      setPayoutMethodList(payoutMethodList);
      notifyListeners();
      return true;
    } on Failure catch (f) {
      return f;
    }
  }

  List<DynamicFormModel> paymentDetailsList = [];
  List<DynamicFormModel>? get getDynamicFormList => paymentDetailsList;
  setDynamicFormList(List<DynamicFormModel> value) {
    paymentDetailsList = value;
    notifyListeners();
  }

  Future getPayoutMethodDetails({required String payoutMethodId}) async {
    paymentDetailsList.clear();
    try {
      var response =
          await GetPayoutMethodDetailsApi(payoutMethodId: payoutMethodId)
              .fetch();
      for (var type in response['result']) {
        paymentDetailsList.add(DynamicFormModel.fromJson(type));
      }
      print(response);

      print('paymentdetails ${paymentDetailsList.length}');
      setDynamicFormList(paymentDetailsList);
      notifyListeners();
      return true;
    } on Failure {
      return false;
    }
  }

  Future addPaymentMethod(
      {required PaymentDetailsRequest paymentDetailsRequest}) async {
    try {
      var response = await AddPaymentMethodApi(
              paymentDetailsRequest: paymentDetailsRequest)
          .fetch();

      print(response);
      return true;
    } on Failure {
      return false;
    }
  }

  List<TraineePaymentMethodModel> traineePaymentMethodList = [];
  List<TraineePaymentMethodModel>? get getTraineePaymentMethodList =>
      traineePaymentMethodList;
  setTraineePaymentMethodList(List<TraineePaymentMethodModel> value) {
    traineePaymentMethodList = value;
    notifyListeners();
  }

  Future getTraineePaymentMethod() async {
    traineePaymentMethodList.clear();
    try {
      final response = await GetTraineePmethodsApi().fetch();
      for (var type in response['result']) {
        traineePaymentMethodList.add(TraineePaymentMethodModel.fromJson(type));
      }
      print('traineePaymentMethodList ${traineePaymentMethodList.length}');
      setTraineePaymentMethodList(traineePaymentMethodList);
      notifyListeners();
      return true;
    } on Failure catch (f) {
      return f;
    }
  }

  List<PayoutHistoryModel> payoutHistoryList = [];
  List<PayoutHistoryModel>? get getPayoutHistoryList => payoutHistoryList;
  setPayoutHistoryList(List<PayoutHistoryModel> value) {
    payoutHistoryList = value;
    notifyListeners();
  }

  Future getPayoutHistory() async {
    payoutHistoryList.clear();
    try {
      final response = await GetPayoutHistoryApi().fetch();
      for (var type in response['result']) {
        payoutHistoryList.add(PayoutHistoryModel.fromJson(type));
      }
      print('payoutHistoryList ${payoutHistoryList.length}');
      setPayoutHistoryList(payoutHistoryList);
      notifyListeners();
      return true;
    } on Failure catch (f) {
      return f;
    }
  }

  Future createPayoutRequest({required String payoutMethodId}) async {
    try {
      var response =
          await CreatePayoutApi(payoutMethodId: payoutMethodId).fetch();

      print(response);
      notifyListeners();
      return true;
    } on Failure {
      return false;
    }
  }
}
