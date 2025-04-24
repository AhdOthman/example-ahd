import 'package:dropdown_search/dropdown_search.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:subrate/api_url.dart';
import 'package:subrate/models/kyc/send_kyc_request_model.dart';
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
              profileProvider.getKycModel?.kycDetails?.status == 'VERIFIED') {
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
    final space = SizedBox(
      height: sizeh * .02,
    );
    final profileProvider = Provider.of<Profileprovider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: isNoTenant == true
          ? Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
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
                                      fontSize: 16.sp, color: primaryColor),
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
                                        profileProvider
                                                    .getKycModel?.kycDetails ==
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
                                                                fontSize: 12.sp,
                                                                color:
                                                                    primaryColor)),
                                                    SizedBox(
                                                        width: sizew * .02),
                                                    Text(
                                                        profileProvider
                                                                .getKycModel
                                                                ?.kycDetails
                                                                ?.status ??
                                                            '',
                                                        style: AppTextStyles
                                                            .regular
                                                            .copyWith(
                                                                fontSize: 12.sp,
                                                                color:
                                                                    primaryColor)),
                                                  ],
                                                ),
                                              ),
                                        CustomField(
                                            enabled: fieldEnabled,
                                            labelColor: primaryColor,
                                            disabledBorder: primaryColor,
                                            hintText: LocaleKeys.full_name.tr(),
                                            title: LocaleKeys.full_name.tr(),
                                            hintSize: 1,
                                            controller: fullNameController),
                                        space,
                                        InkWell(
                                          onTap: fieldEnabled == false
                                              ? null
                                              : () {
                                                  _selectDate(context);
                                                },
                                          child: CustomField(
                                              labelColor: primaryColor,
                                              disabledBorder: primaryColor,
                                              enabled: false,
                                              hintText: LocaleKeys.dob.tr(),
                                              title: LocaleKeys.dob.tr(),
                                              widget: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
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
                                        space,
                                        DropdownSearch<String>(
                                          enabled: fieldEnabled,
                                          validator: (value) {
                                            if (value?.isEmpty ?? true) {
                                              return 'Please enter type';
                                            }

                                            return null;
                                          },
                                          selectedItem: _cardType,
                                          popupProps: const PopupProps.menu(
                                            showSearchBox: true,
                                            showSelectedItems: true,
                                          ),
                                          items: cardTypeList.map((item) {
                                            return item.title;
                                          }).toList(),
                                          dropdownDecoratorProps:
                                              DropDownDecoratorProps(
                                            baseStyle: AppTextStyles.regular
                                                .copyWith(
                                                    fontSize: 12.sp,
                                                    color: primaryColor),
                                            dropdownSearchDecoration:
                                                InputDecoration(
                                              alignLabelWithHint: true,
                                              enabledBorder:
                                                  const UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: primaryColor,
                                                          width: 1)),
                                              disabledBorder:
                                                  const UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: primaryColor,
                                                    width: 1),
                                              ),
                                              focusedBorder:
                                                  const UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: primaryColor,
                                                    width: 1),
                                              ),
                                              //create border with borderRadius
                                              border:
                                                  const UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: primaryColor,
                                                    width: 1),
                                              ),

                                              hintStyle: TextStyle(
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.w500,
                                                  color: primaryColor),
                                              hintText:
                                                  LocaleKeys.type_of_card.tr(),
                                              label: Text(
                                                LocaleKeys.type_of_card.tr(),
                                              ),
                                              labelStyle: AppTextStyles.regular
                                                  .copyWith(
                                                      fontSize: 12.sp,
                                                      color: primaryColor),
                                            ),
                                          ),
                                          onChanged: (newValue) {
                                            setState(() {
                                              cardTypeList.forEach((element) {
                                                element.title == newValue
                                                    ? _myType = element.id
                                                    : '';
                                                print(_myType);
                                              });

                                              // print(_myType);
                                              _cardType = newValue;
                                            });
                                          },
                                        ),
                                        space,
                                        space,
                                        CustomField(
                                            enabled: fieldEnabled,
                                            labelColor: primaryColor,
                                            disabledBorder: primaryColor,
                                            hintText:
                                                LocaleKeys.card_holder_id.tr(),
                                            title:
                                                LocaleKeys.card_holder_id.tr(),
                                            hintSize: 1,
                                            controller: cardIDController),
                                        space,
                                        SizedBox(
                                          height: sizeh * .01,
                                        ),
                                        Text(LocaleKeys.upload_id.tr(),
                                            style: AppTextStyles.regular
                                                .copyWith(
                                                    fontSize: 12.sp,
                                                    color: primaryColor)),
                                        space,
                                        imageResult == null
                                            ? InkWell(
                                                onTap: setImage,
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: sizew * .03,
                                                      vertical: sizeh * .015),
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      border: DashedBorder
                                                          .fromBorderSide(
                                                              dashLength: 10,
                                                              side: BorderSide(
                                                                  color: Colors
                                                                      .black,
                                                                  width: 1)),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  5))),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      SvgPicture.asset(
                                                          documentUpload),
                                                      SizedBox(
                                                          width: sizew * .02),
                                                      Text(
                                                        LocaleKeys
                                                            .click_to_upload
                                                            .tr(),
                                                        style: AppTextStyles
                                                            .regular
                                                            .copyWith(
                                                                fontSize: 11.sp,
                                                                color: Color(
                                                                    0xFFA6A6A6)),
                                                      )
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
                                                              ? Image.network(
                                                                  '$downloadPhoto/$imageResult',
                                                                  height:
                                                                      sizeh *
                                                                          .025,
                                                                  width: sizew *
                                                                      .1,
                                                                )
                                                              : SvgPicture.asset(
                                                                  taskDoneIcon),
                                                          SizedBox(
                                                            width: sizew * .02,
                                                          ),
                                                          SizedBox(
                                                              width:
                                                                  sizew * .65,
                                                              child: Text(
                                                                  imageResult ??
                                                                      '',
                                                                  style: AppTextStyles
                                                                      .regular
                                                                      .copyWith(
                                                                          fontSize: 7.5
                                                                              .sp,
                                                                          color:
                                                                              primaryColor))),
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
                                                                  .asset(edit)),
                                                    ],
                                                  ),
                                                  // profileProvider.getKycModel
                                                  //             ?.kycDetails !=
                                                  //         null
                                                  //     ? Column(
                                                  //         children: [
                                                  //           SizedBox(
                                                  //             height: sizeh * .015,
                                                  //           ),

                                                  //         ],
                                                  //       )
                                                  //     : SizedBox(),
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
                              height: sizeh * .035,
                            ),
                            authProvider.tenantID == null
                                ? SizedBox()
                                : profileProvider.getKycModel?.kycDetails
                                                ?.status ==
                                            'VERIFIED' ||
                                        profileProvider.getKycModel?.kycDetails
                                                ?.status ==
                                            'REJECTED'
                                    ? SizedBox()
                                    : Center(
                                        child: ButtonWidget(
                                          radius: 5,
                                          textStyle: AppTextStyles.regular
                                              .copyWith(
                                                  fontSize: 12.5.sp,
                                                  color: Colors.white),
                                          height: sizeh * .05,
                                          width: sizew * .45,
                                          text: LocaleKeys.update.tr(),
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
                                                    loadingDialog(context);
                                                    profileProvider
                                                        .sendKyc(
                                                            kycRequestModel:
                                                                KYCRequestModel(
                                                      fullName:
                                                          fullNameController
                                                              .text,
                                                      dateOfBirth:
                                                          dobController.text,
                                                      cardType: 'ID_CARD',
                                                      cardHolderId:
                                                          cardIDController.text,
                                                      cardImage: imageResult,
                                                    ))
                                                        .then((value) {
                                                      Navigator.pop(context);
                                                      if (value == true) {
                                                        UIHelper.showNotification(
                                                            LocaleKeys
                                                                .uploaded_successfully
                                                                .tr(),
                                                            backgroundColor:
                                                                Colors.green);
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
                  );
                }
                return Container();
              },
            ),
    );
  }
}

class KYCCardType {
  String id;
  String title;
  KYCCardType({required this.id, required this.title});
}
