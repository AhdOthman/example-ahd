import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:subrate/routers/routers.dart';
import 'package:subrate/theme/app_colors.dart';
import 'package:subrate/theme/assets_managet.dart';
import 'package:subrate/theme/text_style.dart';
import 'package:subrate/translations/locale_keys.g.dart';
import 'package:subrate/widgets/app/button.dart';
import 'package:subrate/widgets/app/loadingdialog.dart';
import 'package:subrate/widgets/app/new_text_field.dart';

import '../../provider/authprovider.dart';

class ForgetPasswordNew extends StatefulWidget {
  static const routeName = 'forgetpassword-screen-new';
  const ForgetPasswordNew({super.key});

  @override
  State<ForgetPasswordNew> createState() => _ForgetPasswordNewState();
}

class _ForgetPasswordNewState extends State<ForgetPasswordNew> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  void showCheckEmailBottomSheet(BuildContext context) {
    final Routers routers = Routers();
    final sizeh = MediaQuery.of(context).size.height;
    final sizew = MediaQuery.of(context).size.width;
    showModalBottomSheet(
      enableDrag: false,
      isDismissible: false,
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.only(top: 60), // space for the icon
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                padding: const EdgeInsets.fromLTRB(24, 45, 24, 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: sizeh * .012),
                    Text(
                      LocaleKeys.check_your_email.tr(),
                      style: AppTextStyles.semiBold
                          .copyWith(fontSize: 18.sp, color: textPrimaryColor),
                    ),
                    SizedBox(height: sizeh * .01),
                    Center(
                      child: Text(
                        LocaleKeys.we_sent.tr(),
                        textAlign: TextAlign.center,
                        style: AppTextStyles.regular.copyWith(
                            fontSize: 10.sp, color: HexColor('#8F94A3')),
                      ),
                    ),
                    SizedBox(height: sizeh * .07),
                    ButtonWidget(
                      onPress: () {
                        routers.navigateToSubmitCodeNewScreen(context,
                            args: {'email': emailController.text});
                      },
                      text: LocaleKeys.resend_otp.tr(),
                      radius: 30,
                      buttonColor: yellowButtonsColor,
                      widget: Padding(
                        padding: EdgeInsets.symmetric(horizontal: sizew * .025),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              LocaleKeys.check_email.tr(),
                              style: AppTextStyles.semiBold.copyWith(
                                  fontSize: 11.sp, color: textPrimaryColor),
                            ),
                            SvgPicture.asset(doubleArrow)
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: sizeh * .025),
                  ],
                ),
              ),
              Positioned(
                top: -30,
                child: Center(
                  child: SvgPicture.asset(mailBox, height: sizeh * .08),
                  // Or use SvgPicture.asset if you have a custom SVG
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: SvgPicture.asset(backIcon, height: sizeh * .03)),
                    Row(
                      children: [
                        SvgPicture.asset(newYellowLogo, height: sizeh * .035),
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
                Text(LocaleKeys.forget_password.tr(),
                    style: AppTextStyles.bold.copyWith(
                      fontSize: 24.sp,
                      color: textPrimaryColor,
                    )),
                SizedBox(
                  height: sizeh * .01,
                ),
                Text(LocaleKeys.we_will_send.tr(),
                    style: AppTextStyles.regular.copyWith(
                      fontSize: 10.5.sp,
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
                        SvgPicture.asset(email, height: sizeh * .027),
                      ],
                    ),
                    hintText: LocaleKeys.email_phase.tr(),
                    errorText: LocaleKeys.enter_email.tr(),
                    title: LocaleKeys.email_address.tr(),
                    hintSize: 12.sp,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return LocaleKeys.enter_email.tr();
                      }
                      final emailRegex =
                          RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                      if (!emailRegex.hasMatch(value)) {
                        return LocaleKeys.enter_email.tr();
                      }
                      return null;
                    },
                    controller: emailController),
                SizedBox(
                  height: sizeh * .045,
                ),
                ButtonWidget(
                    height: sizeh * .055,
                    radius: 30,
                    buttonColor: HexColor('#F0FF85'),
                    text: LocaleKeys.submit.tr(),
                    onPress: () {
                      final isVaild = formKey.currentState!.validate();
                      if (isVaild) {
                        loadingDialog(context);
                        authProvider
                            .requestCodeForResetPass(emailController.text)
                            .then((value) {
                          Navigator.pop(context);
                          if (value == true) {
                            showCheckEmailBottomSheet(context);
                          } else {}
                        });
                      }
                    }),
                SizedBox(
                  height: sizeh * .015,
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.arrow_back,
                        color: textPrimaryColor,
                        size: sizeh * .02,
                      ),
                      SizedBox(width: sizew * .02),
                      Text(
                        LocaleKeys.back_login.tr(),
                        style: AppTextStyles.semiBold
                            .copyWith(fontSize: 11.sp, color: textPrimaryColor),
                      )
                    ],
                  ),
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
