import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:subrate/models/app/choicess.dart';
import 'package:subrate/provider/appprovider.dart';
import 'package:subrate/provider/authprovider.dart';
import 'package:subrate/provider/walletprovider.dart';
import 'package:subrate/routers/routers.dart';
import 'package:subrate/theme/app_colors.dart';
import 'package:subrate/theme/assets_managet.dart';
import 'package:subrate/theme/failure.dart';
import 'package:subrate/theme/text_style.dart';
import 'package:subrate/theme/ui_helper.dart';
import 'package:subrate/translations/locale_keys.g.dart';
import 'package:subrate/widgets/app/button.dart';
import 'package:subrate/widgets/app/loadingdialog.dart';
import 'package:subrate/widgets/app/text_widget.dart';
import 'package:subrate/widgets/appskeleton/wallet_skeleton.dart';
import 'package:subrate/widgets/wallet/payment_method_card.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart' as svg;

class WalletScreen extends StatefulWidget {
  static const routeName = 'wallet-screen';
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  bool isPayment = false;
  // List<Choicess> choices = [
  //   Choicess(clicked: false, name: 'Bank Account', value: 1, choiceImage: ''),
  //   Choicess(clicked: false, name: 'Jawwal pay', value: 2, choiceImage: ''),
  //   Choicess(clicked: false, name: 'Palpay', value: 2, choiceImage: ''),
  // ];
  bool isShownPayment = false;
  String? paymentValue;
  void clickedItem(int index) {
    final walletProvider = Provider.of<WalletProvider>(context, listen: false);

    walletProvider.traineePaymentMethodList
        .map((e) => e.isClicked = false)
        .toList();

    setState(() {
      paymentValue = walletProvider.traineePaymentMethodList[index].id;
      for (int i = 0; i < walletProvider.traineePaymentMethodList.length; i++) {
        walletProvider.traineePaymentMethodList[i].isClicked =
            i == index; // Set clicked for the selected index
      }
    });
  }

  void clickedItemPay(int index) {
    final walletProvider = Provider.of<WalletProvider>(context, listen: false);
    walletProvider.accountsPayoutList.map((e) => e.isClicked = false).toList();

    setState(() {
      paymentValue = walletProvider.accountsPayoutList[index].id;
      walletProvider.accountsPayoutList[index].isClicked =
          !(walletProvider.accountsPayoutList[index].isClicked ?? false);
    });
  }

  Future _getWallet() async {
    final walletProvider = Provider.of<WalletProvider>(context, listen: false);
    return await walletProvider.getWallet();
  }

  Future _getTraineePaymentMethod() async {
    final walletProvider = Provider.of<WalletProvider>(context, listen: false);
    return await walletProvider.getTraineePaymentMethod();
  }

  Future _getPayouts() async {
    final walletProvider = Provider.of<WalletProvider>(context, listen: false);
    return await walletProvider.getPayoutHistory();
  }

  void logout() async {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final Routers routers = Routers();
    authProvider.token = null;
    authProvider.userName = null;
    appProvider.selectedIndex = 0;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userTenant');
    await prefs.remove('userData');
    authProvider.tenantID = null;
    routers.navigateToSigninScreen(context);
  }

  @override
  void initState() {
    _fetcheAllData = Future.wait([
      _getWallet(),
      _getPayouts(),
      _getTraineePaymentMethod(),
    ]);

    super.initState();
  }

  late Future _fetcheAllData;

  List<Choicess> accountes = [
    Choicess(
        clicked: false,
        name: LocaleKeys.bank.tr(),
        value: 1,
        choiceImage: bankCard,
        subTitle: 'PS** *** **** *56'),
    Choicess(
        clicked: false,
        name: 'PayPal',
        value: 1,
        choiceImage: paypal,
        subTitle: 'othmanahd@gmail.com'),
  ];

