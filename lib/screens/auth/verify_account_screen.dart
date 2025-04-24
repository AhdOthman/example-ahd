import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:subrate/models/auth/verify_account_model.dart';
import 'package:subrate/provider/authprovider.dart';
import 'package:subrate/routers/routers.dart';
import 'package:subrate/theme/app_colors.dart';
import 'package:subrate/theme/assets_managet.dart';
import 'package:subrate/theme/text_style.dart';
import 'package:subrate/theme/ui_helper.dart';
import 'package:subrate/translations/locale_keys.g.dart';
import 'package:subrate/widgets/app/button.dart';
import 'package:subrate/widgets/app/loadingdialog.dart';

class VerifyAccountScreen extends StatefulWidget {
  static const routeName = 'verify-account-screen';
  const VerifyAccountScreen({super.key});

  @override
  State<VerifyAccountScreen> createState() => _VerifyAccountScreenState();
}

class _VerifyAccountScreenState extends State<VerifyAccountScreen> {
  TextEditingController codeController = TextEditingController();

  final formKey = GlobalKey<FormState>();
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
    final argumets =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final Routers routers = Routers();
    final sizeh = MediaQuery.of(context).size.height;
    final sizew = MediaQuery.of(context).size.width;

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
                    LocaleKeys.verify_identity.tr(),
                    style: AppTextStyles.bold
                        .copyWith(fontSize: 17.sp, color: primaryColor),
                  )),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: sizew * .02),
              alignment: Alignment.bottomLeft,
              decoration: BoxDecoration(color: Colors.white),
              height: sizeh * .45,
              width: sizew,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      LocaleKeys.we_sent.tr(),
                      style: AppTextStyles.regular
                          .copyWith(fontSize: 10.sp, color: HexColor('64748B')),
                    ),
                    Row(
                      children: [
                        Text(
                          argumets['email'],
                          style: AppTextStyles.regular.copyWith(
                              fontSize: 9.sp, color: HexColor('64748B')),
                        ),
                        SizedBox(
                          width: sizew * .02,
                        ),
                        Text(
                          LocaleKeys.enter_it_below.tr(),
                          style: AppTextStyles.regular.copyWith(
                              fontSize: 9.5.sp, color: HexColor('64748B')),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: sizeh * .025,
                    ),
                    // OtpPinField(

                    //   maxLength: 6,
                    //   fieldWidth: 40,
                    //   fieldHeight: 40,
                    //   otpPinFieldDecoration:
                    //       OtpPinFieldDecoration.defaultPinBoxDecoration,
                    //   otpPinFieldStyle: OtpPinFieldStyle(

                    //     fieldBorderWidth: 1,
                    //     defaultFieldBorderColor:
                    //         HexColor('2A2D36').withOpacity(.5),
                    //     activeFieldBorderColor: HexColor('2A2D36'),
                    //     defaultFieldBackgroundColor: Colors.white,
                    //     filledFieldBackgroundColor: Colors.white,
                    //   ),
                    //   keyboardType: TextInputType.number,
                    //   onSubmit: (String text) {
                    //     final isVaild = formKey.currentState!.validate();
                    //     if (isVaild) {
                    //       loadingDialog(context);
                    //       authProvider
                    //           .verifyAccount(VerifyAccountModel(
                    //               code: codeController.text,
                    //               identifier: argumets['email']))
                    //           .then((value) {
                    //         Navigator.pop(context);
                    //         if (value == true) {
                    //           UIHelper.showNotification(
                    //               'Account verified successfully',
                    //               backgroundColor: Colors.green);
                    //           routers.navigateToBottomBarScreen(context);
                    //           setState(() {
                    //             error = false;
                    //           });
                    //         } else {
                    //           setState(() {
                    //             error = true;
                    //           });
                    //         }
                    //       });
                    //     }
                    //   },
                    //   onChange: (String text) {
                    //     codeController.text = text;
                    //     print("Changed");
                    //   },
                    // ),
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
                            shape: PinCodeFieldShape.box,
                            borderRadius: BorderRadius.circular(4),
                            fieldHeight: 45,
                            fieldWidth: 45,
                            activeFillColor: Colors.white,
                            inactiveFillColor: Colors.white,
                            inactiveColor: HexColor('2A2D36').withOpacity(.5),
                            selectedFillColor: Colors.white),
                        cursorColor: Colors.black,
                        animationDuration: const Duration(milliseconds: 300),
                        enableActiveFill: true,
                        controller: codeController,

                        onCompleted: (v) {
                          final isVaild = formKey.currentState!.validate();
                          if (isVaild) {
                            loadingDialog(context);
                            authProvider
                                .verifyAccount(VerifyAccountModel(
                                    code: codeController.text,
                                    identifier: argumets['email']))
                                .then((value) {
                              Navigator.pop(context);
                              if (value == true) {
                                UIHelper.showNotification(
                                    'Account verified successfully',
                                    backgroundColor: Colors.green);
                                routers.navigateToBottomBarScreen(context);
                                setState(() {
                                  error = false;
                                });
                              } else {
                                setState(() {
                                  error = true;
                                });
                              }
                            });
                          }
                        },
                        // onTap: () {
                        //   print("Pressed");
                        // },
                        onChanged: (String text) {
                          codeController.text = text;
                        },
                        beforeTextPaste: (text) {
                          //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                          //but you can show anything you want here, like your pop up saying wrong paste format or etc
                          return true;
                        },
                      ),
                    ),
                    SizedBox(
                      height: sizeh * .0,
                    ),
                    error == true
                        ? Text(LocaleKeys.code_inncorrect.tr(),
                            style: AppTextStyles.regular.copyWith(
                                fontSize: 11.sp, color: HexColor('D00000')))
                        : SizedBox(),
                    SizedBox(
                      height: sizeh * .025,
                    ),
                    ButtonWidget(
                      text: LocaleKeys.next.tr(),
                      onPress: () {
                        final isVaild = formKey.currentState!.validate();
                        if (isVaild) {
                          loadingDialog(context);
                          authProvider
                              .verifyAccount(VerifyAccountModel(
                                  code: codeController.text,
                                  identifier: argumets['email']))
                              .then((value) {
                            Navigator.pop(context);
                            if (value == true) {
                              UIHelper.showNotification(
                                  'Account verified successfully',
                                  backgroundColor: Colors.green);
                              routers.navigateToBottomBarScreen(context);
                              setState(() {
                                error = false;
                              });
                            } else {
                              setState(() {
                                error = true;
                              });
                            }
                          });
                        }
                      },
                      textStyle: AppTextStyles.semiBold
                          .copyWith(fontSize: 12.5.sp, color: Colors.white),
                    ),
                    SizedBox(
                      height: sizeh * .14,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          LocaleKeys.didnt_recieve.tr(),
                          style: AppTextStyles.regular.copyWith(
                              fontSize: 11.5.sp, color: Color(0xFF828282)),
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
                                          'OTP sent successfully',
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
                              style: AppTextStyles.bold.copyWith(
                                  fontSize: 11.5.sp, color: primaryColor)),
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
