import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
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

  @override
  Widget build(BuildContext context) {
    final sizeh = MediaQuery.of(context).size.height;
    final sizew = MediaQuery.of(context).size.width;
    final authProvider = Provider.of<AuthProvider>(context);
    final walletProvider = Provider.of<WalletProvider>(context);
    final appProvider = Provider.of<AppProvider>(context);
    return Scaffold(
      backgroundColor: innerBackgroundColor,
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
                              Row(
                                children: [
                                  _buildInfoBox(
                                    sizeh,
                                    sizew,
                                    availablePoints,
                                    LocaleKeys.available_points.tr(),
                                    walletProvider.totalPoints.toString(),
                                  ),
                                  SizedBox(width: sizew * .025),
                                  _buildInfoBox(
                                    sizeh,
                                    sizew,
                                    availableMoney,
                                    LocaleKeys.available_money.tr(),
                                    '${walletProvider.totalMoney.toStringAsFixed(2)}\$',
                                  ),
                                ],
                              ),
                              SizedBox(height: sizeh * .025),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    LocaleKeys.payout_history.tr(),
                                    style: AppTextStyles.semiBold.copyWith(
                                        fontSize: 12.sp, color: primaryColor),
                                  ),
                                  ButtonWidget(
                                    text: LocaleKeys.payout_request.tr(),
                                    onPress: walletProvider
                                            .traineePaymentMethodList.isEmpty
                                        ? () {
                                            UIHelper.showNotification(LocaleKeys
                                                .please_add_payout
                                                .tr());
                                          }
                                        : walletProvider.totalPoints == 0
                                            ? () {
                                                UIHelper.showNotification(
                                                    'You have no points to pay');
                                              }
                                            : () {
                                                walletProvider
                                                    .traineePaymentMethodList
                                                    .map((e) =>
                                                        e.isClicked = false)
                                                    .toList();
                                                paymentValue = null;

                                                showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      buildDialog(),
                                                );
                                              },
                                    buttonColor: Colors.transparent,
                                    borderColor: primaryColor,
                                    textColor: primaryColor,
                                    radius: 5,
                                    borderWidth: 1,
                                    width: sizew * .32,
                                    height: sizeh * .04,
                                    textStyle: AppTextStyles.regular.copyWith(
                                      fontSize: 10.sp,
                                      color: primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: sizeh * .02,
                              ),
                              // isShownPayment == false
                              //     ? Center(
                              //         child: Text(
                              //           LocaleKeys.no_payment.tr(),
                              //           style: AppTextStyles.regular.copyWith(
                              //               fontSize: 11.5.sp, color: Color(0xFFA6A6A6)),
                              //         ),
                              //       )
                              //     :
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
                                        ? SizedBox(
                                            child: ListView.builder(
                                                itemCount: getPayouts.length,
                                                shrinkWrap: true,
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                padding: EdgeInsets.zero,
                                                itemBuilder: (context, index) {
                                                  return payoutRequestCard(
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
                                            height: 10.h,
                                            child: Center(
                                              child: Text(
                                                  'There is no Payouts yet!'),
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

  Widget _buildInfoBox(
      double sizeh, double sizew, String iconPath, String title, String value) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5), color: primaryColor),
      padding: EdgeInsets.symmetric(
          horizontal: sizew * .038, vertical: sizeh * .015),
      child: Column(
        children: [
          Image.asset(iconPath, height: sizeh * .04),
          SizedBox(height: sizeh * .005),
          Text(
            title,
            style: AppTextStyles.semiBold
                .copyWith(fontSize: 12.sp, color: Colors.white),
          ),
          SizedBox(height: sizeh * .005),
          Text(
            value,
            style: AppTextStyles.semiBold
                .copyWith(fontSize: 12.sp, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget buildDialog() {
    final sizeh = MediaQuery.of(context).size.height;
    final sizew = MediaQuery.of(context).size.width;
    final walletProvider = Provider.of<WalletProvider>(context, listen: false);
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: sizew * .03, vertical: sizeh * .015),
        child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Stack(
              clipBehavior: Clip.none,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: sizeh * .015,
                    ),
                    Center(
                      child: Text(
                        LocaleKeys.payout_request.tr(),
                        style: AppTextStyles.semiBold
                            .copyWith(fontSize: 12.5.sp, color: primaryColor),
                      ),
                    ),
                    SizedBox(
                      height: sizeh * .015,
                    ),
                    Text(
                      LocaleKeys.choose_payment_mothod.tr(),
                      style: AppTextStyles.regular
                          .copyWith(fontSize: 12.sp, color: primaryColor),
                    ),
                    SizedBox(height: sizeh * .02),
                    ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: walletProvider.traineePaymentMethodList.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            setState(() {
                              clickedItem(index);
                            });
                          },
                          child: Padding(
                            padding:
                                EdgeInsets.symmetric(vertical: sizeh * .01),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: walletProvider
                                          .traineePaymentMethodList[index]
                                          .isClicked
                                      ? yallewTextColor
                                      : Color(0xFFD9D9D9),
                                  radius: sizew * .02,
                                ),
                                SizedBox(width: sizew * .02),
                                Text(
                                  walletProvider.traineePaymentMethodList[index]
                                          .name ??
                                      '',
                                  style: AppTextStyles.regular.copyWith(
                                      fontSize: 11.5.sp, color: primaryColor),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: sizeh * .035),
                    Center(
                      child: ButtonWidget(
                        radius: 5,
                        textStyle: AppTextStyles.regular
                            .copyWith(fontSize: 12.sp, color: Colors.white),
                        height: sizeh * .05,
                        width: sizew * .45,
                        text: LocaleKeys.send_request.tr(),
                        onPress: paymentValue == null
                            ? () {
                                UIHelper.showNotification(
                                    LocaleKeys.please_select_payment.tr());
                              }
                            : () {
                                loadingDialog(context);
                                walletProvider
                                    .createPayoutRequest(
                                        payoutMethodId: paymentValue ?? '')
                                    .then((value) {
                                  Navigator.pop(context);
                                  if (value == true) {
                                    _fetcheAllData = Future.wait(
                                        [_getWallet(), _getPayouts()]);

                                    Navigator.pop(context);
                                    // UIHelper.showNotification(
                                    //     LocaleKeys.payout_request_sent.tr(),
                                    //     backgroundColor: Colors.green);
                                    showDialog(
                                      context: context,
                                      builder: (context) =>
                                          buildSuccsessDialog(),
                                    );
                                    setState(() {
                                      isShownPayment = true;
                                    });
                                  }
                                });
                              },
                      ),
                    ),
                    SizedBox(height: sizeh * .035),
                  ],
                ),
                Positioned(
                  top: -25, // Slightly outside the container
                  right: -25,
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: SvgPicture.asset(
                      closeIcon,
                      height: sizeh * .04,
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }

  Widget buildSuccsessDialog() {
    final sizeh = MediaQuery.of(context).size.height;
    final sizew = MediaQuery.of(context).size.width;
    Future.delayed(Duration(seconds: 1), () {
      Navigator.of(context).pop();
    });
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: sizew * .03, vertical: sizeh * .015),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      done,
                      height: sizeh * .05,
                    ),
                  ],
                ),
                SizedBox(height: sizeh * .025),
                Text(
                  LocaleKeys.payout_sucseesfully.tr(),
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bold
                      .copyWith(fontSize: 12.sp, color: Colors.black),
                ),
                SizedBox(height: sizeh * .035),
              ],
            ),
            Positioned(
              top: -30, // Slightly outside the container
              right: -30,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: SvgPicture.asset(
                  closeIcon,
                  height: sizeh * .04,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget payoutRequestCard(
      {required String date, required String status, required String points}) {
    final sizeh = MediaQuery.of(context).size.height;
    final sizew = MediaQuery.of(context).size.width;
    return Container(
      padding:
          EdgeInsets.symmetric(horizontal: sizew * .02, vertical: sizeh * .015),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                date,
                style: AppTextStyles.regular
                    .copyWith(fontSize: 11.sp, color: yallewTextColor),
              ),
              SizedBox(
                height: sizeh * .005,
              ),
              Text(
                'Payout request $points point',
                style: AppTextStyles.regular
                    .copyWith(fontSize: 11.sp, color: primaryColor),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: sizew * .025, vertical: sizeh * .007),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Color(0xFFEBEDF0)),
            child: Text(
              status,
              style: AppTextStyles.regular
                  .copyWith(fontSize: 11.sp, color: Color(0xFF999999)),
            ),
          )
        ],
      ),
    );
  }
}
