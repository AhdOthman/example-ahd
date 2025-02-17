import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:subrate/models/auth/signin_model_request.dart';
import 'package:subrate/provider/authprovider.dart';
import 'package:subrate/routers/routers.dart';
import 'package:subrate/theme/app_colors.dart';
import 'package:subrate/theme/assets_managet.dart';
import 'package:subrate/theme/text_style.dart';
import 'package:subrate/translations/locale_keys.g.dart';
import 'package:subrate/widgets/app/button.dart';
import 'package:subrate/widgets/app/loadingdialog.dart';
import 'package:subrate/widgets/app/textfield.dart';
import 'package:subrate/widgets/auth/social_button.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = 'login-screen';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final sizeh = MediaQuery.of(context).size.height;
    final sizew = MediaQuery.of(context).size.width;
    final Routers routers = Routers();
    final authProvider = Provider.of<AuthProvider>(
      context,
    );
    return Scaffold(
      backgroundColor: Color(0xFFE2E374),
      body: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(subrateLogo),
                SizedBox(width: sizew * .025),
                Text(
                  'Subrate',
                  style: AppTextStyles.bold
                      .copyWith(fontSize: 20.sp, color: primaryColor),
                ),
              ],
            ),
            SizedBox(height: sizeh * .04),
            ClipPath(
              clipper: _Triangle(),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(color: Colors.white),
                height: sizeh * .2,
                width: sizew,
                child: Padding(
                  padding: EdgeInsets.only(
                      top: sizeh * .05), // Adjust padding as needed
                  child: Center(
                    child: Text(
                      LocaleKeys.login.tr(),
                      style: AppTextStyles.bold
                          .copyWith(fontSize: 26.sp, color: primaryColor),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              height: sizeh * .52,
              padding: EdgeInsets.symmetric(horizontal: sizew * .09),
              decoration: BoxDecoration(color: Colors.white),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CustomField(
                    hintText: LocaleKeys.email.tr(),
                    title: LocaleKeys.email.tr(),
                    hintSize: 1,
                    controller: emailController,
                  ),
                  SizedBox(height: sizeh * .02),
                  CustomField(
                    isPassword: true,
                    passwordCover: true,
                    hintText: LocaleKeys.password.tr(),
                    title: LocaleKeys.password.tr(),
                    widget: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          LocaleKeys.forget.tr(),
                          style: AppTextStyles.semiBold
                              .copyWith(fontSize: 12.sp, color: primaryColor),
                        ),
                      ],
                    ),
                    hintSize: 1,
                    controller: passwordController,
                  ),
                  SizedBox(height: sizeh * .045),
                  ButtonWidget(
                    text: LocaleKeys.login.tr(),
                    onPress: () {
                      final isVaild = formKey.currentState!.validate();
                      if (isVaild) {
                        loadingDialog(context);
                        authProvider
                            .login(
                                loginRequestModel: SigninModelRequest(
                                    email: emailController.text,
                                    password: passwordController.text))
                            .then((value) {
                          Navigator.pop(context);
                          if (value) {
                            routers.navigateToBottomBarScreen(context);
                          }
                        });
                      }
                    },
                    textStyle: AppTextStyles.semiBold
                        .copyWith(fontSize: 12.5.sp, color: Colors.white),
                  ),
                  SizedBox(height: sizeh * .035),
                  Text(
                    LocaleKeys.or_continue.tr(),
                    style: AppTextStyles.regular
                        .copyWith(fontSize: 12.sp, color: Color(0xFF64748B)),
                  ),
                  SizedBox(height: sizeh * .015),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Platform.isIOS
                          ? InkWell(
                              onTap: () {
                                authProvider
                                    .handleSignInWithApple(context)
                                    .then((value) {
                                  // if (value == true) {
                                  //   routers.navigateToBottomBarScreen(context);
                                  // } else {
                                  //   Navigator.of(context).pop();
                                  // }
                                });
                              },
                              child: SocialButton(
                                  assetName: appleIcon, title: 'Apple'))
                          : InkWell(
                              onTap: () {
                                authProvider.handleSignInWithGoogle(context);
                              },
                              child: SocialButton(
                                  assetName: googleIcon, title: 'Google')),
                      //     SizedBox(width: sizew * .02),
                      //     SocialButton(assetName: facebookIcon, title: 'Facebook'),
                      SizedBox(width: sizew * .02),
                    ],
                  ),
                  SizedBox(height: sizeh * .025),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        LocaleKeys.dont_have.tr(),
                        style: AppTextStyles.regular.copyWith(
                            fontSize: 11.5.sp, color: Color(0xFF828282)),
                      ),
                      InkWell(
                        onTap: () {
                          routers.navigateToSignupScreen(context);
                        },
                        child: Text(LocaleKeys.create_one.tr(),
                            style: AppTextStyles.bold.copyWith(
                                fontSize: 11.5.sp, color: primaryColor)),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _Triangle extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(size.width / 2, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(size.width / 2, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
