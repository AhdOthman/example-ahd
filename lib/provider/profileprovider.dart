import 'package:flutter/material.dart';
import 'package:subrate/models/profile/edit_profile_model.dart';
import 'package:subrate/models/profile/profile_model.dart';
import 'package:subrate/models/profile/send_kyc_request_model.dart';
import 'package:subrate/services/api/profile/edit_profile_api.dart';
import 'package:subrate/services/api/profile/get_profile_api.dart';
import 'package:subrate/services/api/profile/send_kyc_api.dart';
import 'package:subrate/services/api/profile/upload_photo_api.dart';
import 'package:subrate/theme/failure.dart';

class Profileprovider with ChangeNotifier {
  ProfileModel? profileModel;
  Future getProfileData() async {
    try {
      final response = await GetProfileApi().fetch();
      print(response);
      profileModel = ProfileModel.fromJson(response['result']);

      notifyListeners();
      return true;
    } on Failure catch (f) {
      return f;
    }
  }

  Future editProfile({required EditProfileModel editProfileModel}) async {
    try {
      var response =
          await EditProfileApi(editProfileModel: editProfileModel).fetch();
      print(response);
      return true;
    } on Failure {
      return false;
    }
  }

  Future editProfilePicture({required String picturePath}) async {
    try {
      var response =
          await EditProfilePictureApi(photoLink: picturePath).fetch();
      print(response);
      return true;
    } on Failure {
      return false;
    }
  }

  Future sendKyc({required KYCRequestModel kycRequestModel}) async {
    try {
      var response = await SendKycApi(kycRequestModel: kycRequestModel).fetch();
      print(response);
      return true;
    } on Failure {
      return false;
    }
  }
}
