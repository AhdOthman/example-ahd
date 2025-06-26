import 'package:dropdown_search/dropdown_search.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:subrate/api_url.dart';
import 'package:subrate/models/kyc/send_kyc_request_model.dart';
import 'package:subrate/provider/appprovider.dart';
import 'package:subrate/provider/authprovider.dart';
import 'package:subrate/provider/profileprovider.dart';
import 'package:subrate/provider/storageprovider.dart';
import 'package:subrate/theme/app_colors.dart';
import 'package:subrate/theme/assets_managet.dart';
import 'package:subrate/theme/failure.dart';
import 'package:subrate/theme/text_style.dart';
import 'package:subrate/theme/ui_helper.dart';
import 'package:subrate/translations/locale_keys.g.dart';
import 'package:subrate/widgets/app/button.dart';
import 'package:subrate/widgets/app/loaderwidget.dart';
import 'package:subrate/widgets/app/loadingdialog.dart';
import 'package:subrate/widgets/app/text_widget.dart';
import 'package:subrate/widgets/app/textfield.dart';

class KycVerificationScreen extends StatefulWidget {
  static const routeName = 'kyc-verification-screen';
  const KycVerificationScreen({super.key});

  @override
  State<KycVerificationScreen> createState() => _KycVerificationScreenState();
}

class _KycVerificationScreenState extends State<KycVerificationScreen> {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController typeOfCardController = TextEditingController();
  TextEditingController cardIDController = TextEditingController();
  TextEditingController adressController = TextEditingController();

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

  final ImagePicker _picker = ImagePicker();
  String? imageResult;

  setImage() async {
    final image = await _picker.pickImage(source: ImageSource.gallery);

    final storageProvider =
        Provider.of<StorageProvider>(context, listen: false);

    if (image != null) {
      loadingDialog(context);
      storageProvider
          .uploadFile(imageFile: image, context: context)
          .then((value) {
        Navigator.pop(context);
        if (value == true) {
          setState(() {
            imageResult = storageProvider.resultLink;
          });
        }
      });
    }
    print(image);

    print(image);
  }

  bool fieldEnabled = true;
  final formKey = GlobalKey<FormState>();

  List<KYCCardType> cardTypeList = [
    KYCCardType(
      id: 'ID_CARD',
      title: LocaleKeys.id_card.tr(),
    ),
    KYCCardType(
      id: 'PASSPORT',
      title: LocaleKeys.passapot.tr(),
    ),
    KYCCardType(
      id: 'DRIVING_LICENSE',
      title: LocaleKeys.driver_licence.tr(),
    ),
  ];
  String? _cardType;
  String? _myType;

  String? _country;
  String? _myCountry;
  Future _getKYC() async {
    final profileProvider =
        Provider.of<Profileprovider>(context, listen: false);
    return await profileProvider.getKyc(
        userID: profileProvider.profileModel?.id ?? '',
        tenantID: Provider.of<AuthProvider>(context, listen: false).tenantID!);
  }

  Future _get() async {
    return print('object');
  }

  bool isNoTenant = false;
  @override
  void initState() {
    if (Provider.of<AuthProvider>(context, listen: false).tenantID == null) {
      _fetchKYC = _get();
      setState(() {
        isNoTenant = true;
      });
    } else {
      final profileProvider =
          Provider.of<Profileprovider>(context, listen: false);

      _fetchKYC = _getKYC().whenComplete(() {
        if (profileProvider.getKycModel?.kycDetails != null) {
          fullNameController.text =
              profileProvider.getKycModel?.kycDetails?.fullName ?? '';
          dobController.text = formatter.format(DateTime.parse(
              profileProvider.getKycModel?.kycDetails?.dateOfBirth ??
                  '1/1/1000'));

          cardIDController.text =
              profileProvider.getKycModel?.kycDetails?.cardHolderId ?? '';
          imageResult =
              profileProvider.getKycModel?.kycDetails?.cardImage ?? '';
          _cardType = profileProvider.getKycModel?.kycDetails?.cardType ?? '';
          if (profileProvider.getKycModel?.kycDetails?.status == 'REJECTED' ||
              profileProvider.getKycModel?.kycDetails?.status == 'VERIFIED' ||
              profileProvider.getKycModel?.kycDetails?.status == 'PENDING') {
            setState(() {
              fieldEnabled = false;
            });
          }
        }
      });
    }

    super.initState();
  }

