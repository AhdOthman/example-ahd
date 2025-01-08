import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:subrate/models/auth/update_password_model.dart';
import 'package:subrate/provider/authprovider.dart';
import 'package:subrate/theme/app_colors.dart';
import 'package:subrate/theme/text_style.dart';
import 'package:subrate/theme/ui_helper.dart';
import 'package:subrate/translations/locale_keys.g.dart';
import 'package:subrate/widgets/app/button.dart';
import 'package:subrate/widgets/app/loadingdialog.dart';
import 'package:subrate/widgets/app/textfield.dart';

class ChangePasswordScreen extends StatefulWidget {
  static const routeName = '/change-password';
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  bool _passwordVisible = false;
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final sizeh = MediaQuery.of(context).size.height;
    final sizew = MediaQuery.of(context).size.width;
    final space = SizedBox(
      height: sizeh * .02,
    );
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: formKey,
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: sizew * .035, vertical: sizeh * .015),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: sizeh * .07,
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: sizew * .01, vertical: sizeh * .005),
                        child: Icon(Icons.arrow_back, color: yallewTextColor),
                      ),
                    ),
                    SizedBox(
                      width: sizew * .02,
                    ),
                    Text(
                      LocaleKeys.change_password.tr(),
                      style: AppTextStyles.semiBold
                          .copyWith(fontSize: 16.sp, color: primaryColor),
                    ),
                  ],
                ),
                SizedBox(
                  height: sizeh * .035,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: sizew * .05),
                  child: Column(
                    children: [
                      CustomField(
                          passwordCover: true,
                          isPassword: true,
                          labelColor: primaryColor,
                          disabledBorder: primaryColor,
                          hintText: LocaleKeys.current_password.tr(),
                          title: LocaleKeys.current_password.tr(),
                          hintSize: 1,
                          controller: currentPasswordController),
                      space,
                      CustomField(
                          isPassword: true,
                          passwordCover: _passwordVisible,
                          widget: IconButton(
                              icon: Icon(
                                // Based on passwordVisible state choose the icon
                                _passwordVisible
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: yallewTextColor,
                              ),
                              onPressed: () {
                                // Update the state i.e. toogle the state of passwordVisible variable
                                setState(() {
                                  _passwordVisible = !_passwordVisible;
                                });
                              }),
                          labelColor: primaryColor,
                          disabledBorder: primaryColor,
                          hintText: LocaleKeys.new_passowrd.tr(),
                          title: LocaleKeys.new_passowrd.tr(),
                          hintSize: 1,
                          controller: newPasswordController),
                    ],
                  ),
                ),
                SizedBox(
                  height: sizeh * .045,
                ),
                Center(
                  child: ButtonWidget(
                    radius: 5,
                    textStyle: AppTextStyles.regular
                        .copyWith(fontSize: 12.5.sp, color: Colors.white),
                    height: sizeh * .05,
                    width: sizew * .45,
                    text: LocaleKeys.update.tr(),
                    onPress: () {
                      final isVaild = formKey.currentState!.validate();
                      if (isVaild) {
                        loadingDialog(context);
                        authProvider
                            .updatePassword(
                                updatePasswordModel: UpdatePasswordModel(
                                    newPassword: newPasswordController.text,
                                    oldPassword:
                                        currentPasswordController.text))
                            .then((value) {
                          Navigator.pop(context);
                          if (value == true) {
                            UIHelper.showNotification(
                                LocaleKeys.password_updated.tr(),
                                backgroundColor: Colors.green);
                          } else {
                            UIHelper.showNotification(
                                LocaleKeys.wrong_username.tr());
                          }
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
