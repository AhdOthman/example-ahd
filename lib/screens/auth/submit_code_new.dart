import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:subrate/routers/routers.dart';
import 'package:subrate/theme/app_colors.dart';
import 'package:subrate/theme/assets_managet.dart';
import 'package:subrate/theme/text_style.dart';
import 'package:subrate/theme/ui_helper.dart';
import 'package:subrate/translations/locale_keys.g.dart';
import 'package:subrate/widgets/app/button.dart';

import '../../provider/authprovider.dart';

class SubmitCodeNew extends StatefulWidget {
  static const routeName = 'submitcode-screen-new';
  const SubmitCodeNew({super.key});

  @override
  State<SubmitCodeNew> createState() => _SubmitCodeNewState();
}

class _SubmitCodeNewState extends State<SubmitCodeNew> {
  TextEditingController codeController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final Routers routers = Routers();

  bool _isButtonEnabled = true;
  int _cooldownSeconds = 60;
  Timer? _timer;
  bool error = false;
  void _startCooldown() {
    setState(() {
      _isButtonEnabled = false;
      _cooldownSeconds = 60;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_cooldownSeconds == 1) {
        timer.cancel();
        setState(() {
          _isButtonEnabled = true;
        });
      } else {
        setState(() {
          _cooldownSeconds--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

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
                Text(LocaleKeys.enter_digits.tr(),
                    style: AppTextStyles.bold.copyWith(
                      fontSize: 24.sp,
                      color: textPrimaryColor,
                    )),
                SizedBox(
                  height: sizeh * .01,
                ),
                Text(LocaleKeys.check_email_sent.tr(),
                    style: AppTextStyles.regular.copyWith(
                      fontSize: 10.5.sp,
                      color: HexColor('#8F94A3'),
                    )),
                SizedBox(
                  height: sizeh * .02,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: sizew * .02),
                  child: PinCodeTextField(
                    enablePinAutofill: true,
                    appContext: context,
                    pastedTextStyle: TextStyle(
                      color: Colors.green.shade600,
                      fontWeight: FontWeight.bold,
                    ),
                    inputFormatters: <TextInputFormatter>[
                      LengthLimitingTextInputFormatter(6),
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    keyboardType: TextInputType.number,
                    length: 6,
                    obscureText: false,
                    obscuringCharacter: '*',

                    blinkWhenObscuring: true,
                    animationType: AnimationType.fade,
                    validator: (v) {
                      if (v!.length < 6) {
                        return "Please enter 6 digits code";
                      } else {
                        return null;
                      }
                    },
                    pinTheme: PinTheme(
                        borderWidth: sizew * .004,
                        activeColor: HexColor('2A2D36'),
                        shape: PinCodeFieldShape.circle,
                        fieldHeight: 45,
                        fieldWidth: 45,
                        activeFillColor: Colors.white,
                        inactiveFillColor: Colors.white,
                        inactiveColor: HexColor('#E9EAED'),
                        selectedFillColor: Colors.white),
                    cursorColor: Colors.black,
                    animationDuration: const Duration(milliseconds: 300),
                    enableActiveFill: true,
                    controller: codeController,
                    hintCharacter: '0',
                    hintStyle: AppTextStyles.regular
                        .copyWith(fontSize: 11.sp, color: HexColor('#8F94A3')),
                    onCompleted: (v) {
                      final isVaild = formKey.currentState!.validate();
                      if (isVaild) {
                        routers
                            .navigateToResetPasswordNewScreen(context, args: {
                          'email': argumets['email'],
                          'code': codeController.text,
                        });
                      }
                    },
                    // onTap: () {
                    //   print("Pressed");
                    // },
                    onChanged: (String text) {
                      codeController.text = text;
                      print("Changed");
                    },
                    beforeTextPaste: (text) {
                      debugPrint("Allowing to paste $text");
                      //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                      //but you can show anything you want here, like your pop up saying wrong paste format or etc
                      return true;
                    },
                  ),
                ),
                SizedBox(
                  height: sizeh * .045,
                ),
                ButtonWidget(
                    height: sizeh * .055,
                    radius: 30,
                    buttonColor: HexColor('#F0FF85'),
                    text: LocaleKeys.verify_code.tr(),
                    onPress: () {
                      final isVaild = formKey.currentState!.validate();
                      if (isVaild) {
                        // loadingDialog(context);
                        // authProvider
                        //     .requestCodeForResetPass(emailController.text)
                        //     .then((value) {
                        //   Navigator.pop(context);
                        //   if (value == true) {
                        //   } else {}
                        // });
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      LocaleKeys.didnt_recieve.tr(),
                      style: AppTextStyles.regular
                          .copyWith(fontSize: 12.sp, color: textPrimaryColor),
                    ),
                    SizedBox(
                      width: sizew * .01,
                    ),
                    InkWell(
                      onTap: _isButtonEnabled
                          ? () {
                              authProvider
                                  .resendVerifyOtp(argumets['email'])
                                  .then((value) {
                                if (value == true) {
                                  UIHelper.showNotification(
                                      'Code sent successfully',
                                      backgroundColor: Colors.green);
                                }
                              });
                              _startCooldown();
                            }
                          : null,
                      child: Text(
                          _isButtonEnabled
                              ? LocaleKeys.resend_otp.tr()
                              : 'Wait $_cooldownSeconds sec',
                          style: AppTextStyles.semiBold.copyWith(
                              fontSize: 12.sp, color: textPrimaryColor)),
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