  late Future _fetchKYC;
  @override
  Widget build(BuildContext context) {
    final sizeh = MediaQuery.of(context).size.height;
    final sizew = MediaQuery.of(context).size.width;
    Locale myLocale = EasyLocalization.of(
      context,
    )!
        .locale;
    final appProvider = Provider.of<AppProvider>(context);
    final space = SizedBox(
      height: sizeh * .005,
    );
    final profileProvider = Provider.of<Profileprovider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      backgroundColor: HexColor('FCFCFC'),
      body: isNoTenant == true
          ? Container(
              padding: EdgeInsets.symmetric(
                  horizontal: sizew * .035, vertical: sizeh * .015),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
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
                        LocaleKeys.kyc_ver.tr(),
                        style: AppTextStyles.semiBold.copyWith(
                            fontSize: 16.sp,
                            fontFamily: 'Inter',
                            color: primaryColor),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: sizeh * .1,
                  ),
                  Center(
                    child: Text('Please Select Tenant!'),
                  ),
                ],
              ),
            )
          : FutureBuilder(
              future: _fetchKYC,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return LoaderWidget();
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }
                if (snapshot.hasData) {
                  if (snapshot.data is Failure) {
                    if (snapshot.data.toString().contains('401')) {
                      authProvider.logout(context);
                      UIHelper.showNotification(
                        'Session Expired',
                      );
                    }

                    return Center(child: TextWidget(snapshot.data.toString()));
                  }

                  //
                  //  print("snapshot data is ${snapshot.data}");
                  return Form(
                    key: formKey,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: sizew * .025, vertical: sizeh * .015),
                      child: SingleChildScrollView(
                        child: fieldEnabled == false
                            ? Column(
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
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: sizew * .01,
                                              vertical: sizeh * .005),
                                          child: Icon(Icons.arrow_back,
                                              color: yallewTextColor),
                                        ),
                                      ),
                                      SizedBox(
                                        width: sizew * .02,
                                      ),
                                      Text(
                                        LocaleKeys.kyc_ver.tr(),
                                        style: AppTextStyles.semiBold.copyWith(
                                            fontSize: 16.sp,
                                            color: primaryColor),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: sizeh * .035,
                                  ),
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                      horizontal: sizew * .025,
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: sizew * .04,
                                        vertical: sizeh * .015),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.white,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        buildRowText(
                                            LocaleKeys.name.tr(),
                                            profileProvider.getKycModel
                                                    ?.kycDetails?.fullName ??
                                                ''),
                                        SizedBox(
                                          height: sizeh * .016,
                                        ),
                                        buildRowText(
                                            LocaleKeys.national_id.tr(), '',
                                            widget: buildContainer(
                                                text: 'Submitted',
                                                textColor: HexColor('#38B000'),
                                                bgColor: HexColor('#DEFFC3')
                                                    .withOpacity(.28))),
                                        SizedBox(
                                          height: sizeh * .016,
                                        ),
                                        buildRowText(
                                            LocaleKeys.proof_document.tr(), '',
                                            widget: buildContainer(
                                                text: 'Uploaded',
                                                textColor: HexColor('#38B000'),
                                                bgColor: HexColor('#DEFFC3')
                                                    .withOpacity(.28))),
                                        SizedBox(
                                          height: sizeh * .016,
                                        ),
                                        buildRowText(LocaleKeys.status.tr(), '',
                                            widget: buildContainer(
                                                text: profileProvider
                                                        .getKycModel
                                                        ?.kycDetails
                                                        ?.status ??
                                                    '',
                                                textColor: HexColor('#757575'),
                                                bgColor: HexColor('#A6A6A5')
                                                    .withOpacity(.28))),
                                      ],
                                    ),
                                  )
                                ],
                              )
                            : Column(
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
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: sizew * .01,
                                              vertical: sizeh * .005),
                                          child: Icon(Icons.arrow_back,
                                              color: yallewTextColor),
                                        ),
                                      ),
                                      SizedBox(
                                        width: sizew * .02,
                                      ),
                                      Text(
                                        LocaleKeys.kyc_ver.tr(),
                                        style: AppTextStyles.semiBold.copyWith(
                                            fontSize: 16.sp,
                                            color: primaryColor),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: sizeh * .035,
                                  ),
                                  authProvider.tenantID == null
                                      ? SizedBox(
                                          height: sizeh * .5,
                                          child: Center(
                                            child: Text('Please Select Tenant'),
                                          ),
                                        )
                                      : Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: sizew * .04),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              profileProvider.getKycModel
                                                          ?.kycDetails ==
                                                      null
                                                  ? SizedBox()
                                                  : Padding(
                                                      padding: EdgeInsets.only(
                                                          bottom: sizeh * .02),
                                                      child: Row(
                                                        children: [
                                                          Text('KYC Status:',
                                                              style: AppTextStyles
                                                                  .regular
                                                                  .copyWith(
                                                                      fontSize:
                                                                          12.sp,
                                                                      color:
                                                                          primaryColor)),
                                                          SizedBox(
                                                              width:
                                                                  sizew * .02),
                                                          Text(
                                                              profileProvider
                                                                      .getKycModel
                                                                      ?.kycDetails
                                                                      ?.status ??
                                                                  '',
                                                              style: AppTextStyles
                                                                  .regular
                                                                  .copyWith(
                                                                      fontSize:
                                                                          12.sp,
                                                                      color:
                                                                          primaryColor)),
                                                        ],
                                                      ),
                                                    ),
                                              CustomField(
                                                  errorText:
                                                      'Please enter your name',
                                                  hint: AppTextStyles.regular
                                                      .copyWith(
                                                          fontSize: 9.sp,
                                                          fontFamily: 'Inter',
                                                          color: HexColor(
                                                              '#8F94A3')),
                                                  isCustomField: true,
                                                  enabled: fieldEnabled,
                                                  labelColor: primaryColor,
                                                  disabledBorder: primaryColor,
                                                  hintText:
                                                      LocaleKeys.full_name.tr(),
                                                  title:
                                                      LocaleKeys.full_name.tr(),
                                                  hintSize: 1,
                                                  controller:
                                                      fullNameController),
                                              space,
                                              InkWell(
                                                onTap: fieldEnabled == false
                                                    ? null
                                                    : () {
                                                        _selectDate(context);
                                                      },
                                                child: CustomField(
                                                    errorText:
                                                        'Please enter your date of birth',
                                                    hint: AppTextStyles.regular
                                                        .copyWith(
                                                            fontSize: 9.sp,
                                                            color: HexColor(
                                                                '#8F94A3'),
                                                            fontFamily:
                                                                'Inter'),
                                                    isCustomField: true,
                                                    labelColor: primaryColor,
                                                    disabledBorder:
                                                        primaryColor,
                                                    enabled: false,
                                                    hintText:
                                                        LocaleKeys.dob.tr(),
                                                    title: LocaleKeys.dob.tr(),
                                                    widget: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
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
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    LocaleKeys.type_of_card
                                                        .tr(),
                                                    style: AppTextStyles.medium
                                                        .copyWith(
                                                      fontSize: 13.sp,
                                                      color:
                                                          HexColor('#2A2D36'),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                      height: sizeh * 0.01),
                                                  DropdownSearch<String>(
                                                    enabled: fieldEnabled,
                                                    validator: (value) {
                                                      if (value?.isEmpty ??
                                                          true) {
                                                        return 'Please enter type';
                                                      }

                                                      return null;
                                                    },
                                                    selectedItem: _cardType,
                                                    popupProps:
                                                        const PopupProps.menu(
                                                      showSearchBox: true,
                                                      showSelectedItems: true,
                                                    ),
                                                    items: cardTypeList
                                                        .map((item) {
                                                      return item.title;
                                                    }).toList(),
                                                    dropdownDecoratorProps:
                                                        DropDownDecoratorProps(
                                                      baseStyle: AppTextStyles
                                                          .regular
                                                          .copyWith(
                                                              fontSize: 12.sp,
                                                              color:
                                                                  primaryColor),
                                                      dropdownSearchDecoration:
                                                          InputDecoration(
                                                        fillColor: Colors.white,
                                                        filled: true,
                                                        alignLabelWithHint:
                                                            true,
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: HexColor(
                                                                  '#E2E8F0'),
                                                              width: 1),
                                                        ),
                                                        disabledBorder:
                                                            OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: HexColor(
                                                                  '#E2E8F0'),
                                                              width: 1),
                                                        ),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: HexColor(
                                                                  '#E2E8F0'),
                                                              width: 1),
                                                        ),
                                                        //create border with borderRadius
                                                        border:
                                                            OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: HexColor(
                                                                  '#E2E8F0'),
                                                              width: 1),
                                                        ),
                                                        errorBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colors
                                                                      .red,
                                                                  width: 1),
                                                        ),

                                                        hintStyle: AppTextStyles
                                                            .regular
                                                            .copyWith(
                                                                fontSize: 9.sp,
                                                                color: HexColor(
                                                                    '#8F94A3')),
                                                        hintText: LocaleKeys
                                                            .type_of_card
                                                            .tr(),
                                                        // label: Text(
                                                        //   LocaleKeys.type_of_card
                                                        //       .tr(),
                                                        // ),
                                                        // labelStyle: AppTextStyles
                                                        //     .regular
                                                        //     .copyWith(
                                                        //         fontSize: 12.sp,
                                                        //         color: primaryColor),
                                                      ),
                                                    ),
                                                    onChanged: (newValue) {
                                                      setState(() {
                                                        cardTypeList
                                                            .forEach((element) {
                                                          element.title ==
                                                                  newValue
                                                              ? _myType =
                                                                  element.id
                                                              : '';
                                                          print(_myType);
                                                        });

                                                        // print(_myType);
                                                        _cardType = newValue;
                                                      });
                                                    },
                                                  ),
                                                ],
                                              ),
                                              space,
                                              space,
                                              space,
                                              space,
                                              space,
                                              CustomField(
                                                  errorText:
                                                      'Please enter your card ID',
                                                  hint: AppTextStyles.regular
                                                      .copyWith(
                                                          fontSize: 9.sp,
                                                          color: HexColor(
                                                              '#8F94A3'),
                                                          fontFamily: 'Inter'),
                                                  isCustomField: true,
                                                  enabled: fieldEnabled,
                                                  labelColor: primaryColor,
                                                  disabledBorder: primaryColor,
                                                  hintText: LocaleKeys
                                                      .card_holder_id
                                                      .tr(),
                                                  title: LocaleKeys
                                                      .card_holder_id
                                                      .tr(),
                                                  hintSize: 1,
                                                  controller: cardIDController),
                                              space,
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    LocaleKeys.country_residence
                                                        .tr(),
                                                    style: AppTextStyles.medium
                                                        .copyWith(
                                                      fontSize: 13.sp,
                                                      color:
                                                          HexColor('#2A2D36'),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                      height: sizeh * 0.01),
                                                  DropdownSearch<String>(
                                                    enabled: fieldEnabled,
                                                    validator: (value) {
                                                      if (value?.isEmpty ??
                                                          true) {
                                                        return 'Please enter country';
                                                      }

                                                      return null;
                                                    },
                                                    selectedItem: _country,
                                                    popupProps:
                                                        const PopupProps.menu(
                                                      showSearchBox: true,
                                                      showSelectedItems: true,
                                                    ),
                                                    items: appProvider
                                                        .countryList
                                                        .map((item) {
                                                      return myLocale
                                                                  .languageCode ==
                                                              'en'
                                                          ? item.nameEn ?? ''
                                                          : item.nameAr ?? '';
                                                    }).toList(),
                                                    dropdownDecoratorProps:
                                                        DropDownDecoratorProps(
                                                      baseStyle: AppTextStyles
                                                          .regular
                                                          .copyWith(
                                                              fontSize: 12.sp,
                                                              fontFamily:
                                                                  'Inter',
                                                              color:
                                                                  primaryColor),
                                                      dropdownSearchDecoration:
                                                          InputDecoration(
                                                        fillColor: Colors.white,
                                                        filled: true,
                                                        alignLabelWithHint:
                                                            true,
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: HexColor(
                                                                  '#E2E8F0'),
                                                              width: 1),
                                                        ),
                                                        disabledBorder:
                                                            OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: HexColor(
                                                                  '#E2E8F0'),
                                                              width: 1),
                                                        ),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: HexColor(
                                                                  '#E2E8F0'),
                                                              width: 1),
                                                        ),
                                                        //create border with borderRadius
                                                        border:
                                                            OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: HexColor(
                                                                  '#E2E8F0'),
                                                              width: 1),
                                                        ),
                                                        errorBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colors
                                                                      .red,
                                                                  width: 1),
                                                        ),

                                                        hintStyle: AppTextStyles
                                                            .regular
                                                            .copyWith(
                                                                fontSize: 9.sp,
                                                                color: HexColor(
                                                                    '#8F94A3')),
                                                        hintText: LocaleKeys
                                                            .country_residence
                                                            .tr(),
                                                        // label: Text(
                                                        //   LocaleKeys.type_of_card
                                                        //       .tr(),
                                                        // ),
                                                        // labelStyle: AppTextStyles
                                                        //     .regular
                                                        //     .copyWith(
                                                        //         fontSize: 12.sp,
                                                        //         color: primaryColor),
                                                      ),
                                                    ),
                                                    onChanged: (newValue) {
                                                      setState(() {
                                                        appProvider.countryList
                                                            .forEach((element) {
                                                          myLocale.languageCode ==
                                                                  'en'
                                                              ? element.nameEn
                                                              : element.nameAr ==
                                                                      newValue
                                                                  ? _myCountry =
                                                                      element.id
                                                                  : '';
                                                          print(_myCountry);
                                                        });

                                                        // print(_myType);
                                                        _country = newValue;
                                                      });
                                                    },
                                                  ),
                                                ],
                                              ),
                                              space,
                                              space,
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    LocaleKeys.address.tr(),
                                                    style: AppTextStyles.medium
                                                        .copyWith(
                                                      fontSize: 13.sp,
                                                      color:
                                                          HexColor('#2A2D36'),
                                                      fontFamily: 'Inter',
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: sizeh * 0.01,
                                                  ),
                                                  TextFormField(
                                                    enabled: fieldEnabled,
                                                    controller:
                                                        adressController,
                                                    validator: (value) {
                                                      if (value!.isEmpty) {
                                                        return 'Please enter  your address';
                                                      }

                                                      return null;
                                                    },
                                                    maxLines: 5,
                                                    style: AppTextStyles.regular
                                                        .copyWith(
                                                            fontSize: 12.sp,
                                                            fontFamily: 'Inter',
                                                            color:
                                                                primaryColor),
                                                    decoration: InputDecoration(
                                                        hintText:
                                                            'e.g. Al-Irsal St., Ramallah, Palestine',
                                                        fillColor: Colors.white,
                                                        hintStyle: AppTextStyles
                                                            .regular
                                                            .copyWith(
                                                                fontSize: 9.sp,
                                                                color: HexColor(
                                                                    '#8F94A3')),
                                                        filled: true,
                                                        contentPadding:
                                                            EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        16,
                                                                    vertical:
                                                                        2),
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: HexColor(
                                                                  '#E2E8F0'),
                                                              width: 1),
                                                        ),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: HexColor(
                                                                  '#E2E8F0'),
                                                              width: 1),
                                                        ),
                                                        disabledBorder:
                                                            OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: HexColor(
                                                                  '#E2E8F0'),
                                                              width: 1),
                                                        ),
                                                        errorBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colors
                                                                      .red,
                                                                  width: 1),
                                                        )),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: sizeh * .01,
                                              ),
                                              Text(LocaleKeys.upload_id.tr(),
                                                  style: AppTextStyles.regular
                                                      .copyWith(
                                                          fontSize: 12.sp,
                                                          fontFamily: 'Inter',
                                                          color: primaryColor)),
                                              space,
                                              space,
                                              imageResult == null
                                                  ? InkWell(
                                                      onTap: setImage,
                                                      child: Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    sizew * .03,
                                                                vertical:
                                                                    sizeh *
                                                                        .015),
                                                        decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            border: DashedBorder
                                                                .fromBorderSide(
                                                                    dashLength:
                                                                        10,
                                                                    side: BorderSide(
                                                                        color: HexColor(
                                                                            '#E2E8F0'),
                                                                        width:
                                                                            1)),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            5))),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              LocaleKeys
                                                                  .click_to_upload
                                                                  .tr(),
                                                              style: AppTextStyles
                                                                  .regular
                                                                  .copyWith(
                                                                      fontSize:
                                                                          10.sp,
                                                                      color: Color(
                                                                          0xFFA6A6A6)),
                                                            ),
                                                            SizedBox(
                                                              width:
                                                                  sizew * .01,
                                                            ),
                                                            SvgPicture.asset(
                                                                fileUpload)
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                  : Column(
                                                      children: [
                                                        SizedBox(
                                                          height: sizeh * .015,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                profileProvider
                                                                            .getKycModel
                                                                            ?.kycDetails !=
                                                                        null
                                                                    ? Image
                                                                        .network(
                                                                        '$downloadPhoto/$imageResult',
                                                                        height: sizeh *
                                                                            .025,
                                                                        width: sizew *
                                                                            .1,
                                                                      )
                                                                    : SvgPicture
                                                                        .asset(
                                                                            taskDoneIcon),
                                                                SizedBox(
                                                                  width: sizew *
                                                                      .02,
                                                                ),
                                                                SizedBox(
                                                                    width:
                                                                        sizew *
                                                                            .65,
                                                                    child: Text(
                                                                        imageResult ??
                                                                            '',
                                                                        style: AppTextStyles.regular.copyWith(
                                                                            fontSize:
                                                                                7.5.sp,
                                                                            color: primaryColor))),
                                                              ],
                                                            ),
                                                            profileProvider
                                                                            .getKycModel
                                                                            ?.kycDetails
                                                                            ?.status ==
                                                                        'VERIFIED' ||
                                                                    profileProvider
                                                                            .getKycModel
                                                                            ?.kycDetails
                                                                            ?.status ==
                                                                        'REJECTED'
                                                                ? SizedBox()
                                                                : InkWell(
                                                                    onTap: () {
                                                                      setImage();
                                                                    },
                                                                    child: SvgPicture
                                                                        .asset(
                                                                      edit,
                                                                      color:
                                                                          primaryColor,
                                                                    )),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: sizeh * .025,
                                                        )
                                                      ],
                                                    ),
                                            ],
                                          ),
                                        ),
                                  SizedBox(
                                    height: sizeh * .02,
                                  ),
                                  SizedBox(
                                    height: sizeh * .015,
                                  ),
                                  authProvider.tenantID == null
                                      ? SizedBox()
                                      : profileProvider.getKycModel?.kycDetails
                                                      ?.status ==
                                                  'VERIFIED' ||
                                              profileProvider.getKycModel
                                                      ?.kycDetails?.status ==
                                                  'REJECTED'
                                          ? SizedBox()
                                          : Align(
                                              alignment: Alignment.centerRight,
                                              child: ButtonWidget(
                                                buttonColor:
                                                    HexColor('#2A2D36'),
                                                radius: 8,
                                                textStyle: AppTextStyles.medium
                                                    .copyWith(
                                                        fontSize: 10.sp,
                                                        fontFamily: 'Inter',
                                                        color: Colors.white),
                                                height: sizeh * .047,
                                                width: sizew * .52,
                                                text: LocaleKeys
                                                    .submit_verification
                                                    .tr(),
                                                onPress: imageResult == null
                                                    ? () {
                                                        final isVaild = formKey
                                                            .currentState!
                                                            .validate();

                                                        UIHelper.showNotification(
                                                            LocaleKeys
                                                                .please_upload_photo
                                                                .tr());
                                                        if (isVaild) {}
                                                      }
                                                    : () {
                                                        final isVaild = formKey
                                                            .currentState!
                                                            .validate();
                                                        if (isVaild) {
                                                          loadingDialog(
                                                              context);
                                                          profileProvider
                                                              .sendKyc(
                                                                  kycRequestModel:
                                                                      KYCRequestModel(
                                                            fullName:
                                                                fullNameController
                                                                    .text,
                                                            dateOfBirth:
                                                                dobController
                                                                    .text,
                                                            cardType: 'ID_CARD',
                                                            cardHolderId:
                                                                cardIDController
                                                                    .text,
                                                            cardImage:
                                                                imageResult,
                                                          ))
                                                              .then((value) {
                                                            Navigator.pop(
                                                                context);
                                                            if (value == true) {
                                                              UIHelper.showNotification(
                                                                  LocaleKeys
                                                                      .uploaded_successfully
                                                                      .tr(),
                                                                  backgroundColor:
                                                                      Colors
                                                                          .green);
                                                              Navigator.pop(
                                                                  context);
                                                            }
                                                          });
                                                        }
                                                      },
                                              ),
                                            ),
                                  SizedBox(
                                    height: sizeh * .02,
                                  ),
                                ],
                              ),
                      ),
                    ),
                  );
                }
                return Container();
              },
            ),
    );
  }

  Widget buildRowText(String text, String value, {Widget? widget}) {
    final sizew = MediaQuery.of(context).size.width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: sizew * .52,
          child: Text(text,
              style: AppTextStyles.medium.copyWith(
                  fontFamily: 'Inter',
                  fontSize: 12.sp,
                  color: HexColor('#2A2D36'))),
        ),
        widget ??
            Text(value,
                style: AppTextStyles.regular.copyWith(
                    fontFamily: 'Inter',
                    fontSize: 11.sp,
                    color: HexColor('#8F94A3'))),
      ],
    );
  }

  Widget buildContainer(
      {required String text,
      required Color textColor,
      required Color bgColor}) {
    final sizeh = MediaQuery.of(context).size.height;
    final sizew = MediaQuery.of(context).size.width;
    return Container(
      width: sizew * .3,
      height: sizeh * .04,
      decoration: BoxDecoration(
        border: Border.all(
          color: textColor,
          width: 2,
        ),
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Center(
        child: Text(
          text,
          style: AppTextStyles.regular.copyWith(
            fontSize: 11.sp,
            color: textColor,
          ),
        ),
      ),
    );
  }
}

class KYCCardType {
  String id;
  String title;
  KYCCardType({required this.id, required this.title});
}
