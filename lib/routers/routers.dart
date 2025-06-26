import 'package:flutter/material.dart';
import 'package:subrate/screens/auth/forget_password_new.dart';
import 'package:subrate/screens/auth/forget_password_screen.dart';
import 'package:subrate/screens/auth/login_screen_new.dart';
import 'package:subrate/screens/auth/reset_password_new.dart';
import 'package:subrate/screens/auth/submit_code_new.dart';
import 'package:subrate/screens/auth/reset_password_screen.dart';
import 'package:subrate/screens/auth/signup_screen.dart';
import 'package:subrate/screens/auth/signup_screen_new.dart';
import 'package:subrate/screens/auth/submit_code_screen.dart';
import 'package:subrate/screens/auth/verify_account_new.dart';
import 'package:subrate/screens/auth/verify_account_screen.dart';
import 'package:subrate/screens/bottombar_screen.dart';
import 'package:subrate/screens/notifications/notifications_screen.dart';
import 'package:subrate/screens/onboarding/onboarding_screen.dart';
import 'package:subrate/screens/auth/login_screen.dart';
import 'package:subrate/screens/profile/change_password_screen.dart';
import 'package:subrate/screens/profile/kyc_verification_screen.dart';
import 'package:subrate/screens/profile/my_account_screen.dart';
import 'package:subrate/screens/wallet/add_new_account_screen.dart';
import 'package:subrate/screens/wallet/manage_accounts_screen.dart';
import 'package:subrate/screens/wallet/payment_methods_screen.dart';
import 'package:subrate/screens/profile/settings_screen.dart';
import 'package:subrate/screens/tasks/task_description.dart';
import 'package:subrate/screens/programs/tasks_byprogram_screen.dart';

class Routers {
  var routes = {
    OnBoardingScreen.routeName: (context) => const OnBoardingScreen(),
    LoginScreen.routeName: (context) => const LoginScreen(),
    SignupScreen.routeName: (context) => const SignupScreen(),
    TasksByProgramsDetailsScreen.routeName: (context) =>
        const TasksByProgramsDetailsScreen(),
    TaskDescriptionScreen.routeName: (context) => const TaskDescriptionScreen(),
    MyAccountScreen.routeName: (context) => const MyAccountScreen(),
    KycVerificationScreen.routeName: (context) => const KycVerificationScreen(),
    SettingsScreen.routeName: (context) => const SettingsScreen(),
    ChangePasswordScreen.routeName: (context) => const ChangePasswordScreen(),
    PaymentMethodsScreen.routeName: (context) => const PaymentMethodsScreen(),
    NotificationsScreen.routeName: (context) => const NotificationsScreen(),
    BottomBarScreen.routeName: (context) => const BottomBarScreen(),
    ForgetPasswordScreen.routeName: (context) => const ForgetPasswordScreen(),
    SubmitCodeScreen.routeName: (context) => const SubmitCodeScreen(),
    ResetPasswordScreen.routeName: (context) => const ResetPasswordScreen(),
    VerifyAccountScreen.routeName: (context) => const VerifyAccountScreen(),
    ManageAccountsScreen.routeName: (context) => const ManageAccountsScreen(),
    AddNewAccountScreen.routeName: (context) => const AddNewAccountScreen(),
    LoginScreenNew.routeName: (context) => const LoginScreenNew(),
    SignupScreenNew.routeName: (context) => const SignupScreenNew(),
    ForgetPasswordNew.routeName: (context) => const ForgetPasswordNew(),
    SubmitCodeNew.routeName: (context) => const SubmitCodeNew(),
    ResetPasswordNew.routeName: (context) => const ResetPasswordNew(),
    VerifyAccountNew.routeName: (context) => const VerifyAccountNew(),
  };

  void navigateToSigninScreen(BuildContext context,
      {Map<String, dynamic>? args}) {
    Navigator.of(context).pushNamedAndRemoveUntil(
        arguments: args, LoginScreen.routeName, (route) => false);
  }

  void navigateToSigninNewScreen(BuildContext context,
      {Map<String, dynamic>? args}) {
    Navigator.of(context).pushNamedAndRemoveUntil(
        arguments: args, LoginScreenNew.routeName, (route) => false);
  }

  void navigateToSignupNewScreen(BuildContext context,
      {Map<String, dynamic>? args}) {
    Navigator.of(context).pushNamed(
      arguments: args,
      SignupScreenNew.routeName,
    );
  }

  void navigateToForgetPasswordNewScreen(BuildContext context,
      {Map<String, dynamic>? args}) {
    Navigator.of(context).pushNamed(
      arguments: args,
      ForgetPasswordNew.routeName,
    );
  }

  void navigateToSubmitCodeNewScreen(BuildContext context,
      {Map<String, dynamic>? args}) {
    Navigator.of(context).pushNamed(
      arguments: args,
      SubmitCodeNew.routeName,
    );
  }

