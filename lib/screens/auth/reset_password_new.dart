import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:subrate/models/auth/reset_password_model.dart';
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

class ResetPasswordNew extends StatefulWidget {
  static const routeName = 'resetpassword-screen-new';
  const ResetPasswordNew({super.key});

  @override
  State<ResetPasswordNew> createState() => _ResetPasswordNewState();
}

class _ResetPasswordNewState extends State<ResetPasswordNew> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmationController =
      TextEditingController();
  bool _passwordVisible = false;
  bool _passwordVisibleConfirmation = false;
  final formKey = GlobalKey<FormState>();
  final Routers routers = Routers();
  bool passwordReseted = false;

  @override
  Widget build(BuildContext context) {
    final sizeh = MediaQuery.of(context).size.height;
    final sizew = MediaQuery.of(context).size.width;
    final authProvider = Provider.of<AuthProvider>(
      context,
    );
    final argumets =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: formKey,
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: sizew * 0.04, vertical: sizeh * 0.02),
          child: SingleChildScrollView(
            child: passwordReseted == true
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: sizeh * .08,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: SvgPicture.asset(backIcon,
                                  height: sizeh * .03)),
                          Row(
                            children: [
                              SvgPicture.asset(newYellowLogo,
                                  height: sizeh * .035),
                              SizedBox(
                                width: sizew * .03,
                              ),
                              Text(
                                'Subrate',
                                style: AppTextStyles.semiBold.copyWith(
                                    fontSize: 17.sp, color: textPrimaryColor),
                              )
                            ],
                          ),
                          SizedBox(
                            width: sizew * .02,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: sizeh * .06,
                      ),
                      Text(LocaleKeys.password_reset.tr(),
                          style: AppTextStyles.bold.copyWith(
                            fontSize: 24.sp,
                            color: textPrimaryColor,
                          )),
                      SizedBox(
                        height: sizeh * .01,
                      ),
                      Text(LocaleKeys.login_now_with_new.tr(),
                          style: AppTextStyles.regular.copyWith(
                            fontSize: 10.5.sp,
                            color: HexColor('#8F94A3'),
                          )),
                      SizedBox(
                        height: sizeh * .06,
                      ),
                      ButtonWidget(
                          height: sizeh * .055,
                          radius: 30,
                          buttonColor: HexColor('#F0FF85'),
                          text: LocaleKeys.back_login.tr(),
                          onPress: () {
                            routers.navigateToSigninNewScreen(context);
                          }),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: sizeh * .08,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: SvgPicture.asset(backIcon,
                                  height: sizeh * .03)),
                          Row(
                            children: [
                              SvgPicture.asset(newYellowLogo,
                                  height: sizeh * .035),
                              SizedBox(
                                width: sizew * .03,
                              ),
                              Text(
                                'Subrate',
                                style: AppTextStyles.semiBold.copyWith(
                                    fontSize: 17.sp, color: textPrimaryColor),
                              )
                            ],
                          ),
                          SizedBox(
                            width: sizew * .02,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: sizeh * .06,
                      ),
                      Text(LocaleKeys.create_new_password.tr(),
                          style: AppTextStyles.bold.copyWith(
                            fontSize: 24.sp,
                            color: textPrimaryColor,
                          )),
                      SizedBox(
                        height: sizeh * .01,
                      ),
                      Text(LocaleKeys.enter_and_confirm.tr(),
                          style: AppTextStyles.regular.copyWith(
                            fontSize: 10.5.sp,
                            color: HexColor('#8F94A3'),
                          )),
                      SizedBox(
                        height: sizeh * .02,
                      ),
                      NewCustomField(
                          validator: (p0) {
                            if (p0?.isEmpty == true) {
                              return LocaleKeys.enter_password.tr();
                            }
                            return null;
                          },
                          isPassword: true,
                          passwordCover: _passwordVisible,
                          rowWidget: Padding(
                            padding:
                                EdgeInsets.symmetric(horizontal: sizew * .02),
                            child: passwordController.text.isEmpty
                                ? SizedBox()
                                : Row(
                                    children: [
                                      InkWell(
                                          onTap: () {
                                            setState(() {
                                              _passwordVisible =
                                                  !_passwordVisible;
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
                              SvgPicture.asset(passwordIcon,
                                  height: sizeh * .027),
                            ],
                          ),
                          onChange: (value) {
                            setState(() {
                              passwordController.text = value;
                            });
                          },
                          hintText: LocaleKeys.enter_password.tr(),
                          errorText: LocaleKeys.password_error.tr(),
                          title: LocaleKeys.new_passowrd.tr(),
                          hintSize: 12.sp,
                          controller: passwordController),
                      SizedBox(
                        height: sizeh * .02,
                      ),
                      NewCustomField(
                          onChange: (value) {
                            setState(() {
                              passwordConfirmationController.text = value;
                            });
                          },
                          validator: (p0) {
                            if (p0?.isEmpty == true ||
                                p0 != passwordController.text) {
                              return LocaleKeys.password_mismatch.tr();
                            }
                            return null;
                          },
                          passwordCover: _passwordVisibleConfirmation,
                          rowWidget: Padding(
                            padding:
                                EdgeInsets.symmetric(horizontal: sizew * .02),
                            child: passwordConfirmationController.text.isEmpty
                                ? SizedBox()
                                : Row(
                                    children: [
                                      InkWell(
                                          onTap: () {
                                            setState(() {
                                              _passwordVisibleConfirmation =
                                                  !_passwordVisibleConfirmation;
                                            });
                                          },
                                          child: Icon(
                                            _passwordVisibleConfirmation
                                                ? Icons.visibility_outlined
                                                : Icons.visibility_off_outlined,
                                            size: sizeh * .025,
                                          )),
                                      SizedBox(width: sizew * .015),
                                      Text(
                                          _passwordVisibleConfirmation
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
                              SvgPicture.asset(passwordIcon,
                                  height: sizeh * .027),
                            ],
                          ),
                          hintText: LocaleKeys.re_enter_password.tr(),
                          errorText: LocaleKeys.password_error.tr(),
                          title: LocaleKeys.confirm_password.tr(),
                          hintSize: 12.sp,
                          controller: passwordConfirmationController),
                      SizedBox(
                        height: sizeh * .045,
                      ),
                      ButtonWidget(
                          height: sizeh * .055,
                          radius: 30,
                          buttonColor: HexColor('#F0FF85'),
                          text: LocaleKeys.reset_password.tr(),
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
                                  UIHelper.showNotification('Password Changed',
                                      backgroundColor: Colors.green);
                                  setState(() {
                                    passwordReseted = true;
                                  });
                                } else {}
                              });
                            }
                          }),
                      SizedBox(
                        height: sizeh * .025,
                      ),
                      // InkWell(
                      //   onTap: () {
                      //     Navigator.pop(context);
                      //   },
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     crossAxisAlignment: CrossAxisAlignment.center,
                      //     children: [
                      //       Icon(
                      //         Icons.arrow_back,
                      //         color: textPrimaryColor,
                      //         size: sizeh * .02,
                      //       ),
                      //       SizedBox(width: sizew * .02),
                      //       Text(
                      //         LocaleKeys.back_login.tr(),
                      //         style: AppTextStyles.semiBold
                      //             .copyWith(fontSize: 11.sp, color: textPrimaryColor),
                      //       )
                      //     ],
                      //   ),
                      // ),

                      SizedBox(height: sizeh * .045),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
