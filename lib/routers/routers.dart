import 'package:flutter/material.dart';
import 'package:subrate/screens/auth/signup_screen.dart';
import 'package:subrate/screens/bottombar_screen.dart';
import 'package:subrate/screens/notifications/notifications_screen.dart';
import 'package:subrate/screens/onboarding/onboarding_screen.dart';
import 'package:subrate/screens/auth/login_screen.dart';
import 'package:subrate/screens/profile/change_password_screen.dart';
import 'package:subrate/screens/profile/kyc_verification_screen.dart';
import 'package:subrate/screens/profile/my_account_screen.dart';
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
  };
  void navigateToSigninScreen(BuildContext context,
      {Map<String, dynamic>? args}) {
    Navigator.of(context).pushNamedAndRemoveUntil(
        arguments: args, LoginScreen.routeName, (route) => false);
  }

  void navigateToSignupScreen(BuildContext context,
      {Map<String, dynamic>? args}) {
    Navigator.of(context).pushNamed(
      arguments: args,
      SignupScreen.routeName,
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

  void navigateToMyAccountScreenFromSignin(BuildContext context,
      {Map<String, dynamic>? args}) {
    Navigator.of(context).pushNamedAndRemoveUntil(
        arguments: args, MyAccountScreen.routeName, (route) => false);
  }
}
