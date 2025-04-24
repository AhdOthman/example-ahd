import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:subrate/models/auth/reset_password_model.dart';
import 'package:subrate/provider/authprovider.dart';
import 'package:subrate/routers/routers.dart';
import 'package:subrate/theme/app_colors.dart';
import 'package:subrate/theme/assets_managet.dart';
import 'package:subrate/theme/text_style.dart';
import 'package:subrate/theme/ui_helper.dart';
import 'package:subrate/translations/locale_keys.g.dart';
import 'package:subrate/widgets/app/button.dart';
import 'package:subrate/widgets/app/loadingdialog.dart';
import 'package:subrate/widgets/app/textfield.dart';

class ResetPasswordScreen extends StatefulWidget {
  static const routeName = 'reset-password-screen';
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final formKey = GlobalKey<FormState>();

  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmController = TextEditingController();

  bool obscurePassword = true;
  bool obscureConfirm = true;
  bool passwordReseted = false;
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final argumets =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final Routers routers = Routers();
    final sizeh = MediaQuery.of(context).size.height;
    final sizew = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color(0xFFE2E374),
      body: Form(
        key: formKey,
        child: passwordReseted == true
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(subrateLogo),
                        SizedBox(
                          width: sizew * .025,
                        ),
                        Text(
                          'Subrate',
                          style: AppTextStyles.bold
                              .copyWith(fontSize: 20.sp, color: primaryColor),
                        )
                      ],
                    ),
                    SizedBox(
                      height: sizeh * .04,
                    ),
                    ClipPath(
                      clipper: _Triangle(),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(color: Colors.white),
                        height: sizeh * .24,
                        width: sizew,
                        child: Padding(
                          padding: EdgeInsets.only(top: sizeh * .16),
                          child: Center(
                              child: Column(
                            children: [
                              Text(
                                LocaleKeys.password_reset_sucss.tr(),
                                textAlign: TextAlign.center,
                                style: AppTextStyles.bold.copyWith(
                                    fontSize: 16.sp, color: primaryColor),
                              ),
                              Text(
                                LocaleKeys.reset_su.tr(),
                                textAlign: TextAlign.center,
                                style: AppTextStyles.bold.copyWith(
                                    fontSize: 16.sp, color: primaryColor),
                              ),
                            ],
                          )),
                        ),
                      ),
                    ),
                    Container(
                        padding: EdgeInsets.symmetric(horizontal: sizew * .09),
                        alignment: Alignment.bottomLeft,
                        decoration: BoxDecoration(color: Colors.white),
                        height: sizeh * .45,
                        width: sizew,
                        child: SingleChildScrollView(
                            child: Column(
                          children: [
                            ButtonWidget(
                              text: LocaleKeys.login_now.tr(),
                              onPress: () {
                                routers.navigateToSigninScreen(context);
                              },
                              textStyle: AppTextStyles.semiBold.copyWith(
                                  fontSize: 12.5.sp, color: Colors.white),
                            ),
                            SizedBox(
                              height: sizeh * .22,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  LocaleKeys.dont_have.tr(),
                                  style: AppTextStyles.regular.copyWith(
                                      fontSize: 11.5.sp,
                                      color: Color(0xFF828282)),
                                ),
                                InkWell(
                                  onTap: () {
                                    routers.navigateToSignupScreen(context);
                                  },
                                  child: Text(LocaleKeys.create_one.tr(),
                                      style: AppTextStyles.bold.copyWith(
                                          fontSize: 11.5.sp,
                                          color: primaryColor)),
                                )
                              ],
                            ),
                            SizedBox(
                              height: sizeh * .035,
                            ),
                          ],
                        )))
                  ])
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(subrateLogo),
                      SizedBox(
                        width: sizew * .025,
                      ),
                      Text(
                        'Subrate',
                        style: AppTextStyles.bold
                            .copyWith(fontSize: 20.sp, color: primaryColor),
                      )
                    ],
                  ),
                  SizedBox(
                    height: sizeh * .03,
                  ),
                  ClipPath(
                    clipper: _Triangle(),
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(color: Colors.white),
                      height: sizeh * .2,
                      width: sizew,
                      child: Padding(
                        padding: EdgeInsets.only(top: sizeh * .1),
                        child: Center(
                            child: Text(
                          LocaleKeys.set_new_password.tr(),
                          style: AppTextStyles.bold
                              .copyWith(fontSize: 18.sp, color: primaryColor),
                        )),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: sizew * .09),
                    alignment: Alignment.bottomLeft,
                    decoration: BoxDecoration(color: Colors.white),
                    height: sizeh * .45,
                    width: sizew,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          CustomField(
                            passwordCover: obscurePassword,
                            isPassword: true,
                            errorText: 'Please enter your password',
                            hintText: LocaleKeys.password.tr(),
                            title: LocaleKeys.password.tr(),
                            hintSize: 1,
                            controller: passwordController,
                            widget: IconButton(
                              icon: Icon(
                                obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(() {
                                  obscurePassword = !obscurePassword;
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            height: sizeh * .015,
                          ),
                          CustomField(
                            passwordCover: obscureConfirm,
                            isPassword: true,
                            errorText: 'Please enter your password',
                            hintText: LocaleKeys.password.tr(),
                            title: LocaleKeys.password.tr(),
                            hintSize: 1,
                            controller: passwordConfirmController,
                            widget: IconButton(
                              icon: Icon(
                                obscureConfirm
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(() {
                                  obscureConfirm = !obscureConfirm;
                                });
                              },
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please confirm your password';
                              }
                              if (value != passwordController.text) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: sizeh * .025,
                          ),
                          ButtonWidget(
                            text: LocaleKeys.submit.tr(),
                            onPress: () {
                              final isVaild = formKey.currentState!.validate();
                              if (isVaild) {
                                // routers.navigateToSubmitCodeScreen(context,
                                //     args: {'email': emailController.text});
                                loadingDialog(context);
                                authProvider
                                    .reasetPassword(ResetPasswordModel(
                                        email: argumets['email'],
                                        code: argumets['code'],
                                        newPassword: passwordController.text))
                                    .then((value) {
                                  Navigator.pop(context);
                                  if (value == true) {
                                    UIHelper.showNotification(
                                        'Password Changed',
                                        backgroundColor: Colors.green);
                                    setState(() {
                                      passwordReseted = true;
                                    });
                                  } else {}
                                });
                              }
                            },
                            textStyle: AppTextStyles.semiBold.copyWith(
                                fontSize: 12.5.sp, color: Colors.white),
                          ),
                          SizedBox(
                            height: sizeh * .22,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                LocaleKeys.dont_have.tr(),
                                style: AppTextStyles.regular.copyWith(
                                    fontSize: 11.5.sp,
                                    color: Color(0xFF828282)),
                              ),
                              InkWell(
                                onTap: () {
                                  routers.navigateToSignupScreen(context);
                                },
                                child: Text(LocaleKeys.create_one.tr(),
                                    style: AppTextStyles.bold.copyWith(
                                        fontSize: 11.5.sp,
                                        color: primaryColor)),
                              )
                            ],
                          ),
                          SizedBox(
                            height: sizeh * .035,
                          ),
                        ],
                      ),
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
