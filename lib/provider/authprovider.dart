import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:subrate/api_url.dart';
import 'package:subrate/models/auth/reset_password_model.dart';
import 'package:subrate/models/auth/signin_model_request.dart';
import 'package:subrate/models/auth/signup_model_request.dart';
import 'package:subrate/models/auth/social_login_response_model.dart';
import 'package:subrate/models/auth/update_password_model.dart';
import 'package:subrate/models/auth/verify_account_model.dart';
import 'package:subrate/provider/appprovider.dart';
import 'package:subrate/routers/routers.dart';
import 'package:subrate/services/api/auth/delete_my_account_api.dart';
import 'package:subrate/services/api/auth/request_code_for_pass_api.dart';
import 'package:subrate/services/api/auth/resend_verify_otp_api.dart';
import 'package:subrate/services/api/auth/signin_api.dart';
import 'package:subrate/services/api/auth/signin_with_apple_api.dart';
import 'package:subrate/services/api/auth/signup_api.dart';
import 'package:subrate/services/api/auth/submit_code_for_reset_api.dart';
import 'package:subrate/services/api/auth/update_password_api.dart';
import 'package:subrate/services/api/auth/verify_account_api.dart';
import 'package:subrate/theme/failure.dart';
import 'package:subrate/theme/ui_helper.dart';
import 'package:subrate/widgets/app/loadingdialog.dart';

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

  LoginResponseModel? loginRespons;
  Future login({
    required SigninModelRequest loginRequestModel,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    try {
      var response =
          await SigninApi(signinModelRequest: loginRequestModel).fetch();
      if (response['statusCode'] == 200) {
        print('objssssect');
        loginRespons = LoginResponseModel.fromJson(response['result']);

        token = loginRespons?.token;
        userName = loginRespons?.user?.username ?? '';
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

    if (!prefs.containsKey('userData')) {
      debugPrint("no data");
      return false;
    }

    debugPrint(" data ex");

    final extractData = json.decode(prefs.getString('userData').toString())
        as Map<String, dynamic>;

    token = extractData['token'];

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
    notifyListeners();

    return true;
  }

  void signOutGoogle() async {
    await _googleSignIn.signOut();
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
    signOutGoogle();
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

  Future deleteAccount() async {
    try {
      var response = await DeleteMyAccountApi().fetch();
      print(response);
      return true;
    } on Failure {
      return false;
    }
  }

  Future requestCodeForResetPass(String email) async {
    try {
      var response = await RequestCodeForPassApi(email: email).fetch();
      print(response);
      return true;
    } on Failure {
      return false;
    }
  }

  Future reasetPassword(ResetPasswordModel resetPasswordModel) async {
    try {
      var response =
          await SubmitCodeForResetApi(resetPasswordModel: resetPasswordModel)
              .fetch();
      print(response);
      return true;
    } on Failure {
      return false;
    }
  }

  Future resendVerifyOtp(String email) async {
    print('request Sent resendVerifyOtp');

    try {
      var response = await ResendVerifyOtpApi(email: email).fetch();
      print(response);
      return true;
    } on Failure {
      return false;
    }
  }

  Future verifyAccount(VerifyAccountModel verifyAccountModel) async {
    try {
      var response =
          await VerifyAccountApi(verifyAccountModel: verifyAccountModel)
              .fetch();
      print(response);
      return true;
    } on Failure {
      return false;
    }
  }

  SocialLoginResponseModel? socialLoginResponse;

  Future<bool> handleSignInWithApple(BuildContext context) async {
    final Routers routers = Routers();
    final prefs = await SharedPreferences.getInstance();

    try {
      // Trigger the sign-in flow
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        webAuthenticationOptions: WebAuthenticationOptions(
          clientId: 'com.projecxio.subrate',
          redirectUri: Uri.parse('$baseUrl/auth/apple/callback'),
        ),
      );

      loadingDialog(context);

      var response = await SigninWithSocialApi(
              type: SocialType.apple,
              socialToken: appleCredential.authorizationCode)
          .fetch();
      print(response);
      print(appleCredential.authorizationCode);
      Clipboard.setData(ClipboardData(text: appleCredential.authorizationCode));

      socialLoginResponse =
          SocialLoginResponseModel.fromJson(response['result']);

      String? token = socialLoginResponse?.token;

      final userData = json.encode({
        'token': token,
      });

      if (token != null) {
        routers.navigateToBottomBarScreen(context);
        prefs.setString('userData', userData);
      } else {
        Navigator.of(context).pop();
      }

      return true;
    } catch (error) {
      print("Error: $error");
      Navigator.of(context).pop();

      return false;
    }
  }

  final GoogleSignIn _googleSignIn = GoogleSignIn(

      //  Specify the options to prompt for account selection
      scopes: ['email', 'profile', 'openid'],
      serverClientId:
          '519738265080-g51dc8uilkrthbi8j4n05k17r9ne221b.apps.googleusercontent.com');

  Future<bool> handleSignInWithGoogle(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();

    final Routers routers = Routers();
    try {
      loadingDialog(context);

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        var response = await SigninWithSocialApi(
                type: SocialType.google, socialToken: googleAuth.idToken ?? '')
            .fetch();
        print(response);
        socialLoginResponse =
            SocialLoginResponseModel.fromJson(response['result']);
        print(response);
        token = socialLoginResponse?.token;
        userName = '${socialLoginResponse?.user?.username}';
        print(token);
        final userData = json.encode({
          'token': token,
        });
        prefs.setString('userData', userData);
        token != null ? routers.navigateToBottomBarScreen(context) : null;
        print('userData ${prefs.getString('userData')}');
        return true;
      } else {
        print("Google sign-in was cancelled.");
        return false;
      }
    } catch (error) {
      print("Error during Google Sign-In: $error");
      Navigator.of(context).pop();
      // Optionally show an alert dialog here
      return false;
    }
  }

//   Future<bool> handleSignInWithGoogle(BuildContext context) async {
//     final Routers routers = Routers();
//     final prefs = await SharedPreferences.getInstance();

//     try {
//       final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

//       if (googleUser != null) {
//         loadingDialog(context);

//         final GoogleSignInAuthentication googleAuth =
//             await googleUser.authentication;
//         print('googleAuth ${googleAuth.accessToken}');
//         print(googleAuth.idToken);
//         final AuthCredential credential = GoogleAuthProvider.credential(
//           accessToken: googleAuth.accessToken,
//           idToken: googleAuth.idToken,
//         );
//         final UserCredential userCrefdential =
//             await _auth.signInWithCredential(credential);
//         String? userIdToken = await userCrefdential.user?.getIdToken();
//         var response =
//             await SocialLoginApi(loginType: 'google', uID: userIdToken ?? '')
//                 .fetch();
//         socialLoginResponse = SocialLoginResponse.fromJson(response['data']);
//         print(response);
//         token = socialLoginResponse?.apiToken;
//         userName = '${socialLoginResponse?.fullName}';
//         print(token);
//         final userData = json.encode({
//           'token': token,
//         });
//         prefs.setString('userData', userData);
//         token != null ? routers.navigateToBottomBarScreen(context) : null;
//       }
//       return true;
//     } catch (error) {
//       print("Error: $error");
//       Navigator.of(context).pop();

//       return false;
//     }
//   }
// }
}
