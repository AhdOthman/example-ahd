import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:subrate/provider/appprovider.dart';
import 'package:subrate/routers/routers.dart';
import 'package:subrate/theme/app_colors.dart';
import 'package:subrate/theme/assets_managet.dart';
import 'package:subrate/theme/text_style.dart';
import 'package:subrate/translations/locale_keys.g.dart';

class SettingsScreen extends StatefulWidget {
  static const routeName = 'settings-screen';
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isArabic = false;
  @override
  void didChangeDependencies() {
    Locale myLocale = EasyLocalization.of(
      context,
    )!
        .locale;

    myLocale.languageCode == 'ar' ? isArabic = true : false;
    print('${isArabic}isArabic');
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final sizeh = MediaQuery.of(context).size.height;
    final sizew = MediaQuery.of(context).size.width;
    final Routers routers = Routers();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.symmetric(
            horizontal: sizew * .035, vertical: sizeh * .015),
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
                  LocaleKeys.settings.tr(),
                  style: AppTextStyles.semiBold
                      .copyWith(fontSize: 16.sp, color: primaryColor),
                ),
              ],
            ),
            SizedBox(
              height: sizeh * .035,
            ),
            InkWell(
              onTap: () {
                routers.navigateToChangePasswordScreen(context);
              },
              child: buildProfileCard(
                sizeh,
                sizew,
                iconPath: changePasswordSettings,
                title: LocaleKeys.change_password.tr(),
              ),
            ),
            InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => buildLanguageDialog(),
                );
              },
              child: buildProfileCard(
                sizeh,
                sizew,
                iconPath: laguageSettings,
                showItem: true,
                titleItem: LocaleKeys.language_word.tr(),
                title: LocaleKeys.language.tr(),
              ),
            ),
            buildProfileCard(
              sizeh,
              sizew,
              iconPath: supportSettings,
              title: LocaleKeys.support.tr(),
            ),
            buildProfileCard(
              sizeh,
              sizew,
              iconPath: deleteSettings,
              title: LocaleKeys.delete_account.tr(),
            )
          ],
        ),
      ),
    );
  }

  Widget buildProfileCard(double sizeh, double sizew,
      {required String iconPath,
      required String title,
      bool? showItem,
      String? titleItem}) {
    return Container(
      margin: EdgeInsets.only(bottom: sizeh * .02),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SvgPicture.asset(iconPath, height: sizeh * .04),
              SizedBox(
                width: sizew * .02,
              ),
              Text(
                title,
                style: AppTextStyles.regular
                    .copyWith(fontSize: 13.sp, color: primaryColor),
              ),
            ],
          ),
          showItem == true
              ? Text(
                  titleItem ?? '',
                  style: AppTextStyles.regular
                      .copyWith(fontSize: 12.sp, color: yallewTextColor),
                )
              : SizedBox()
        ],
      ),
    );
  }

  Widget buildLanguageDialog() {
    final sizeh = MediaQuery.of(context).size.height;
    final sizew = MediaQuery.of(context).size.width;
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    final Routers routers = Routers();
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: sizew * .04, vertical: sizeh * .015),
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
                    Text(
                      LocaleKeys.choose_language.tr(),
                      style: AppTextStyles.semiBold
                          .copyWith(fontSize: 12.5.sp, color: primaryColor),
                    ),
                    SizedBox(
                      height: sizeh * .02,
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          isArabic = true;
                          context.setLocale(Locale('ar'));
                          Navigator.of(context).pop();
                        });
                        appProvider.selectedIndex = 3;
                        routers.navigateToBottomBarScreen(context);
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: sizeh * .01),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: isArabic
                                  ? yallewTextColor
                                  : Color(0xFFD9D9D9),
                              radius: sizew * .02,
                            ),
                            SizedBox(width: sizew * .02),
                            Text(
                              'العربية',
                              style: AppTextStyles.regular.copyWith(
                                  fontSize: 11.5.sp, color: primaryColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: sizeh * .01,
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          isArabic = false;
                          context.setLocale(Locale('en'));
                          Navigator.of(context).pop();
                        });
                        appProvider.selectedIndex = 3;
                        routers.navigateToBottomBarScreen(context);
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: sizeh * .01),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: isArabic == false
                                  ? yallewTextColor
                                  : Color(0xFFD9D9D9),
                              radius: sizew * .02,
                            ),
                            SizedBox(width: sizew * .02),
                            Text(
                              'English',
                              style: AppTextStyles.regular.copyWith(
                                  fontSize: 11.5.sp, color: primaryColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: sizeh * .01),
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
}
