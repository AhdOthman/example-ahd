import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:subrate/models/auth/signin_model_request.dart';
import 'package:subrate/routers/routers.dart';
import 'package:subrate/theme/app_colors.dart';
import 'package:subrate/theme/assets_managet.dart';
import 'package:subrate/theme/text_style.dart';
import 'package:subrate/theme/ui_helper.dart';
import 'package:subrate/translations/locale_keys.g.dart';
import 'package:subrate/widgets/app/button.dart';
import 'package:subrate/widgets/app/loadingdialog.dart';
import 'package:subrate/widgets/app/new_text_field.dart';

import '../../provider/authprovider.dart';

class LoginScreenNew extends StatefulWidget {
  static const routeName = 'login-screen-new';
  const LoginScreenNew({super.key});

  @override
  State<LoginScreenNew> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreenNew> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    final Routers routers = Routers();
    final sizeh = MediaQuery.of(context).size.height;
    final sizew = MediaQuery.of(context).size.width;
    final authProvider = Provider.of<AuthProvider>(
      context,
    );
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: formKey,
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: sizew * 0.04, vertical: sizeh * 0.02),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: sizeh * .08,
                ),
                SvgPicture.asset(newYellowLogo, height: sizeh * .065),
                SizedBox(
                  height: sizeh * .02,
                ),
                Text(LocaleKeys.welcome_back.tr(),
                    style: AppTextStyles.bold.copyWith(
                      fontSize: 24.sp,
                      color: textPrimaryColor,
                    )),
                SizedBox(
                  height: sizeh * .01,
                ),
                Text(LocaleKeys.log_in_to_continue.tr(),
                    style: AppTextStyles.regular.copyWith(
                      fontSize: 11.sp,
                      color: HexColor('#8F94A3'),
                    )),
                SizedBox(
                  height: sizeh * .02,
                ),
                NewCustomField(
                    prefixIcon: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(personIcon, height: sizeh * .027),
                      ],
                    ),
                    hintText: LocaleKeys.email_phase.tr(),
                    errorText: LocaleKeys.enter_email.tr(),
                    title: LocaleKeys.email_address.tr(),
                    hintSize: 12.sp,
                    controller: emailController),
                SizedBox(
                  height: sizeh * .02,
                ),
                NewCustomField(
                    isPassword: true,
                    passwordCover: _passwordVisible,
                    rowWidget: Padding(
                      padding: EdgeInsets.symmetric(horizontal: sizew * .02),
                      child: passwordController.text.isEmpty
                          ? SizedBox()
                          : Row(
                              children: [
                                InkWell(
                                    onTap: () {
                                      setState(() {
                                        _passwordVisible = !_passwordVisible;
                                      });
                                    },
                                    child: Icon(
                                      _passwordVisible
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined,
                                      size: sizeh * .025,
                                    )),
                                SizedBox(width: sizew * .015),
                                Text(
                                    _passwordVisible
                                        ? LocaleKeys.show.tr()
                                        : LocaleKeys.hide.tr(),
                                    style: AppTextStyles.regular.copyWith(
                                        fontSize: 11.sp,
                                        color: textPrimaryColor)),
                              ],
                            ),
                    ),
                    prefixIcon: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(passwordIcon, height: sizeh * .027),
                      ],
                    ),
                    onChange: (value) {
                      setState(() {
                        passwordController.text = value;
                      });
                    },
                    hintText: LocaleKeys.enter_password.tr(),
                    errorText: LocaleKeys.password_error.tr(),
                    title: LocaleKeys.password.tr(),
                    hintSize: 12.sp,
                    controller: passwordController),
                SizedBox(
                  height: sizeh * .005,
                ),
                InkWell(
                  onTap: () {
                    routers.navigateToForgetPasswordNewScreen(context);
                  },
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text('${LocaleKeys.forget_password.tr()}?',
                        style: AppTextStyles.regular.copyWith(
                            fontSize: 10.sp, color: textPrimaryColor)),
                  ),
                ),
                SizedBox(
                  height: sizeh * .035,
                ),
                ButtonWidget(
                    height: sizeh * .055,
                    radius: 30,
                    buttonColor: HexColor('#F0FF85'),
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
                            authProvider.loginRespons?.user?.role != 'USER'
                                ? UIHelper.showNotification(
                                    'This app just for trainee, you can not login as a user',
                                  )
                                : routers.navigateToBottomBarScreen(context);
                          } else {
                            Navigator.pop(context);
                          }
                        });
                      }
                    }),
                SizedBox(
                  height: sizeh * .035,
                ),
                Row(
                  children: [
                    SizedBox(
                        width: sizew * .28,
                        child: Divider(
                          color: HexColor('#E9EAED'),
                        )),
                    SizedBox(width: sizew * .033),
                    Text(LocaleKeys.or_continue.tr(),
                        style: AppTextStyles.semiBold.copyWith(
                            fontSize: 11.sp, color: textPrimaryColor)),
                    SizedBox(width: sizew * .033),
                    SizedBox(
                        width: sizew * .28,
                        child: Divider(color: HexColor('#E9EAED')))
                  ],
                ),
                SizedBox(
                  height: sizeh * .03,
                ),
                ButtonWidget(
                  borderColor: HexColor('#959AB7'),
                  borderWidth: 1,
                  height: sizeh * .055,
                  radius: 30,
                  buttonColor: HexColor('#F5FBFF'),
                  text: 'Facebook',
                  onPress: () {},
                  widget: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(facebookIcon, height: sizeh * .025),
                      SizedBox(width: sizew * .02),
                      Text('Facebook',
                          style: AppTextStyles.semiBold.copyWith(
                              fontSize: 12.sp, color: textPrimaryColor)),
                    ],
                  ),
                ),
                SizedBox(
                  height: sizeh * .02,
                ),
                ButtonWidget(
                  borderColor: HexColor('#959AB7'),
                  borderWidth: 1,
                  height: sizeh * .055,
                  radius: 30,
                  buttonColor: HexColor('#F5FBFF'),
                  text: 'Facebook',
                  onPress: () {
                    authProvider.handleSignInWithGoogle(context);
                  },
                  widget: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(googleIcon, height: sizeh * .025),
                      SizedBox(width: sizew * .02),
                      Text('Google',
                          style: AppTextStyles.semiBold.copyWith(
                              fontSize: 12.sp, color: textPrimaryColor)),
                    ],
                  ),
                ),
                SizedBox(
                  height: sizeh * .02,
                ),
                ButtonWidget(
                  borderColor: HexColor('#959AB7'),
                  borderWidth: 1,
                  height: sizeh * .055,
                  radius: 30,
                  buttonColor: HexColor('#F5FBFF'),
                  text: 'Apple',
                  onPress: () {
                    authProvider.handleSignInWithApple(context).then((value) {
                      // if (value == true) {
                      //   routers.navigateToBottomBarScreen(context);
                      // } else {
                      //   Navigator.of(context).pop();
                      // }
                    });
                  },
                  widget: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(appleIcon, height: sizeh * .025),
                      SizedBox(width: sizew * .02),
                      Text('Apple',
                          style: AppTextStyles.semiBold.copyWith(
                              fontSize: 12.sp, color: textPrimaryColor)),
                    ],
                  ),
                ),
                SizedBox(height: sizeh * .025),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      LocaleKeys.dont_have.tr(),
                      style: AppTextStyles.regular
                          .copyWith(fontSize: 11.5.sp, color: textPrimaryColor),
                    ),
                    SizedBox(width: sizew * .01),
                    InkWell(
                      onTap: () {
                        routers.navigateToSignupNewScreen(context);
                      },
                      child: Text(LocaleKeys.signup.tr(),
                          style: AppTextStyles.semiBold.copyWith(
                              fontSize: 11.5.sp, color: textPrimaryColor)),
                    )
                  ],
                ),
                SizedBox(height: sizeh * .045),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
