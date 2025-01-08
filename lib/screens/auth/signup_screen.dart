import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:subrate/models/auth/signup_model_request.dart';
import 'package:subrate/provider/appprovider.dart';
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
import 'package:subrate/widgets/auth/social_button.dart';
import 'package:dropdown_search/dropdown_search.dart';

class SignupScreen extends StatefulWidget {
  static const routeName = 'signup-screen';
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  String? _country;
  String? _myCountry;
  TextEditingController emailController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  TextEditingController passwordController = TextEditingController();
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

  bool acseptTerms = false;
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final Routers routers = Routers();
    final sizeh = MediaQuery.of(context).size.height;
    final sizew = MediaQuery.of(context).size.width;
    final space = SizedBox(
      height: sizeh * .003,
    );
    final appProvider = Provider.of<AppProvider>(context);
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
                    LocaleKeys.signup.tr(),
                    style: AppTextStyles.bold
                        .copyWith(fontSize: 26.sp, color: primaryColor),
                  )),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: sizew * .09),
              alignment: Alignment.bottomLeft,
              decoration: BoxDecoration(color: Colors.white),
              height: sizeh * .65,
              width: sizew,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: sizew * .38,
                          child: CustomField(
                              hintText: LocaleKeys.first_name.tr(),
                              title: LocaleKeys.first_name.tr(),
                              hintSize: 1,
                              controller: firstNameController),
                        ),
                        SizedBox(
                          width: sizew * .03,
                        ),
                        SizedBox(
                          width: sizew * .38,
                          child: CustomField(
                              hintText: LocaleKeys.last_name.tr(),
                              title: LocaleKeys.last_name.tr(),
                              hintSize: 1,
                              controller: lastNameController),
                        ),
                      ],
                    ),
                    space,
                    CustomField(
                        hintText: LocaleKeys.email.tr(),
                        title: LocaleKeys.email.tr(),
                        hintSize: 1,
                        controller: emailController),
                    space,
                    DropdownSearch<String>(
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter some text';
                        }

                        return null;
                      },
                      selectedItem: _country,
                      popupProps: const PopupProps.menu(
                        showSearchBox: true,
                        showSelectedItems: true,
                      ),
                      items: appProvider.countryList.map((item) {
                        return item.nameAr ?? '';
                      }).toList(),
                      dropdownDecoratorProps: DropDownDecoratorProps(
                        baseStyle: AppTextStyles.regular
                            .copyWith(fontSize: 12.sp, color: primaryColor),
                        dropdownSearchDecoration: InputDecoration(
                          alignLabelWithHint: true,
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xFFCBD5E1), width: 1)),
                          disabledBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Color(0xFFCBD5E1), width: 1),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Color(0xFFCBD5E1), width: 1),
                          ),
                          //create border with borderRadius
                          border: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Color(0xFFCBD5E1), width: 1),
                          ),

                          hintStyle: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: HexColor('#242424')),
                          hintText: LocaleKeys.country.tr(),
                          label: Text(
                            LocaleKeys.country.tr(),
                          ),
                          labelStyle: AppTextStyles.regular.copyWith(
                              fontSize: 12.sp, color: Color(0xFF757575)),
                        ),
                      ),
                      onChanged: (newValue) {
                        setState(() {
                          appProvider.countryList.forEach((element) {
                            element.nameAr == newValue
                                ? _myCountry = element.id.toString()
                                : '';
                            print(_myCountry);
                          });

                          // print(_myType);
                          _country = newValue;
                        });
                      },
                    ),
                    space,
                    CustomField(
                        isPhone: true,
                        didgits: 10,
                        hintText: LocaleKeys.phone_number.tr(),
                        title: LocaleKeys.phone_number.tr(),
                        hintSize: 1,
                        controller: phoneController),
                    space,
                    InkWell(
                      onTap: () {
                        _selectDate(context);
                      },
                      child: CustomField(
                          enabled: false,
                          hintText: LocaleKeys.dob.tr(),
                          title: LocaleKeys.dob.tr(),
                          widget: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                calendar,
                                height: sizeh * .025,
                              )
                            ],
                          ),
                          hintSize: 1,
                          controller: dobController),
                    ),
                    space,
                    CustomField(
                        passwordCover: true,
                        isPassword: true,
                        hintText: LocaleKeys.password.tr(),
                        title: LocaleKeys.password.tr(),
                        hintSize: 1,
                        controller: passwordController),
                    SizedBox(
                      height: sizeh * .045,
                    ),
                    ButtonWidget(
                      text: LocaleKeys.signup.tr(),
                      onPress: acseptTerms
                          ? () {
                              final isVaild = formKey.currentState!.validate();
                              if (isVaild) {
                                loadingDialog(context);
                                authProvider
                                    .signUp(
                                        signUpRequestModel: SignupModelRequest(
                                            firstName: firstNameController.text,
                                            lastName: lastNameController.text,
                                            email: emailController.text,
                                            password: passwordController.text,
                                            phone: phoneController.text,
                                            countryId: _myCountry,
                                            birthDate: dobController.text))
                                    .then((value) {
                                  Navigator.pop(context);
                                  if (value) {
                                    routers.navigateToBottomBarScreen(context);
                                  }
                                });
                              }
                            }
                          : () {
                              UIHelper.showNotification(
                                  LocaleKeys.please_accept_terms.tr());
                            },
                      textStyle: AppTextStyles.semiBold
                          .copyWith(fontSize: 12.5.sp, color: Colors.white),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Checkbox(
                            activeColor: primaryColor,
                            value: acseptTerms,
                            onChanged: (newValue) {
                              setState(() {
                                acseptTerms = newValue ?? false;
                              });
                            }),
                        Text(LocaleKeys.have_read.tr(),
                            style: AppTextStyles.light
                                .copyWith(fontSize: 11.sp, color: primaryColor))
                      ],
                    ),
                    SizedBox(
                      height: sizeh * .025,
                    ),
                    Text(
                      LocaleKeys.or_continue.tr(),
                      style: AppTextStyles.regular
                          .copyWith(fontSize: 12.sp, color: Color(0xFF64748B)),
                    ),
                    SizedBox(
                      height: sizeh * .015,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SocialButton(assetName: googleIcon, title: 'Google'),
                        SizedBox(
                          width: sizew * .02,
                        ),
                        SocialButton(
                            assetName: facebookIcon, title: 'Facebook'),
                        SizedBox(
                          width: sizew * .02,
                        ),
                        SocialButton(assetName: appleIcon, title: 'Apple'),
                      ],
                    ),
                    SizedBox(
                      height: sizeh * .025,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          LocaleKeys.already_have.tr(),
                          style: AppTextStyles.regular.copyWith(
                              fontSize: 11.5.sp, color: Color(0xFF828282)),
                        ),
                        SizedBox(
                          width: sizew * .01,
                        ),
                        InkWell(
                          onTap: () {
                            routers.navigateToSigninScreen(context);
                          },
                          child: Text(
                            LocaleKeys.login.tr(),
                            style: AppTextStyles.bold.copyWith(
                                fontSize: 11.5.sp, color: primaryColor),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: sizeh * .025,
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
