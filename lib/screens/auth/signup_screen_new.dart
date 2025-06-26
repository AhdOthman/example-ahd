import 'package:country_code_picker/country_code_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:subrate/models/auth/signup_model_request.dart';
import 'package:subrate/provider/authprovider.dart';
import 'package:subrate/routers/routers.dart';
import 'package:subrate/theme/app_colors.dart';
import 'package:subrate/theme/assets_managet.dart';
import 'package:subrate/theme/text_style.dart';
import 'package:subrate/theme/ui_helper.dart';
import 'package:subrate/translations/locale_keys.g.dart';
import 'package:subrate/widgets/app/button.dart';
import 'package:subrate/widgets/app/loadingdialog.dart';
import 'package:subrate/widgets/app/new_text_field.dart';

class SignupScreenNew extends StatefulWidget {
  static const routeName = 'signup-screen-new';
  const SignupScreenNew({super.key});

  @override
  State<SignupScreenNew> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<SignupScreenNew> {
  TextEditingController emailController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();

  TextEditingController dobController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String? countryPrefix = '+971';
  DateTime selectedDate = DateTime.now();
  final DateFormat formatter = DateFormat('yyyy-MM-dd', 'en');

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(1900),
        lastDate: DateTime.now());
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        dobController.text = formatter.format(selectedDate);
      });
    }
  }

  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmationController =
      TextEditingController();
  bool _passwordVisible = false;
  bool _passwordVisibleConfirmation = false;

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
                Text(LocaleKeys.join_journey.tr(),
                    style: AppTextStyles.bold.copyWith(
                      fontSize: 24.sp,
                      color: textPrimaryColor,
                    )),
                SizedBox(
                  height: sizeh * .01,
                ),
                Text(LocaleKeys.create_your_account.tr(),
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
                    hintText: LocaleKeys.enter_firstname.tr(),
                    errorText: LocaleKeys.firstname_error.tr(),
                    title: LocaleKeys.first_name.tr(),
                    hintSize: 12.sp,
                    controller: firstNameController),
                SizedBox(
                  height: sizeh * .015,
                ),
                NewCustomField(
                    prefixIcon: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(personIcon, height: sizeh * .027),
                      ],
                    ),
                    hintText: LocaleKeys.enter_lastname.tr(),
                    errorText: LocaleKeys.lastname_error.tr(),
                    title: LocaleKeys.last_name.tr(),
                    hintSize: 12.sp,
                    controller: lastNameController),
                SizedBox(
                  height: sizeh * .015,
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
                    controller: emailController),
                SizedBox(
                  height: sizeh * .015,
                ),
                InkWell(
                  onTap: () {
                    _selectDate(context);
                  },
                  child: NewCustomField(
                      enabled: false,
                      validator: (value) {
                        return null;
                      },
                      widget: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(calendar, height: sizeh * .027),
                        ],
                      ),
                      hintText: 'DD/MM/YY',
                      errorText: LocaleKeys.enter_email.tr(),
                      title: LocaleKeys.dob.tr(),
                      hintSize: 12.sp,
                      controller: dobController),
                ),
                SizedBox(
                  height: sizeh * .015,
                ),
                NewCustomField(
                    enabled: true,
                    validator: (value) {
                      return null;
                    },
                    prefixIcon: SizedBox(
                      width: sizew * .37,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CountryCodePicker(
                            padding: EdgeInsets.symmetric(
                                vertical: sizew * .015, horizontal: sizew * .0),
                            builder: (p0) {
                              print(p0?.flagUri);

                              return Padding(
                                padding: EdgeInsets.only(
                                    left: sizew * .02,
                                    right: sizew * 0,
                                    top: sizew * .015,
                                    bottom: sizew * .015),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IntrinsicHeight(
                                      child: Row(
                                        children: [
                                          ClipOval(
                                            child: Image.asset(
                                              p0!.flagUri!,
                                              package: 'country_code_picker',
                                              width: 25,
                                              height: 25,
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                          SizedBox(width: sizew * .02),
                                          Text(
                                            '(${p0.code})',
                                            style: AppTextStyles.regular
                                                .copyWith(
                                                    fontSize: 12.sp,
                                                    color: textPrimaryColor),
                                          ),
                                          SizedBox(width: sizew * .005),
                                          Text(
                                            p0.dialCode ?? '+971',
                                            style: AppTextStyles.regular
                                                .copyWith(
                                                    fontSize: 12.sp,
                                                    color: textPrimaryColor),
                                          ),
                                          SizedBox(width: sizew * .015),
                                          SvgPicture.asset(menu,
                                              height: sizeh * .02),
                                          SizedBox(width: sizew * .01),
                                          VerticalDivider(
                                            color: HexColor('#E9EAED'),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            onChanged: (country) {
                              print(country);
                              setState(() {
                                countryPrefix = country.dialCode ?? '+971';
                                print(countryPrefix);
                              });
                            },
                            initialSelection: 'AE',
                            showFlag: true,
                            hideMainText: false,
                            showCountryOnly: false,
                            showOnlyCountryWhenClosed: false,
                            showDropDownButton: true,
                            showFlagDialog: true,
                          ),
                        ],
                      ),
                    ),
                    isPhone: true,
                    keyboardType: TextInputType.number,
                    hintText: 'XX-XXXX-XXXX',
                    errorText: LocaleKeys.enter_email.tr(),
                    title: LocaleKeys.phone_number.tr(),
                    hintSize: 12.sp,
                    controller: phoneController),
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
                      padding: EdgeInsets.symmetric(horizontal: sizew * .02),
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
                        SvgPicture.asset(passwordIcon, height: sizeh * .027),
                      ],
                    ),
                    hintText: LocaleKeys.re_enter_password.tr(),
                    errorText: LocaleKeys.password_error.tr(),
                    title: LocaleKeys.confirm_password.tr(),
                    hintSize: 12.sp,
                    controller: passwordConfirmationController),
                SizedBox(
                  height: sizeh * .035,
                ),
                ButtonWidget(
                    height: sizeh * .055,
                    radius: 30,
                    buttonColor: HexColor('#F0FF85'),
                    text: LocaleKeys.signup.tr(),
                    onPress: () {
                      final isVaild = formKey.currentState!.validate();
                      if (isVaild) {
                        loadingDialog(context);
                        authProvider
                            .signUp(
                                signUpRequestModel: SignupModelRequest(
                                    firstName: firstNameController.text,
                                    lastName: lastNameController.text,
                                    countryCode: countryPrefix,
                                    nationalNumber: phoneController.text,
                                    email: emailController.text,
                                    password: passwordController.text,
                                    phone: phoneController.text,
                                    birthDate: dobController.text))
                            .then((value) {
                          Navigator.pop(context);
                          if (value) {
                            UIHelper.showNotification(
                                'Account created successfully, check your email to verify your account',
                                backgroundColor: Colors.green);
                            routers.navigateToVerifyAccountNewScreen(context,
                                args: {'email': emailController.text});
                          } else {}
                        });
                      }
                    }),
                SizedBox(
                  height: sizeh * .025,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      LocaleKeys.already_have.tr(),
                      style: AppTextStyles.regular
                          .copyWith(fontSize: 11.5.sp, color: textPrimaryColor),
                    ),
                    SizedBox(width: sizew * .01),
                    InkWell(
                      onTap: () {
                        routers.navigateToSigninNewScreen(context);
                      },
                      child: Text(LocaleKeys.login.tr(),
                          style: AppTextStyles.semiBold.copyWith(
                              fontSize: 11.5.sp, color: textPrimaryColor)),
                    )
                  ],
                ),
                SizedBox(height: sizeh * .015),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
