import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
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

class ManageAccountsScreen extends StatefulWidget {
  static const routeName = '/manage-accounts-screen';
  const ManageAccountsScreen({super.key});

  @override
  State<ManageAccountsScreen> createState() => _ManageAccountsScreenState();
}

class _ManageAccountsScreenState extends State<ManageAccountsScreen> {
  Future _getAccounts(String id) async {
    final walletProvider = Provider.of<WalletProvider>(context, listen: false);
    return await walletProvider.getAccountsForMethod(id: id);
  }

  late Future _fetcheAllData;

  bool _isInit = true;
  @override
  void didChangeDependencies() {
    if (_isInit) {
      final argumets =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      _fetcheAllData = _getAccounts(argumets['id'] ?? '');

      // homeProvider.getRecentlyProducts(page: 1);
      // homeProvider.getHomeData();
    }
    _isInit = false;

    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final sizeh = MediaQuery.of(context).size.height;
    final sizew = MediaQuery.of(context).size.width;
    final argumets =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    final authProvider = Provider.of<AuthProvider>(context);
    final Routers routers = Routers();
    return Scaffold(
      body: Container(
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
                    LocaleKeys.manage_your_accounts.tr(),
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
                          : Center(child: TextWidget(snapshot.data.toString()));
                    }
                    final provider = Provider.of<WalletProvider>(context);

                    var getPayoutMethod = provider.accountsPayoutList;
                    return getPayoutMethod.isNotEmpty
                        ? SizedBox(
                            child: ListView.builder(
                                itemCount: getPayoutMethod.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.zero,
                                itemBuilder: (context, index) {
                                  return buildAccountCard(
                                      isDefault:
                                          getPayoutMethod[index].isDefault ??
                                              false,
                                      onTap: () {
                                        loadingDialog(context);
                                        provider
                                            .setDefualtAccount(
                                                id: getPayoutMethod[index].id ??
                                                    '')
                                            .then((value) {
                                          Navigator.pop(context);

                                          if (value == true) {
                                            provider.getAccountsForMethod(
                                                id: argumets['id']);
                                            UIHelper.showNotification(
                                                LocaleKeys.successful_request
                                                    .tr(),
                                                backgroundColor: Colors.green);
                                          }
                                        });
                                      },
                                      onDelete: () {
                                        loadingDialog(context);
                                        provider
                                            .deletePayoutAccount(
                                                id: getPayoutMethod[index].id ??
                                                    '')
                                            .then((value) {
                                          Navigator.pop(context);
                                          Navigator.pop(context);

                                          if (value == true) {
                                            provider.getAccountsForMethod(
                                                id: argumets['id']);
                                            UIHelper.showNotification(
                                                LocaleKeys.successful_request
                                                    .tr(),
                                                backgroundColor: Colors.green);
                                          }
                                        });
                                      },
                                      accountName: getPayoutMethod[index]
                                              .details
                                              ?.fullName ??
                                          '',
                                      email: getPayoutMethod[index]
                                              .details
                                              ?.email ??
                                          '');
                                }))
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
              Center(
                child: ButtonWidget(
                    widget: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add,
                          color: Colors.white,
                          size: sizeh * .022,
                        ),
                        SizedBox(
                          width: sizew * .015,
                        ),
                        Text(
                          LocaleKeys.add_account.tr(),
                          style: AppTextStyles.medium.copyWith(
                              fontSize: 12.sp,
                              color: Colors.white,
                              fontFamily: 'Inter'),
                        ),
                      ],
                    ),
                    height: sizeh * .047,
                    width: sizew * .88,
                    text: LocaleKeys.add_account.tr(),
                    onPress: () {
                      routers.navigateToAddNewAccountScreen(context, args: {
                        'id': argumets['id'],
                      });
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildAccountCard(
      {required String accountName,
      required String email,
      required bool isDefault,
      required Function onDelete,
      required Function onTap}) {
    final sizeh = MediaQuery.of(context).size.height;
    final sizew = MediaQuery.of(context).size.width;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      padding:
          EdgeInsets.symmetric(horizontal: sizew * .0, vertical: sizeh * .006),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: HexColor('#E2E8F0'), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: sizew * .03, vertical: sizeh * .006),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      accountName,
                      style: AppTextStyles.medium.copyWith(
                          fontSize: 13.sp,
                          color: primaryColor,
                          fontFamily: 'Inter'),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      email,
                      style: AppTextStyles.medium.copyWith(
                          color: HexColor('#8F94A3'),
                          fontSize: 9.sp,
                          fontFamily: 'Inter'),
                    ),
                  ],
                ),
                InkWell(
                  onTap: () {
                    onTap();
                  },
                  child: Text(
                    isDefault
                        ? LocaleKeys.defult.tr()
                        : LocaleKeys.set_default.tr(),
                    style: AppTextStyles.medium.copyWith(
                        color: isDefault
                            ? HexColor('#8F94A3')
                            : HexColor('#1976D2'),
                        fontSize: 10.sp,
                        fontFamily: 'Inter'),
                  ),
                ),
              ],
            ),
          ),
          Divider(thickness: .5, color: HexColor('#E2E8F0')),
          Padding(
            padding: EdgeInsets.symmetric(vertical: sizeh * .006),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Spacer(),
                InkWell(
                  onTap: () {},
                  child: Row(
                    children: [
                      SvgPicture.asset(editIcon),
                      SizedBox(width: sizew * .02),
                      Text(
                        LocaleKeys.edit.tr(),
                        style: AppTextStyles.regular.copyWith(
                            color: HexColor('#8F94A3'),
                            fontSize: 11.sp,
                            fontFamily: 'Inter'),
                      )
                    ],
                  ),
                ),
                Spacer(),
                Container(width: 1, height: 24, color: Colors.grey.shade300),
                Spacer(),
                InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => buildDeleteDialog(
                        () {
                          onDelete();
                        },
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      SvgPicture.asset(delete),
                      SizedBox(width: sizew * .02),
                      Text(
                        LocaleKeys.delete.tr(),
                        style: AppTextStyles.regular.copyWith(
                            color: HexColor('#D00000'),
                            fontSize: 11.sp,
                            fontFamily: 'Inter'),
                      )
                    ],
                  ),
                ),
                Spacer()
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDeleteDialog(Function onTap) {
    final sizeh = MediaQuery.of(context).size.height;
    final sizew = MediaQuery.of(context).size.width;
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: sizew * .045),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: sizew * .02, vertical: sizeh * .01),
        child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: sizeh * .015,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          LocaleKeys.delete_account.tr(),
                          style: AppTextStyles.semiBold.copyWith(
                              fontSize: 13.sp,
                              color: primaryColor,
                              fontFamily: 'Inter'),
                        ),
                      ],
                    ),
                    InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: SvgPicture.asset(circleX))
                  ],
                ),
                SizedBox(height: sizeh * .01),
                Divider(
                  color: HexColor('#E2E8F0'),
                  thickness: .5,
                ),
                SizedBox(
                  height: sizeh * .015,
                ),
                Center(
                  child: Text(LocaleKeys.are_you_sure_account.tr(),
                      textAlign: TextAlign.center,
                      style: AppTextStyles.semiBold.copyWith(
                          fontSize: 11.5.sp,
                          color: primaryColor,
                          fontFamily: 'Inter')),
                ),
                SizedBox(height: sizeh * .01),
                Center(
                  child: Text(LocaleKeys.delete_phase_payment.tr(),
                      textAlign: TextAlign.center,
                      style: AppTextStyles.regular.copyWith(
                          fontSize: 11.sp,
                          color: primaryColor,
                          fontFamily: 'Inter')),
                ),
                Divider(
                  color: HexColor('#E2E8F0'),
                  thickness: .5,
                ),
                SizedBox(
                  height: sizeh * .015,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ButtonWidget(
                        textStyle: AppTextStyles.medium.copyWith(
                          fontFamily: 'Inter',
                          fontSize: 12.sp,
                          color: primaryColor,
                        ),
                        buttonColor: Colors.white,
                        borderColor: HexColor('#E2E8F0'),
                        textColor: primaryColor,
                        width: sizew * .41,
                        height: sizeh * .048,
                        text: LocaleKeys.cancel.tr(),
                        onPress: () {
                          Navigator.pop(context);
                        }),
                    ButtonWidget(
                        textStyle: AppTextStyles.medium.copyWith(
                          fontFamily: 'Inter',
                          fontSize: 12.sp,
                          color: Colors.white,
                        ),
                        buttonColor: HexColor('#DF0404'),
                        width: sizew * .41,
                        height: sizeh * .047,
                        text: LocaleKeys.delete.tr(),
                        onPress: () {
                          onTap();
                          // showDialog(
                          //   context: context,
                          //   builder: (context) => buildConfirmingPayoutDialog(),
                          // );
                        })
                  ],
                ),
                SizedBox(height: sizeh * .02),
              ],
            );
          },
        ),
      ),
    );
  }
}
