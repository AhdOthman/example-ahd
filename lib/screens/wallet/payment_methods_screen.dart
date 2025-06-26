import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import 'package:subrate/provider/authprovider.dart';
import 'package:subrate/provider/walletprovider.dart';
import 'package:subrate/routers/routers.dart';
import 'package:subrate/theme/app_colors.dart';
import 'package:subrate/theme/failure.dart';
import 'package:subrate/theme/text_style.dart';
import 'package:subrate/translations/locale_keys.g.dart';

import 'package:subrate/widgets/app/text_widget.dart';
import 'package:subrate/widgets/wallet/payment_method_card.dart';

class PaymentMethodsScreen extends StatefulWidget {
  static const routeName = '/payment-methods-screen';
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  // List<Choicess> paymentMethods = [
  //   Choicess(
  //       clicked: false,
  //       name: LocaleKeys.bank.tr(),
  //       value: 1,
  //       choiceImage: bankCard),
  //   Choicess(
  //       clicked: false,
  //       name: LocaleKeys.paypal.tr(),
  //       value: 1,
  //       choiceImage: paypal),
  //   Choicess(
  //       clicked: false,
  //       name: LocaleKeys.bank.tr(),
  //       value: 1,
  //       choiceImage: paypal)
  // ];
  String? paymentValue;
  clickedItem(int index) {
    final walletProvider = Provider.of<WalletProvider>(context, listen: false);

    setState(() {
      paymentValue = walletProvider.payoutMethodList[index].id;
      formData.clear();

      _fetcheAllData = walletProvider.getPayoutMethodDetails(
          payoutMethodId: paymentValue ?? '');

      walletProvider.payoutMethodList.map((e) => e.isClicked = false).toList();
      // weekDays[index].isSelected = false ? true : false;
      walletProvider.payoutMethodList[index].isClicked =
          !walletProvider.payoutMethodList[index].isClicked;
    });
  }

  TextEditingController fullNameController = TextEditingController();
  Future _getPayoutMethod() async {
    final walletProvider = Provider.of<WalletProvider>(context, listen: false);
    return await walletProvider.getPayoutMethod();
  }

  final Map<String, dynamic> formData = {};
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    final walletProvider = Provider.of<WalletProvider>(context, listen: false);
    walletProvider.paymentDetailsList.clear();
    _fetcheAllData = _getPayoutMethod();

    super.initState();
  }

  late Future _fetcheAllData;
  @override
  Widget build(BuildContext context) {
    final sizeh = MediaQuery.of(context).size.height;
    final sizew = MediaQuery.of(context).size.width;
    final authProvider = Provider.of<AuthProvider>(context);
    final Routers routers = Routers();
    return Scaffold(
      backgroundColor: innerBackgroundColor,
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
                      LocaleKeys.payment_methods.tr(),
                      style: AppTextStyles.semiBold
                          .copyWith(fontSize: 16.sp, color: primaryColor),
                    ),
                  ],
                ),
                SizedBox(
                  height: sizeh * .035,
                ),
                FutureBuilder(
                  future: _fetcheAllData,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
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
                        return authProvider.tenantID == null
                            ? Center(
                                child: Text('Please Select Tenant'),
                              )
                            : Center(
                                child: TextWidget(snapshot.data.toString()));
                      }
                      final provider = Provider.of<WalletProvider>(context);

                      var getPayoutMethod = provider.payoutMethodList;
                      return getPayoutMethod.isNotEmpty
                          ? SizedBox(
                              child: ListView.builder(
                                  itemCount: getPayoutMethod.length,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: EdgeInsets.zero,
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                        onTap: () {
                                          routers
                                              .navigateToManageAccountsScreen(
                                                  context,
                                                  args: {
                                                'id': getPayoutMethod[index].id,
                                              });
                                        },
                                        child: PaymentMethodCard(
                                          name:
                                              getPayoutMethod[index].name ?? '',
                                        )

                                        //  buildPaymentMethodCard(
                                        //     sizeh, sizew,
                                        //     clicked:
                                        //         getPayoutMethod[index].isClicked,
                                        //     name: getPayoutMethod[index]
                                        //             .payoutMethod
                                        //             ?.name ??
                                        //         '',
                                        //     choiceImage:
                                        //         '$downloadPhoto${getPayoutMethod[index].payoutMethod?.image}'),
                                        );
                                  }),
                            )
                          : SizedBox(
                              height: 60.h,
                              child: Center(
                                child: Text('Empty'),
                              ),
                            );
                    }
                    return Container();
                  },
                ),
                SizedBox(
                  height: sizeh * .02,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildPaymentMethodCard(double sizeh, double sizew,
      {required bool clicked,
      required String name,
      required String choiceImage}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: sizew * .01),
      padding:
          EdgeInsets.symmetric(horizontal: sizew * .02, vertical: sizeh * .01),
      width: sizew * .28,
      height: sizew * .26,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: clicked
                ? Colors.grey.withOpacity(0.2)
                : Colors.transparent, // Shadow color with transparency
            spreadRadius: 1, // How much the shadow spreads
            blurRadius: 8, // The blur intensity
            offset: Offset(0, 2), // Offset in the x and y direction
          ),
        ],
        color: clicked ? Colors.white : innerBackgroundColor,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
            color: clicked ? yallewTextColor : Colors.transparent, width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(
            choiceImage,
            height: sizeh * .035,
          ),
          SizedBox(
            height: sizeh * .01,
          ),
          Text(
            name,
            style: AppTextStyles.regular
                .copyWith(fontSize: 9.sp, color: Colors.black),
          )
        ],
      ),
    );
  }
}