  void navigateToResetPasswordNewScreen(BuildContext context,
      {Map<String, dynamic>? args}) {
    Navigator.of(context).pushNamed(
      arguments: args,
      ResetPasswordNew.routeName,
    );
  }

  void navigateToVerifyAccountNewScreen(BuildContext context,
      {Map<String, dynamic>? args}) {
    Navigator.of(context).pushNamedAndRemoveUntil(
        arguments: args, VerifyAccountNew.routeName, (route) => false);
  }

  void navigateToVerifyAccountScreen(BuildContext context,
      {Map<String, dynamic>? args}) {
    Navigator.of(context).pushNamedAndRemoveUntil(
        arguments: args, VerifyAccountScreen.routeName, (route) => false);
  }

  void navigateToSignupScreen(BuildContext context,
      {Map<String, dynamic>? args}) {
    Navigator.of(context).pushNamed(
      arguments: args,
      SignupScreen.routeName,
    );
  }

  void navigateToForgetPasswordScreen(BuildContext context,
      {Map<String, dynamic>? args}) {
    Navigator.of(context).pushNamed(
      arguments: args,
      ForgetPasswordScreen.routeName,
    );
  }

  void navigateToSubmitCodeScreen(BuildContext context,
      {Map<String, dynamic>? args}) {
    Navigator.of(context).pushNamed(
      arguments: args,
      SubmitCodeScreen.routeName,
    );
  }

  void navigateToResetPasswordScreen(BuildContext context,
      {Map<String, dynamic>? args}) {
    Navigator.of(context).pushNamed(
      arguments: args,
      ResetPasswordScreen.routeName,
    );
  }

  void navigateToTasksByProgramsScreen(BuildContext context,
      {Map<String, dynamic>? args}) {
    Navigator.of(context).pushNamed(
      arguments: args,
      TasksByProgramsDetailsScreen.routeName,
    );
  }

  void navigateToTasksDescriptionScreen(BuildContext context,
      {Map<String, dynamic>? args}) {
    Navigator.of(context).pushNamed(
      arguments: args,
      TaskDescriptionScreen.routeName,
    );
  }

  void navigateToMyAccountScreen(BuildContext context,
      {Map<String, dynamic>? args}) {
    Navigator.of(context).pushNamed(
      arguments: args,
      MyAccountScreen.routeName,
    );
  }

  void navigateToKycVerificationScreen(BuildContext context,
      {Map<String, dynamic>? args}) {
    Navigator.of(context).pushNamed(
      arguments: args,
      KycVerificationScreen.routeName,
    );
  }

  void navigateToSettingsScreen(BuildContext context,
      {Map<String, dynamic>? args}) {
    Navigator.of(context).pushNamed(
      arguments: args,
      SettingsScreen.routeName,
    );
  }

  void navigateToChangePasswordScreen(BuildContext context,
      {Map<String, dynamic>? args}) {
    Navigator.of(context).pushNamed(
      arguments: args,
      ChangePasswordScreen.routeName,
    );
  }

  void navigateToPaymentMethodsScreen(BuildContext context,
      {Map<String, dynamic>? args}) {
    Navigator.of(context).pushNamed(
      arguments: args,
      PaymentMethodsScreen.routeName,
    );
  }

  void navigateToNotificationsScreen(BuildContext context,
      {Map<String, dynamic>? args}) {
    Navigator.of(context).pushNamed(
      arguments: args,
      NotificationsScreen.routeName,
    );
  }

  void navigateToBottomBarScreen(BuildContext context,
      {Map<String, dynamic>? args}) {
    Navigator.of(context).pushNamedAndRemoveUntil(
        arguments: args, BottomBarScreen.routeName, (route) => false);
  }

  void navigateToOnboardingScreenScreen(BuildContext context,
      {Map<String, dynamic>? args}) {
    Navigator.of(context).pushNamedAndRemoveUntil(
        arguments: args, OnBoardingScreen.routeName, (route) => false);
  }

  void navigateToMyAccountScreenFromSignin(BuildContext context,
      {Map<String, dynamic>? args}) {
    Navigator.of(context).pushNamedAndRemoveUntil(
        arguments: args, MyAccountScreen.routeName, (route) => false);
  }

  void navigateToManageAccountsScreen(BuildContext context,
      {Map<String, dynamic>? args}) {
    Navigator.of(context).pushNamed(
      arguments: args,
      ManageAccountsScreen.routeName,
    );
  }

  void navigateToAddNewAccountScreen(BuildContext context,
      {Map<String, dynamic>? args}) {
    Navigator.of(context).pushNamed(
      arguments: args,
      AddNewAccountScreen.routeName,
    );
  }
}