  Future<void> showCustomBottomSheet({
    required Widget child,
    bool showDragHandle = true,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showDragHandle)
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            child,
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sizeh = MediaQuery.of(context).size.height;
    final sizew = MediaQuery.of(context).size.width;
    final authProvider = Provider.of<AuthProvider>(context);
    final walletProvider = Provider.of<WalletProvider>(context);
    final appProvider = Provider.of<AppProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: _fetcheAllData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return WalletSkeleton();
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          if (snapshot.hasData) {
            if (snapshot.data is Failure) {
              if (snapshot.data.toString().contains('401')) {
                logout();
                UIHelper.showNotification(
                  'Session Expired',
                );
              }
              return Center(child: TextWidget(snapshot.data.toString()));
            }

            //
            //  print("snapshot data is ${snapshot.data}");
            return Container(
              padding: EdgeInsets.symmetric(
                  horizontal: sizew * .035, vertical: sizeh * .015),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: sizeh * .06),
                    Text(
                      LocaleKeys.wallet.tr(),
                      style: AppTextStyles.semiBold
                          .copyWith(fontSize: 17.sp, color: primaryColor),
                    ),
                    SizedBox(height: sizeh * .035),
                    authProvider.tenantID == null
                        ? Center(
                            child: Text('Please Select Tenant'),
                          )
                        : Column(
                            children: [
                              _buildInfoBox(
                                points: walletProvider.totalPoints.toString(),
                                amount:
                                    '${walletProvider.totalMoney.toStringAsFixed(2)}\$',
                                onPayoutRequest: walletProvider
                                        .traineePaymentMethodList.isEmpty
                                    ? () {
                                        UIHelper.showNotification(
                                            LocaleKeys.please_add_payout.tr());
                                      }
                                    : walletProvider.totalPoints == 0
                                        ? () {
                                            showCustomBottomSheet(
                                                child: buildDialog());

                                            UIHelper.showNotification(
                                                'You have no points to pay');
                                          }
                                        : () {
                                            walletProvider
                                                .traineePaymentMethodList
                                                .map((e) => e.isClicked = false)
                                                .toList();
                                            paymentValue = null;

                                            showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  buildDialog(),
                                            );

                                            // Handle payout request
                                          },
                              ),
                              SizedBox(height: sizeh * .025),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    LocaleKeys.payout_history.tr(),
                                    style: AppTextStyles.bold.copyWith(
                                        fontSize: 14.sp,
                                        color: textPrimaryColor),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: sizeh * .02,
                              ),
                              FutureBuilder(
                                future: _fetcheAllData,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return SizedBox(
                                      height: sizeh * .5,
                                      child: const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    );
                                  }
                                  if (snapshot.hasError) {
                                    return Center(
                                      child: Text('Error: ${snapshot.error}'),
                                    );
                                  }
                                  if (snapshot.hasData) {
                                    if (snapshot.data is Failure) {
                                      return Center(
                                          child: TextWidget(
                                              snapshot.data.toString()));
                                    }
                                    final provider =
                                        Provider.of<WalletProvider>(context);

                                    var getPayouts = provider.payoutHistoryList;
                                    return getPayouts.isNotEmpty
                                        ? Container(
                                            margin: EdgeInsets.symmetric(
                                              horizontal: sizew * .008,
                                            ),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: sizew * .02,
                                                vertical: sizeh * .0),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              color: Colors.white,
                                            ),
                                            child: ListView.builder(
                                                itemCount: getPayouts.length,
                                                shrinkWrap: true,
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                padding: EdgeInsets.zero,
                                                itemBuilder: (context, index) {
                                                  return payoutRequestCard(
                                                    time: DateFormat('h:mm a')
                                                        .format(DateTime.parse(
                                                            getPayouts[index]
                                                                    .createdAt ??
                                                                '')),
                                                    date: appProvider.dateFormat
                                                        .format(DateTime.parse(
                                                            getPayouts[index]
                                                                    .createdAt ??
                                                                '')),
                                                    status: getPayouts[index]
                                                            .status ??
                                                        '',
                                                    points: getPayouts[index]
                                                        .points
                                                        .toString(),
                                                  );
                                                }),
                                          )
                                        : SizedBox(
                                            height: 14.h,
                                            child: Center(
                                              child: Column(
                                                children: [
                                                  SizedBox(
                                                    height: sizeh * .06,
                                                  ),
                                                  // Text(
                                                  //   LocaleKeys.empty_wallet
                                                  //       .tr(),
                                                  //   style: AppTextStyles.regular
                                                  //       .copyWith(
                                                  //           fontSize: 10.sp,
                                                  //           color: HexColor(
                                                  //               '#939090')),
                                                  // ),
                                                  // SizedBox(
                                                  //   height: sizeh * .02,
                                                  // ),
                                                  // Text(
                                                  //   LocaleKeys.no_credits.tr(),
                                                  //   style: AppTextStyles.regular
                                                  //       .copyWith(
                                                  //           fontSize: 9.5.sp,
                                                  //           color: HexColor(
                                                  //               '#939090')),
                                                  // ),
                                                  SvgPicture.asset(emptyWallet,
                                                      height: sizeh * .065),
                                                ],
                                              ),
                                            ),
                                          );
                                  }
                                  return Container();
                                },
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            );
          }
          return Container();
        },
      ),
    );
  }

  Widget _buildInfoBox({
    required String points,
    required String amount,
    required Function onPayoutRequest,
  }) {
    final sizeh = MediaQuery.of(context).size.height;
    final sizew = MediaQuery.of(context).size.width;
    return Container(
      height: sizeh * .2,
      // Increase height to avoid overflow
      decoration: BoxDecoration(
        image: DecorationImage(image: svg.Svg(walletB), fit: BoxFit.fill),
        color: Color(0xFF23262F),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Left side: points and amount
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LocaleKeys.available_points.tr(),
                      style: AppTextStyles.medium.copyWith(
                        fontSize: 12.sp,
                        color: yellowButtonsColor,
                      ),
                    ),
                    SizedBox(height: 0),
                    Text(
                      '$points',
                      style: AppTextStyles.semiBold.copyWith(
                        fontSize: 20.sp,
                        color: HexColor('FFFFFF'),
                        fontFamily: 'Inter',
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  LocaleKeys.your_balance.tr(),
                                  style: AppTextStyles.medium.copyWith(
                                    fontSize: 12.sp,
                                    color: yellowButtonsColor,
                                  ),
                                ),
                                SizedBox(height: 0),
                                Text(
                                  '$amount',
                                  style: AppTextStyles.semiBold.copyWith(
                                    fontSize: 20.sp,
                                    color: HexColor('FFFFFF'),
                                    fontFamily: 'Inter',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        ButtonWidget(
                          text: LocaleKeys.payout_request.tr(),
                          onPress: onPayoutRequest,
                          buttonColor: yellowButtonsColor,
                          borderColor: Colors.white,
                          textColor: Colors.white,
                          shadowColor: Colors.transparent,
                          radius: 6,
                          borderWidth: 0,
                          width: sizew * .45,
                          height: sizeh * .035,
                          widget: Padding(
                            padding:
                                EdgeInsets.symmetric(horizontal: sizew * .02),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  LocaleKeys.payout_request.tr(),
                                  style: AppTextStyles.semiBold.copyWith(
                                    fontSize: 11.sp,
                                    color: textPrimaryColor,
                                  ),
                                ),
                                SizedBox(width: sizew * .02),
                                SvgPicture.asset(doubleArrow,
                                    height: sizeh * .025),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Container(
                    //   padding:
                    //       EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    //   decoration: BoxDecoration(
                    //     color: Colors.white,
                    //     borderRadius: BorderRadius.circular(8),
                    //   ),
                    //   child: Row(
                    //     mainAxisSize: MainAxisSize.min,
                    //     children: [
                    //       Image.asset(availableMoney, height: sizeh * .02),
                    //       SizedBox(width: 4),
                    //       Text(
                    //         amount,
                    //         style: TextStyle(
                    //           fontFamily: 'Inter',
                    //           color: HexColor('#2A2D36'),
                    //           fontWeight: FontWeight.w500,
                    //           fontSize: 13.sp,
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ),
              // Right side: payout button
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDialog() {
    final sizeh = MediaQuery.of(context).size.height;
    final sizew = MediaQuery.of(context).size.width;
    final walletProvider = Provider.of<WalletProvider>(context, listen: false);

    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: sizew * .02, vertical: sizeh * .01),
      child: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: sizeh * .015,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: sizew * .03, vertical: sizeh * .0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      LocaleKeys.payout_request.tr(),
                      style: AppTextStyles.semiBold.copyWith(
                        fontSize: 13.sp,
                        color: textPrimaryColor,
                      ),
                    ),
                    InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: SvgPicture.asset(
                          circleX,
                          color: textPrimaryColor,
                          height: sizeh * .03,
                        ))
                  ],
                ),
              ),
              SizedBox(height: sizeh * .02),
              ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: walletProvider.traineePaymentMethodList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: sizew * .035, vertical: sizeh * .015),
                    child: InkWell(
                        onTap: () {
                          loadingDialog(context);
                          walletProvider
                              .getAccountsForMethod(
                                  id: walletProvider
                                          .traineePaymentMethodList[index].id ??
                                      '')
                              .then((value) {
                            Navigator.pop(context);
                            if (value == true) {
                              Navigator.pop(context);
                              paymentValue = null;
                              showCustomBottomSheet(
                                  child: buildSelectAccountDialog());
                              // showDialog(
                              //   context: context,
                              //   builder: (context) =>
                              //       buildSelectAccountDialog(),
                              // );
                            }
                          });
                        },
                        child: PaymentMethodCard(
                          name: walletProvider
                                  .traineePaymentMethodList[index].name ??
                              '',
                        )),
                  );
                },
              ),
              SizedBox(height: sizeh * .08),
            ],
          );
        },
      ),
    );
  }

  Widget buildSelectAccountDialog() {
    final sizeh = MediaQuery.of(context).size.height;
    final sizew = MediaQuery.of(context).size.width;
    final walletProvider = Provider.of<WalletProvider>(context, listen: false);
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: sizew * .02, vertical: sizeh * .01),
      child: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: sizeh * .015,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: sizew * .03, vertical: sizeh * .0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            showCustomBottomSheet(child: buildDialog());
                          },
                          child: Icon(Icons.arrow_back_ios,
                              color: textPrimaryColor, size: sizeh * .018),
                        ),
                        SizedBox(width: sizew * .01),
                        Text(
                          LocaleKeys.select_account.tr(),
                          style: AppTextStyles.semiBold.copyWith(
                            fontSize: 15.sp,
                            color: textPrimaryColor,
                          ),
                        ),
                      ],
                    ),
                    InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: SvgPicture.asset(
                          circleX,
                          color: textPrimaryColor,
                          height: sizeh * .03,
                        ))
                  ],
                ),
              ),
              SizedBox(height: sizeh * .02),
              ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: walletProvider.accountsPayoutList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: sizew * .03, vertical: sizeh * .005),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          clickedItemPay(index);
                        });
                      },
                      child: buildAccountCard(
                        clicked: walletProvider
                                .accountsPayoutList[index].isClicked ??
                            false,
                        icon: bankCard,
                        accountType: walletProvider
                                .accountsPayoutList[index].method?.name ??
                            '',
                        number: walletProvider
                                .accountsPayoutList[index].details?.fullName ??
                            '',
                      ),
                    ),
                  );
                },
              ),

              SizedBox(
                height: sizeh * .015,
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceAround,
              //   children: [
              //     ButtonWidget(
              //         textStyle: AppTextStyles.medium.copyWith(
              //           fontFamily: 'Inter',
              //           fontSize: 12.sp,
              //           color: primaryColor,
              //         ),
              //         buttonColor: Colors.white,
              //         borderColor: HexColor('#E2E8F0'),
              //         textColor: primaryColor,
              //         width: sizew * .41,
              //         height: sizeh * .048,
              //         text: LocaleKeys.cancel.tr(),
              //         onPress: () {
              //           Navigator.pop(context);
              //         }),
              // ButtonWidget(
              //     textStyle: AppTextStyles.medium.copyWith(
              //       fontFamily: 'Inter',
              //       fontSize: 12.sp,
              //       color: Colors.white,
              //     ),
              //     buttonColor: primaryColor,
              //     width: sizew * .41,
              //     height: sizeh * .047,
              //     text: LocaleKeys.send_request.tr(),
              //  )
              //   ],
              // ),
              ButtonWidget(
                onPress: paymentValue == null
                    ? () {
                        UIHelper.showNotification(
                            LocaleKeys.select_account.tr());
                      }
                    : () {
                        Navigator.pop(context);
                        showCustomBottomSheet(
                            child: buildConfirmingPayoutDialog());
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
                        LocaleKeys.send_request.tr(),
                        style: AppTextStyles.semiBold.copyWith(
                            fontSize: 13.5.sp, color: textPrimaryColor),
                      ),
                      SvgPicture.asset(doubleArrow)
                    ],
                  ),
                ),
              ),
              SizedBox(height: sizeh * .035),
            ],
          );
        },
      ),
    );
  }

  Widget buildConfirmingPayoutDialog() {
    final sizeh = MediaQuery.of(context).size.height;
    final sizew = MediaQuery.of(context).size.width;
    final walletProvider = Provider.of<WalletProvider>(context, listen: false);
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: sizew * .02, vertical: sizeh * .01),
      child: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: sizeh * .015,
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Row(
              //       children: [
              //         Text(
              //           LocaleKeys.payout_request.tr(),
              //           style: AppTextStyles.semiBold.copyWith(
              //               fontSize: 13.sp,
              //               color: primaryColor,
              //               fontFamily: 'Inter'),
              //         ),
              //       ],
              //     ),
              //     InkWell(
              //         onTap: () {
              //           Navigator.pop(context);
              //         },
              //         child: SvgPicture.asset(circleX))
              //   ],
              // ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: sizew * .03, vertical: sizeh * .0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            showCustomBottomSheet(
                                child: buildSelectAccountDialog());
                          },
                          child: Icon(Icons.arrow_back_ios,
                              color: textPrimaryColor, size: sizeh * .018),
                        ),
                        SizedBox(width: sizew * .01),
                        Text(
                          LocaleKeys.payout_request.tr(),
                          style: AppTextStyles.semiBold.copyWith(
                            fontSize: 15.sp,
                            color: textPrimaryColor,
                          ),
                        ),
                      ],
                    ),
                    InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: SvgPicture.asset(
                          circleX,
                          color: textPrimaryColor,
                          height: sizeh * .03,
                        ))
                  ],
                ),
              ),
              SizedBox(height: sizeh * .045),

              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: sizew * .03, vertical: sizeh * .005),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(LocaleKeys.youre_about_request.tr(),
                        style: AppTextStyles.semiBold.copyWith(
                          fontSize: 14.sp,
                          color: textPrimaryColor,
                        )),
                    SizedBox(width: sizew * .01),
                    Text('\$${walletProvider.totalMoney.toString()}',
                        style: AppTextStyles.semiBold.copyWith(
                          fontSize: 14.sp,
                          color: HexColor('#1E801B'),
                        )),
                  ],
                ),
              ),
              SizedBox(height: sizeh * .01),
              Center(
                child: Text(LocaleKeys.confirm_payout.tr(),
                    textAlign: TextAlign.center,
                    style: AppTextStyles.regular.copyWith(
                      fontSize: 12.sp,
                      color: textPrimaryColor,
                    )),
              ),

              SizedBox(
                height: sizeh * .04,
              ),
              ButtonWidget(
                onPress: () {
                  // showCustomBottomSheet(child: buildSuccsessDialog());

                  loadingDialog(context);
                  walletProvider
                      .createPayoutRequest(payoutMethodId: paymentValue ?? '')
                      .then((value) {
                    Navigator.pop(context);
                    if (value == true) {
                      _fetcheAllData =
                          Future.wait([_getWallet(), _getPayouts()]);

                      Navigator.pop(context);
                      // UIHelper.showNotification(
                      //     LocaleKeys.payout_request_sent.tr(),
                      //     backgroundColor: Colors.green);
                      showCustomBottomSheet(child: buildSuccsessDialog());

                      setState(() {
                        isShownPayment = true;
                      });
                    }
                  });
                  Navigator.pop(context);
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
                        LocaleKeys.confirm_request.tr(),
                        style: AppTextStyles.semiBold.copyWith(
                            fontSize: 13.5.sp, color: textPrimaryColor),
                      ),
                      SvgPicture.asset(doubleArrow)
                    ],
                  ),
                ),
              ),

              SizedBox(
                height: sizeh * .065,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget buildSuccsessDialog() {
    final sizeh = MediaQuery.of(context).size.height;
    final sizew = MediaQuery.of(context).size.width;
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: sizew * .02, vertical: sizeh * .01),
      child: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: sizeh * .015,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: sizew * .03, vertical: sizeh * .0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      LocaleKeys.successful_request.tr(),
                      style: AppTextStyles.semiBold.copyWith(
                        fontSize: 15.sp,
                        color: textPrimaryColor,
                      ),
                    ),
                    InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: SvgPicture.asset(
                          circleX,
                          color: textPrimaryColor,
                          height: sizeh * .03,
                        ))
                  ],
                ),
              ),
              SizedBox(height: sizeh * .04),
              Center(child: Image.asset('assets/icons/sucsess.png')),
              SizedBox(height: sizeh * .01),
              Center(
                child: Text(LocaleKeys.payout_sucseesfully.tr(),
                    textAlign: TextAlign.center,
                    style: AppTextStyles.semiBold.copyWith(
                      fontSize: 13.sp,
                      color: textPrimaryColor,
                    )),
              ),
              SizedBox(height: sizeh * .06),
            ],
          );
        },
      ),
    );
  }

  Widget buildAccountCard(
      {required String accountType,
      required String number,
      required bool clicked,
      required String icon}) {
    final sizeh = MediaQuery.of(context).size.height;
    final sizew = MediaQuery.of(context).size.width;

    return Container(
      margin: EdgeInsets.symmetric(vertical: sizeh * .01),
      padding:
          EdgeInsets.symmetric(horizontal: sizew * .04, vertical: sizeh * .012),
      decoration: BoxDecoration(
        color: HexColor('#F5FBFF'),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SvgPicture.asset(icon, height: sizeh * .025),
              SizedBox(width: sizew * .04),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    accountType,
                    style: AppTextStyles.medium.copyWith(
                        fontSize: 13.sp,
                        color: primaryColor,
                        fontFamily: 'Inter'),
                  ),
                  SizedBox(height: sizeh * .003),
                  Text(
                    number,
                    style: AppTextStyles.regular.copyWith(
                        fontSize: 9.sp,
                        color: HexColor('#8F94A3'),
                        fontFamily: 'Inter'),
                  ),
                ],
              ),
            ],
          ),
          SvgPicture.asset(clicked ? checkedIcon : unCheckedIcon,
              height: sizeh * .025),
        ],
      ),
    );
  }

  Widget payoutRequestCard(
      {required String date,
      required String time,
      required String status,
      required String points}) {
    final sizeh = MediaQuery.of(context).size.height;
    final sizew = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(
          color: HexColor('#F5FBFF'), borderRadius: BorderRadius.circular(16)),
      padding:
          EdgeInsets.symmetric(horizontal: sizew * .02, vertical: sizeh * .02),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${LocaleKeys.payout_request.tr()} $points ${LocaleKeys.points.tr()}',
                    style: AppTextStyles.bold.copyWith(
                        fontSize: 13.sp,
                        color: textPrimaryColor,
                        fontFamily: 'Inter'),
                  ),
                  SizedBox(
                    height: sizeh * .005,
                  ),
                  Row(
                    children: [
                      Text(
                        time,
                        style: AppTextStyles.regular.copyWith(
                          fontSize: 12.sp,
                          color: HexColor('#8F94A3'),
                        ),
                      ),
                      SizedBox(
                        width: sizew * .01,
                      ),
                      Text(
                        date,
                        style: AppTextStyles.regular.copyWith(
                          fontSize: 12.sp,
                          color: textPrimaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              StatusBadge(status: status)
            ],
          ),
        ],
      ),
    );
  }

  Widget buildContainer(
      {required String text,
      required Color textColor,
      required Color bgColor}) {
    final sizeh = MediaQuery.of(context).size.height;
    final sizew = MediaQuery.of(context).size.width;
    return Container(
      width: sizew * .2,
      height: sizeh * .03,
      decoration: BoxDecoration(
        border: Border.all(color: textColor, width: 1),
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          text,
          style: AppTextStyles.regular.copyWith(
            fontSize: 9.5.sp,
            color: textColor,
          ),
        ),
      ),
    );
  }
}

class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({Key? key, required this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;

    switch (status) {
      case 'Approved':
        bgColor = HexColor('#1E801B');
        textColor = Colors.white;
        break;
      case 'Pending':
        bgColor = HexColor('#40455E'); // dark blue/gray
        textColor = Colors.white;
        break;
      case 'Rejected':
        bgColor = HexColor('#A60101');
        textColor = Colors.white;
        break;
      default:
        bgColor = Colors.grey;
        textColor = Colors.white;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status,
        style:
            AppTextStyles.medium.copyWith(fontSize: 10.5.sp, color: textColor),
      ),
    );
  }
}
