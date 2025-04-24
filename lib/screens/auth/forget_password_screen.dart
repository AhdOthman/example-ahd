import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:subrate/provider/authprovider.dart';
import 'package:subrate/routers/routers.dart';
import 'package:subrate/theme/app_colors.dart';
import 'package:subrate/theme/assets_managet.dart';
import 'package:subrate/theme/text_style.dart';
import 'package:subrate/translations/locale_keys.g.dart';
import 'package:subrate/widgets/app/button.dart';
import 'package:subrate/widgets/app/loadingdialog.dart';
import 'package:subrate/widgets/app/textfield.dart';

class ForgetPasswordScreen extends StatefulWidget {
  static const routeName = 'forget-password-screen';
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  TextEditingController emailController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final Routers routers = Routers();
    final sizeh = MediaQuery.of(context).size.height;
    final sizew = MediaQuery.of(context).size.width;

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
                    LocaleKeys.forget_password.tr(),
                    style: AppTextStyles.bold
                        .copyWith(fontSize: 20.sp, color: primaryColor),
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
                        errorText: 'Please enter your email',
                        hintText: LocaleKeys.email.tr(),
                        title: LocaleKeys.email.tr(),
                        hintSize: 1,
                        controller: emailController),
                    SizedBox(
                      height: sizeh * .025,
                    ),
                    ButtonWidget(
                      text: LocaleKeys.send_otp.tr(),
                      onPress: () {
                        final isVaild = formKey.currentState!.validate();
                        if (isVaild) {
                          loadingDialog(context);
                          authProvider
                              .requestCodeForResetPass(emailController.text)
                              .then((value) {
                            Navigator.pop(context);
                            if (value == true) {
                              routers.navigateToSubmitCodeScreen(context,
                                  args: {'email': emailController.text});
                            } else {}
                          });
                          // authProvider
                          //     .signUp(
                          //         signUpRequestModel: SignupModelRequest(
                          //             countryCode: countryPrefix,
                          //             nationalNumber:
                          //                 phoneController.text,
                          //             firstName: firstNameController.text,
                          //             lastName: lastNameController.text,
                          //             email: emailController.text,
                          //             password: passwordController.text,
                          //             phone:
                          //                 '${countryPrefix}${phoneController.text}',
                          //             countryId: _myCountry,
                          //             birthDate: dobController.text))
                          //     .then((value) {
                          //   Navigator.pop(context);
                          //   if (value) {
                          //     routers.navigateToBottomBarScreen(context);
                          //   } else {}
                          // });
                        }
                      },
                      textStyle: AppTextStyles.semiBold
                          .copyWith(fontSize: 12.5.sp, color: Colors.white),
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
