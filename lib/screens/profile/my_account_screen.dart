import 'package:dropdown_search/dropdown_search.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:subrate/models/profile/edit_profile_model.dart';
import 'package:subrate/provider/appprovider.dart';
import 'package:subrate/provider/profileprovider.dart';
import 'package:subrate/routers/routers.dart';
import 'package:subrate/theme/app_colors.dart';
import 'package:subrate/theme/assets_managet.dart';
import 'package:subrate/theme/text_style.dart';
import 'package:subrate/translations/locale_keys.g.dart';
import 'package:subrate/widgets/app/button.dart';
import 'package:subrate/widgets/app/loadingdialog.dart';
import 'package:subrate/widgets/app/textfield.dart';

class MyAccountScreen extends StatefulWidget {
  static const routeName = 'my-account-screen';
  const MyAccountScreen({super.key});

  @override
  State<MyAccountScreen> createState() => _MyAccountScreenState();
}

class _MyAccountScreenState extends State<MyAccountScreen> {
  String? _myCountry;
  String? _country;
  TextEditingController emailController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController countryController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  final DateFormat formatter = DateFormat('yyyy-MM-dd');

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

  @override
  void initState() {
    final appProvider = Provider.of<AppProvider>(context, listen: false);

    final profileProvider =
        Provider.of<Profileprovider>(context, listen: false);
    firstNameController.text = profileProvider.profileModel?.firstName ?? '';
    lastNameController.text = appProvider.isFromHome
        ? profileProvider.profileModel?.firstName ?? ''
        : profileProvider.profileModel?.lastName ?? '';
    emailController.text = profileProvider.profileModel?.email ?? '';
    phoneController.text = profileProvider.profileModel?.phone ?? '';
    profileProvider.profileModel?.birthDate != null
        ? dobController.text = formatter.format(DateTime.parse(
            profileProvider.profileModel?.birthDate ?? '1/1/1000'))
        : null;
    profileProvider.profileModel?.countryId != null
        ? _myCountry = profileProvider.profileModel?.countryId.toString()
        : '';
    profileProvider.profileModel?.countryName != null
        ? _country = profileProvider.profileModel?.countryName.toString()
        : '';

    // TODO: implement initState
    super.initState();
  }

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final sizeh = MediaQuery.of(context).size.height;
    final sizew = MediaQuery.of(context).size.width;
    final Routers routers = Routers();
    final space = SizedBox(
      height: sizeh * .02,
    );
    final appProvider = Provider.of<AppProvider>(context);
    final profileProvider = Provider.of<Profileprovider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.symmetric(
            horizontal: sizew * .035, vertical: sizeh * .015),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: sizeh * .07,
                ),
                Row(
                  children: [
                    appProvider.isFromHome
                        ? SizedBox()
                        : InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: sizew * .01,
                                  vertical: sizeh * .005),
                              child: Icon(Icons.arrow_back,
                                  color: yallewTextColor),
                            ),
                          ),
                    SizedBox(
                      width: sizew * .03,
                    ),
                    Text(
                      LocaleKeys.my_account.tr(),
                      style: AppTextStyles.semiBold
                          .copyWith(fontSize: 16.sp, color: primaryColor),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: sizew * .04),
                  child: Column(
                    children: [
                      SizedBox(
                        height: sizeh * .035,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: sizew * .41,
                            child: CustomField(
                                errorText: 'Please enter your first name',
                                labelColor: primaryColor,
                                disabledBorder: primaryColor,
                                hintText: LocaleKeys.first_name.tr(),
                                title: LocaleKeys.first_name.tr(),
                                hintSize: 1,
                                controller: firstNameController),
                          ),
                          SizedBox(
                            width: sizew * .03,
                          ),
                          SizedBox(
                            width: sizew * .41,
                            child: CustomField(
                                errorText: 'Please enter your last name',
                                labelColor: primaryColor,
                                disabledBorder: primaryColor,
                                hintText: LocaleKeys.last_name.tr(),
                                title: LocaleKeys.last_name.tr(),
                                hintSize: 1,
                                controller: lastNameController),
                          ),
                        ],
                      ),
                      space,
                      CustomField(
                          labelColor: primaryColor,
                          disabledBorder: primaryColor,
                          hintText: LocaleKeys.email.tr(),
                          title: LocaleKeys.email.tr(),
                          hintSize: 1,
                          controller: emailController),
                      // DropdownSearch<String>(
                      //   validator: (value) {
                      //     if (value?.isEmpty ?? true) {
                      //       return 'Please enter your country';
                      //     }

                      //     return null;
                      //   },
                      //   selectedItem: _country,
                      //   popupProps: const PopupProps.menu(
                      //     showSearchBox: true,
                      //     showSelectedItems: true,
                      //   ),
                      //   items: appProvider.countryList.map((item) {
                      //     return item.nameAr ?? '';
                      //   }).toList(),
                      //   dropdownDecoratorProps: DropDownDecoratorProps(
                      //     baseStyle: AppTextStyles.regular
                      //         .copyWith(fontSize: 12.sp, color: primaryColor),
                      //     dropdownSearchDecoration: InputDecoration(
                      //       alignLabelWithHint: true,
                      //       enabledBorder: UnderlineInputBorder(
                      //           borderSide:
                      //               BorderSide(color: primaryColor, width: 1)),
                      //       disabledBorder: UnderlineInputBorder(
                      //         borderSide:
                      //             BorderSide(color: primaryColor, width: 1),
                      //       ),
                      //       focusedBorder: UnderlineInputBorder(
                      //         borderSide:
                      //             BorderSide(color: primaryColor, width: 1),
                      //       ),
                      //       //create border with borderRadius
                      //       border: UnderlineInputBorder(
                      //         borderSide:
                      //             BorderSide(color: primaryColor, width: 1),
                      //       ),

                      //       hintStyle: TextStyle(
                      //           fontSize: 12.sp,
                      //           fontWeight: FontWeight.w500,
                      //           color: primaryColor),
                      //       hintText: LocaleKeys.country.tr(),
                      //       label: Text(
                      //         LocaleKeys.country.tr(),
                      //       ),
                      //       labelStyle: AppTextStyles.regular
                      //           .copyWith(fontSize: 12.sp, color: primaryColor),
                      //     ),
                      //   ),
                      //   onChanged: (newValue) {
                      //     setState(() {
                      //       appProvider.countryList.forEach((element) {
                      //         element.nameAr == newValue
                      //             ? _myCountry = element.id.toString()
                      //             : '';
                      //         print(_myCountry);
                      //       });

                      //       // print(_myType);
                      //       _country = newValue;
                      //     });
                      //   },
                      // ),
                      DropdownSearch<String>(
                        validator: (value) {
                          return null;
                        },
                        selectedItem: _country,
                        popupProps: PopupProps.menu(
                          showSearchBox: true,
                          showSelectedItems: true,
                          itemBuilder: (context, item, isSelected) {
                            final country = appProvider.countryList.firstWhere(
                              (element) => element.nameAr == item,
                            );

                            return ListTile(
                              leading: country.flag != null
                                  ? country.flag!.contains('svg')
                                      ? SvgPicture.network(
                                          country.flag!,
                                          height: sizeh * .03,
                                        )
                                      : Image.network(
                                          country.flag!,
                                          fit: BoxFit.cover,
                                        )
                                  : const Icon(Icons.flag),
                              title: Text(
                                country.nameAr ?? '',
                                style: TextStyle(
                                  color:
                                      isSelected ? Colors.blue : Colors.black,
                                ),
                              ),
                            );
                          },
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
                              borderSide: BorderSide(
                                  color: Color(0xFFCBD5E1), width: 1),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xFFCBD5E1), width: 1),
                            ),
                            //create border with borderRadius
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xFFCBD5E1), width: 1),
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
                          validator: (value) {
                            return null;
                          },
                          keyboardType: TextInputType.number,
                          isPhone: true,
                          didgits: 16,
                          labelColor: primaryColor,
                          disabledBorder: primaryColor,
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
                            validator: (p0) {
                              return null;
                            },
                            labelColor: primaryColor,
                            disabledBorder: primaryColor,
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
                    ],
                  ),
                ),
                SizedBox(
                  height: sizeh * .035,
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
                        profileProvider
                            .editProfile(
                                editProfileModel: EditProfileModel(
                          firstName: firstNameController.text,
                          lastName: lastNameController.text,
                          email: emailController.text,
                          phone: phoneController.text,
                          birthDate: dobController.text,
                          countryId: _myCountry,
                        ))
                            .then((value) {
                          print('value $value');
                          if (value == true) {
                            appProvider.isFromHome
                                ? routers.navigateToBottomBarScreen(context)
                                : profileProvider
                                    .getProfileData(context)
                                    .then((value) {
                                    appProvider.isFromHome = false;

                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                    appProvider.isFromHome = false;
                                  });
                          } else {
                            Navigator.pop(context);
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
