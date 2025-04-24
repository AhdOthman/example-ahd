import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:subrate/models/home/tenant_model.dart';
import 'package:subrate/provider/appprovider.dart';
import 'package:subrate/provider/authprovider.dart';
import 'package:subrate/provider/homeprovider.dart';
import 'package:subrate/provider/notificationprovider.dart';
import 'package:subrate/provider/profileprovider.dart';
import 'package:subrate/routers/routers.dart';
import 'package:subrate/theme/app_colors.dart';
import 'package:subrate/theme/assets_managet.dart';
import 'package:subrate/theme/failure.dart';
import 'package:subrate/theme/text_style.dart';
import 'package:subrate/theme/ui_helper.dart';
import 'package:subrate/translations/locale_keys.g.dart';
import 'package:subrate/widgets/app/text_widget.dart';
import 'package:badges/badges.dart' as badges;
import 'package:subrate/widgets/appskeleton/home_skeleton.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = 'home-screen';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedValue = 'Subrate';

  final List<String> dropdownItems = [
    'Subrate',
    'Subrate 1',
    'Subrate 2',
  ];
  //   Future _getBestSlling() async {
  //   final homeProvider = Provider.of<HomeProvider>(context, listen: false);
  //   return await homeProvider.getBestSelling();
  // }

  Future _getNotifications() async {
    final notificationProvider =
        Provider.of<NotificationProvider>(context, listen: false);
    return await notificationProvider.getNotifications();
  }

  Future _getTenants() async {
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);
    return await homeProvider.getTenants();
  }

  Future _getTasks() async {
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);
    return await homeProvider.getTasks();
  }

  Future _getProfile() async {
    final profileProvider =
        Provider.of<Profileprovider>(context, listen: false);
    return await profileProvider.getProfileData(context);
  }

  @override
  void initState() {
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final profileProvider =
        Provider.of<Profileprovider>(context, listen: false);
    profileProvider.getProfileData(context);
    _fetcheAllData = Future.wait([
      _getNotifications(),
      _getTenants(),
      _getTasks(),
      _getProfile(),
    ]);
    Future.delayed(Duration(seconds: 2), () {
      if (homeProvider.tenantList.isNotEmpty) {
        if (authProvider.tenantID != null) {
          print('isNotEmpty');
          homeProvider.tenantList.forEach((element) {
            if (element.tenant?.id == authProvider.tenantID) {
              print('authProvider.tenantID ${authProvider.tenantID}');

              selectedValue = element.tenant?.fullName ?? "Unknown";
              isSelected = element.tenant?.fullName == selectedValue;
            }
          });
        } else {
          print('else');
          selectedValue =
              homeProvider.tenantList[0].tenant?.fullName ?? "Unknown";
          isSelected =
              homeProvider.tenantList[0].tenant?.fullName == selectedValue;
          authProvider.tenantID = homeProvider.tenantList[0].tenant?.id;
          authProvider
              .chooseTenant(homeProvider.tenantList[0].tenant?.id ?? '');
          _fetcheAllData = _getTasks();
        }
      }
    });

    super.initState();
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

  late Future _fetcheAllData;

  bool isSelected = false;
  @override
  Widget build(BuildContext context) {
    final Routers routers = Routers();
    DateTime now = DateTime.now();
    final notificationProvider = Provider.of<NotificationProvider>(
      context,
    );
    String formattedDate = DateFormat('dd MMM,yyyy EEEE', 'en').format(now);

    final sizeh = MediaQuery.of(context).size.height;
    final sizew = MediaQuery.of(context).size.width;
    final homeProvider = Provider.of<HomeProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      backgroundColor: innerBackgroundColor,
      body: FutureBuilder(
        future: _fetcheAllData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return HomeSkeleton();
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          if (snapshot.hasData) {
            if (snapshot.data is Failure) {
              return Center(child: TextWidget(snapshot.data.toString()));
            }

            //
            //  print("snapshot data is ${snapshot.data}");
            return RefreshIndicator(
              onRefresh: () async {
                _fetcheAllData = Future.wait(
                    [_getNotifications(), _getTenants(), _getTasks()]);
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: sizew * .035, vertical: sizeh * .015),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: sizeh * .06,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Subrate',
                                style: AppTextStyles.semiBold.copyWith(
                                    fontSize: 17.sp, color: primaryColor),
                              ),
                              SizedBox(
                                height: sizeh * .004,
                              ),
                              Text(
                                formattedDate,
                                style: AppTextStyles.bold.copyWith(
                                    fontSize: 10.sp, color: yallewTextColor),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              badges.Badge(
                                position: notificationProvider
                                        .notificationList.isEmpty
                                    ? badges.BadgePosition.topStart(
                                        top: 0, start: 20)
                                    : badges.BadgePosition.topStart(
                                        top: -5, start: 30),
                                showBadge: notificationProvider
                                        .notificationList.isEmpty
                                    ? false
                                    : true,
                                ignorePointer: false,
                                onTap: () {},
                                badgeContent: Text(
                                  '',
                                  style: TextStyle(
                                      fontSize: 9.sp,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400),
                                ),
                                badgeAnimation: badges.BadgeAnimation.rotation(
                                  animationDuration: Duration(seconds: 1),
                                  colorChangeAnimationDuration:
                                      Duration(seconds: 1),
                                  loopAnimation: false,
                                  curve: Curves.fastOutSlowIn,
                                  colorChangeAnimationCurve: Curves.easeInCubic,
                                ),
                                badgeStyle: badges.BadgeStyle(
                                  shape: badges.BadgeShape.circle,
                                  badgeColor: Color(0xFFFF5656),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: sizew * .015,
                                      vertical: sizeh * .0),
                                  elevation: 0,
                                ),
                                child: InkWell(
                                  onTap: () {
                                    routers
                                        .navigateToNotificationsScreen(context);
                                  },
                                  child: SvgPicture.asset(
                                    notification,
                                    height: sizeh * .043,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: sizew * .02,
                              ),
                              // Row(
                              //   children: [
                              //     SvgPicture.asset(
                              //       yallewLogo,
                              //       height: sizeh * .043,
                              //     ),
                              //     Icon(
                              //       Icons.keyboard_arrow_down_rounded,
                              //       color: primaryColor,
                              //     )
                              //   ],
                              // ),
                              PopupMenuButton<String>(
                                color: const Color(
                                    0xFF2D2E34), // Dark background color
                                onSelected: (value) {
                                  setState(() {
                                    selectedValue = value;
                                  });
                                },
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      yallewLogo, // Your SVG asset
                                      height: sizeh * 0.043,
                                    ),
                                    const Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      color: primaryColor, // Primary color
                                    ),
                                  ],
                                ),
                                itemBuilder: (
                                  BuildContext context,
                                ) {
                                  return homeProvider.tenantList
                                      .map<PopupMenuEntry<String>>(
                                          (TenantModel model) {
                                    isSelected =
                                        model.tenant?.fullName == selectedValue;

                                    return PopupMenuItem<String>(
                                      onTap: () {
                                        authProvider.tenantID =
                                            model.tenant?.id;
                                        authProvider.chooseTenant(
                                            model.tenant?.id ?? '');
                                        print(authProvider.tenantID);
                                        _fetcheAllData = Future.wait([
                                          _getNotifications(),
                                          _getTasks(),
                                        ]);
                                      },
                                      value: model.tenant?.fullName,
                                      child: Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                              color:
                                                  yallewTextColor, // Icon background color
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: SvgPicture.asset(
                                              yallewLogo,
                                              height: sizeh * .025,
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Text(
                                            model.tenant?.fullName ?? "Unknown",
                                            style:
                                                AppTextStyles.regular.copyWith(
                                              fontSize: 10.sp,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const Spacer(),
                                          if (isSelected)
                                            SvgPicture.asset(
                                              checkedWorkspace,
                                              height: sizeh * .02,
                                            ),
                                        ],
                                      ),
                                    );
                                  }).toList();
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: sizeh * .025,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: sizew * .035),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  LocaleKeys.tasks.tr(),
                                  style: AppTextStyles.semiBold.copyWith(
                                      fontSize: 13.sp, color: primaryColor),
                                ),
                                Text(
                                  '${homeProvider.taskModel?.completedTaskCount ?? 0} ${LocaleKeys.completed.tr()}',
                                  style: AppTextStyles.semiBold.copyWith(
                                      fontSize: 11.sp, color: primaryColor),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: sizeh * .02,
                      ),
                      FutureBuilder(
                        future: _fetcheAllData,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return SizedBox();
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

                              return Center(
                                  child: TextWidget(snapshot.data.toString()));
                            }
                            final provider = Provider.of<HomeProvider>(context);
                            final appProvider =
                                Provider.of<AppProvider>(context);
                            var getTaskLists = provider.tasksList;
                            return getTaskLists.isNotEmpty
                                ? Container(
                                    margin: EdgeInsets.symmetric(
                                        vertical: sizeh * .005),
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      padding: EdgeInsets.zero,
                                      itemCount: getTaskLists.length,
                                      itemBuilder: (context, index) {
                                        return InkWell(
                                          onTap: () {
                                            routers
                                                .navigateToTasksDescriptionScreen(
                                                    context,
                                                    args: {
                                                  'title': getTaskLists[index]
                                                          .task
                                                          ?.title ??
                                                      '',
                                                  'id':
                                                      getTaskLists[index].id ??
                                                          ''
                                                });
                                          },
                                          child: buildTaskCard(
                                            sizew,
                                            sizeh,
                                            isActive: true,
                                            date: appProvider.dateFormat.format(
                                                DateTime.parse(
                                                    getTaskLists[index]
                                                            .task
                                                            ?.deadlineDate ??
                                                        '')),
                                            groupName: getTaskLists[index]
                                                    .group
                                                    ?.name ??
                                                '',
                                            points: getTaskLists[index]
                                                    .task
                                                    ?.point
                                                    .toString() ??
                                                '',
                                            programLength: getTaskLists[index]
                                                    .task
                                                    ?.programs
                                                    ?.length
                                                    .toString() ??
                                                '',
                                            taskDetails: getTaskLists[index]
                                                    .task
                                                    ?.description ??
                                                '',
                                            title: getTaskLists[index]
                                                    .task
                                                    ?.title ??
                                                '',
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                : Container(
                                    width: sizew,
                                    decoration: BoxDecoration(
                                      color: backgroundColor,
                                      borderRadius: BorderRadius.circular(5),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black
                                              .withOpacity(0.1), // Shadow color
                                          blurRadius: 8.0, // Blur radius
                                          spreadRadius: 3.0, // Spread radius
                                          offset: const Offset(
                                              0, 4), // Shadow position
                                        ),
                                      ],
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: sizew * .035,
                                        vertical: sizeh * .02),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: sizeh * .025,
                                        ),
                                        Text(
                                          LocaleKeys.tasks.tr(),
                                          style: AppTextStyles.semiBold
                                              .copyWith(
                                                  fontSize: 13.sp,
                                                  color: primaryColor),
                                        ),
                                        SizedBox(
                                          height: sizeh * .03,
                                        ),
                                        Center(
                                          child: Text(
                                            LocaleKeys.no_tasks.tr(),
                                            textAlign: TextAlign.center,
                                            style: AppTextStyles.regular
                                                .copyWith(
                                                    fontSize: 11.sp,
                                                    color: Colors.black),
                                          ),
                                        ),
                                        SizedBox(
                                          height: sizeh * .025,
                                        ),
                                      ],
                                    ),
                                  );
                          }
                          return Container();
                        },
                      ),
                      // Container(
                      //   margin: EdgeInsets.symmetric(vertical: sizeh * .01),
                      //   child: buildTaskCard(sizew, sizeh,
                      //       isActive: false,
                      //       title: 'Task 2',
                      //       taskDetails: 'Task Details 2',
                      //       groupName: '2',
                      //       programLength: '2',
                      //       points: '2',
                      //       date: DateFormat('dd MMM,yyyy').format(now)),
                      // ),
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

  Widget buildTaskCard(double sizew, double sizeh,
      {required bool isActive,
      required String title,
      required String taskDetails,
      required String groupName,
      required String programLength,
      required String points,
      required String date}) {
    // Format the date as "29 Oct, 2024 Tuesday"
    return Container(
      margin: EdgeInsets.only(bottom: sizeh * .02),
      decoration: BoxDecoration(
        color: isActive ? Colors.white : const Color(0xFFE3E3E3),
        border: Border.all(
            color: isActive ? primaryColor : Colors.transparent, width: 1),
        borderRadius: BorderRadius.circular(5),
      ),
      padding:
          EdgeInsets.symmetric(horizontal: sizew * .04, vertical: sizeh * .01),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: sizew * .35,
                    child: Text(
                      title,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.regular.copyWith(
                          color: isActive ? primaryColor : fontPrimaryColor,
                          fontSize: 12.sp),
                    ),
                  ),
                  SizedBox(
                    height: sizeh * .005,
                  ),
                  SizedBox(
                    width: sizew * .35,
                    child: Text(
                      taskDetails,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.regular.copyWith(
                          color: isActive ? primaryColor : fontPrimaryColor,
                          fontSize: 10.sp),
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  SvgPicture.asset(groupsIcon,
                      height: sizeh * .02,
                      color: isActive ? yallewTextColor : fontPrimaryColor),
                  SizedBox(
                    width: sizew * .02,
                  ),
                  Text(
                    '$groupName',
                    style: AppTextStyles.extraLight.copyWith(
                        color: isActive ? primaryColor : fontPrimaryColor,
                        fontSize: 11.sp),
                  )
                ],
              )
            ],
          ),
          SizedBox(
            height: sizeh * .015,
          ),
          DashedDivider(),
          SizedBox(
            height: sizeh * .01,
          ),
          SizedBox(
            width: sizew,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildIcon(
                  progrmsIcon,
                  '$programLength Program',
                  isActive,
                  sizew,
                  sizeh,
                ),
                buildIcon(pointsIcon, '$points ${LocaleKeys.points.tr()}',
                    isActive, sizew, sizeh),
                buildIcon(calendarHome, date, isActive, sizew, sizeh),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildIcon(
      String iconPath, String text, bool isActive, double sizew, double sizeh) {
    return Row(
      children: [
        SvgPicture.asset(iconPath,
            height: sizeh * .025,
            color: isActive ? yallewTextColor : fontPrimaryColor),
        SizedBox(
          width: sizew * .01,
        ),
        Text(
          text,
          style: AppTextStyles.extraLight.copyWith(
              color: isActive ? primaryColor : fontPrimaryColor,
              fontSize: 9.sp),
        )
      ],
    );
  }
}

class DashedDivider extends StatelessWidget {
  const DashedDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(double.infinity, 10), // The height of the divider
      painter: DashedLinePainter(),
    );
  }
}

class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = primaryColor.withOpacity(.4) // The color of the dashed line
      ..strokeWidth = 1 // The width of the line
      ..style = PaintingStyle.stroke;

    final double dashWidth = 8.0; // Width of each dash
    final double dashSpace = 4.0; // Space between dashes

    double startX = 0.0;
    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + dashWidth, 0),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
