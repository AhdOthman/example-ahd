import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:subrate/provider/appprovider.dart';
import 'package:subrate/provider/homeprovider.dart';
import 'package:subrate/provider/notificationprovider.dart';
import 'package:subrate/theme/ui_helper.dart';
import 'package:subrate/widgets/app/empty_widget.dart';
import 'package:subrate/theme/app_colors.dart';
import 'package:subrate/theme/assets_managet.dart';
import 'package:subrate/theme/text_style.dart';
import 'package:subrate/translations/locale_keys.g.dart';
import 'package:subrate/widgets/app/button.dart';
import 'package:subrate/widgets/app/loadingdialog.dart';

class NotificationsScreen extends StatefulWidget {
  static const routeName = '/notifications-screen';
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  String? tenantName;
  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);
    final sizeh = MediaQuery.of(context).size.height;
    final sizew = MediaQuery.of(context).size.width;
    final notificationProvider = Provider.of<NotificationProvider>(context);
    final appProvider = Provider.of<AppProvider>(context);
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
                  width: sizew * .03,
                ),
                Text(
                  LocaleKeys.notifications.tr(),
                  style: AppTextStyles.semiBold
                      .copyWith(fontSize: 16.sp, color: primaryColor),
                ),
              ],
            ),
            SizedBox(
              height: sizeh * .035,
            ),
            notificationProvider.notificationList.isEmpty
                ? Center(
                    child: Column(
                      children: [
                        SizedBox(
                          height: sizeh * .1,
                        ),
                        EmptyWidget(
                            path: noNotification,
                            title: LocaleKeys.no_notification.tr()),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: notificationProvider.notificationList.length,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            appProvider.dateFormat.format(DateTime.parse(
                                notificationProvider
                                        .notificationList[index].createdAt ??
                                    '')),
                            style: AppTextStyles.regular
                                .copyWith(fontSize: 12.sp, color: primaryColor),
                          ),
                          SizedBox(
                            height: sizeh * .01,
                          ),
                          _buildNotificationCard(sizeh, sizew,
                              name: notificationProvider.notificationList[index]
                                      .payload?.tenantName ??
                                  '',
                              workspaceName: notificationProvider
                                      .notificationList[index]
                                      .payload
                                      ?.tenantName ??
                                  '', onAcceptPress: () {
                            tenantName = notificationProvider
                                    .notificationList[index]
                                    .payload
                                    ?.tenantName ??
                                '';
                            loadingDialog(context);
                            notificationProvider
                                .acceptInvite(
                                    id: notificationProvider
                                            .notificationList[index]
                                            .payload
                                            ?.invitationId ??
                                        '')
                                .then((value) {
                              notificationProvider.getNotifications();
                              homeProvider.getTenants();
                              Navigator.of(context).pop();
                              if (value == true) {
                                showDialog(
                                  context: context,
                                  builder: (context) =>
                                      buildSuccsessDialog(tenantName ?? ''),
                                );
                              }
                            });
                          }, onRejectPress: () {
                            loadingDialog(context);
                            notificationProvider
                                .rejectInvite(
                                    id: notificationProvider
                                            .notificationList[index]
                                            .payload
                                            ?.invitationId ??
                                        '')
                                .then((value) {
                              notificationProvider.getNotifications();
                              homeProvider.getTenants();
                              Navigator.of(context).pop();
                              if (value == true) {
                                UIHelper.showNotification(
                                  LocaleKeys.rejected.tr(),
                                  backgroundColor: Colors.green,
                                );
                              }
                            });
                          }),
                        ],
                      );
                    })
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationCard(double sizeh, double sizew,
      {required String name,
      required String workspaceName,
      required Function onAcceptPress,
      required Function onRejectPress}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: sizeh * .01),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: sizeh * .01),
            child: SvgPicture.asset(
              yallewLogo,
              height: sizeh * .045,
            ),
          ),
          SizedBox(
            width: sizew * .03,
          ),
          SizedBox(
            width: sizew * .8,
            child: Column(
              children: [
                Text(
                  '${name} ${LocaleKeys.invited_to.tr()}"${workspaceName}"',
                  style: AppTextStyles.regular
                      .copyWith(fontSize: 11.sp, color: Colors.black),
                ),
                SizedBox(
                  height: sizeh * .02,
                ),
                Row(
                  children: [
                    ButtonWidget(
                        radius: 5,
                        height: sizeh * .05,
                        width: sizew * .38,
                        textStyle: AppTextStyles.regular
                            .copyWith(color: Colors.white, fontSize: 11.5.sp),
                        text: LocaleKeys.accept.tr(),
                        onPress: () {
                          onAcceptPress();
                        }),
                    SizedBox(
                      width: sizew * .02,
                    ),
                    ButtonWidget(
                        buttonColor: Colors.white,
                        borderWidth: 1,
                        borderColor: primaryColor,
                        textColor: primaryColor,
                        radius: 5,
                        height: sizeh * .05,
                        textStyle: AppTextStyles.regular
                            .copyWith(color: primaryColor, fontSize: 11.5.sp),
                        width: sizew * .38,
                        text: LocaleKeys.reject.tr(),
                        onPress: () {
                          onRejectPress();
                        }),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSuccsessDialog(String workspaceName) {
    final sizeh = MediaQuery.of(context).size.height;
    final sizew = MediaQuery.of(context).size.width;
    // Future.delayed(Duration(seconds: 3), () {
    //   Navigator.of(context).pop();
    // });
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
                Center(
                    child: SvgPicture.asset(
                  acceptDialog,
                )),
                Center(
                  child: Text(
                    LocaleKeys.hello.tr(),
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bold
                        .copyWith(fontSize: 13.sp, color: Color(0xFF4FAD88)),
                  ),
                ),
                SizedBox(height: sizeh * .035),
                Center(
                  child: Text(
                      '${LocaleKeys.now_on.tr()}$workspaceName ${LocaleKeys.workspace.tr()}',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.regular
                          .copyWith(fontSize: 13.sp, color: Colors.black)),
                ),
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
}
