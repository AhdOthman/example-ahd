import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:subrate/api_url.dart';
import 'package:subrate/provider/appprovider.dart';
import 'package:subrate/provider/authprovider.dart';
import 'package:subrate/provider/profileprovider.dart';
import 'package:subrate/provider/storageprovider.dart';
import 'package:subrate/routers/routers.dart';
import 'package:subrate/theme/app_colors.dart';
import 'package:subrate/theme/assets_managet.dart';
import 'package:subrate/theme/failure.dart';
import 'package:subrate/theme/text_style.dart';
import 'package:subrate/theme/ui_helper.dart';
import 'package:subrate/translations/locale_keys.g.dart';
import 'package:subrate/widgets/app/loadingdialog.dart';
import 'package:subrate/widgets/app/text_widget.dart';
import 'package:subrate/widgets/appskeleton/profile_skeleton.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = 'profile-screen';
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future _fetchProfileData;

  Future _getProfile() async {
    final profileProvider =
        Provider.of<Profileprovider>(context, listen: false);
    return await profileProvider.getProfileData(context);
  }

  @override
  void initState() {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    appProvider.getCountries();
    _fetchProfileData = _getProfile();
    _getProfile();
    super.initState();
  }

  final ImagePicker _picker = ImagePicker();
  XFile? _image;
  XFile? imagePath;

  setImage() async {
    final image = await _picker.pickImage(source: ImageSource.gallery);
    final profileProvider =
        Provider.of<Profileprovider>(context, listen: false);
    final storageProvider =
        Provider.of<StorageProvider>(context, listen: false);
    if (image != null) {
      setState(() {
        _image = image;
      });
      loadingDialog(context);

      storageProvider
          .uploadFile(imageFile: image, context: context)
          .then((value) {
        if (value == true) {
          profileProvider
              .editProfilePicture(picturePath: storageProvider.resultLink!)
              .then((value) {
            Navigator.pop(context);
            if (value == true) {
              setState(() {
                imagePath = _image;
              });
            }
          });
        }
      });
    }
    print(image);

    print(image);
  }

  void logoutFun() async {
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
  Widget build(BuildContext context) {
    final sizeh = MediaQuery.of(context).size.height;
    final sizew = MediaQuery.of(context).size.width;
    final profileProvider = Provider.of<Profileprovider>(
      context,
    );

    final Routers routers = Routers();
    final authProvider = Provider.of<AuthProvider>(context, listen: true);
    final appProvider = Provider.of<AppProvider>(context, listen: true);

    return Scaffold(
      backgroundColor: innerBackgroundColor,
      body: FutureBuilder(
        future: _fetchProfileData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ProfileSkeleton();
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          if (snapshot.hasData) {
            if (snapshot.data is Failure) {
              if (snapshot.data.toString().contains('401')) {
                logoutFun();
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
                    SizedBox(height: sizeh * .045),
                    Text(
                      LocaleKeys.profile.tr(),
                      style: AppTextStyles.semiBold
                          .copyWith(fontSize: 16.sp, color: primaryColor),
                    ),
                    SizedBox(height: sizeh * .03),
                    Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            height: appProvider.isTablet(context) ? 130 : 90,
                            width: appProvider.isTablet(context) ? 130 : 90,
                            child: CustomPaint(
                              painter: FourDashedCirclePainter(
                                color: yallewTextColor,
                                strokeWidth:
                                    appProvider.isTablet(context) ? 3 : 2,
                                dashLength:
                                    appProvider.isTablet(context) ? 40 : 40,
                              ),
                            ),
                          ),
                          imagePath?.path != null
                              ? CircleAvatar(
                                  backgroundImage:
                                      FileImage(File(_image!.path)),
                                  radius:
                                      appProvider.isTablet(context) ? 60 : 40,
                                  backgroundColor: Colors.white,
                                )
                              : CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: appProvider.isTablet(context)
                                      ? 60
                                      : 40, // Small photo radius
                                  backgroundImage: NetworkImage(profileProvider
                                              .profileModel?.picture !=
                                          null
                                      ? '$downloadPhoto${profileProvider.profileModel?.picture}'
                                      : 'https://static.vecteezy.com/system/resources/previews/041/642/170/non_2x/ai-generated-portrait-of-handsome-smiling-young-man-with-folded-arms-isolated-free-png.png'), // Replace with your asset image
                                ),
                          Positioned(
                              bottom: 5,
                              right: 5,
                              child: InkWell(
                                onTap: setImage,
                                child: SvgPicture.asset(
                                  edit,
                                  color: Colors.black,
                                  height: sizeh * .02,
                                ),
                              )),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: sizeh * .015,
                    ),
                    Center(
                      child: Text(
                        '${profileProvider.profileModel?.firstName ?? ''} ${profileProvider.profileModel?.lastName ?? ''}',
                        style: AppTextStyles.bold
                            .copyWith(fontSize: 12.sp, color: primaryColor),
                      ),
                    ),
                    SizedBox(
                      height: sizeh * .005,
                    ),
                    Center(
                      child: Text(
                        profileProvider.profileModel?.phone ?? '',
                        style: AppTextStyles.bold
                            .copyWith(fontSize: 12.sp, color: primaryColor),
                      ),
                    ),
                    SizedBox(
                      height: sizeh * .035,
                    ),
                    Text(
                      LocaleKeys.account_overview.tr(),
                      style: AppTextStyles.semiBold
                          .copyWith(fontSize: 13.sp, color: primaryColor),
                    ),
                    SizedBox(
                      height: sizeh * .025,
                    ),
                    InkWell(
                      onTap: () {
                        routers.navigateToMyAccountScreen(context);
                      },
                      child: buildProfileCard(sizeh, sizew,
                          iconPath: profileCardIcon,
                          title: LocaleKeys.my_account.tr(),
                          containerColor: Color(0xFFFBBC05).withOpacity(.2)),
                    ),
                    InkWell(
                      onTap: () {
                        routers.navigateToPaymentMethodsScreen(context);
                      },
                      child: buildProfileCard(sizeh, sizew,
                          iconPath: walletProfileIcon,
                          title: LocaleKeys.payment_methods.tr(),
                          containerColor: Color(0xFFEA4335).withOpacity(.2)),
                    ),
                    InkWell(
                      onTap: () {
                        routers.navigateToKycVerificationScreen(context);
                      },
                      child: buildProfileCard(sizeh, sizew,
                          iconPath: verifyProfileIcon,
                          title: LocaleKeys.kyc_ver.tr(),
                          containerColor: Color(0xFF1976D2).withOpacity(.2)),
                    ),
                    InkWell(
                      onTap: () {
                        routers.navigateToSettingsScreen(context);
                      },
                      child: buildProfileCard(sizeh, sizew,
                          iconPath: settingsProfileIcon,
                          title: LocaleKeys.settings.tr(),
                          containerColor: Color(0xFFA6A6A6).withOpacity(.2)),
                    ),
                    SizedBox(height: sizeh * .05),
                    InkWell(
                      onTap: () {
                        authProvider.logout(context);
                      },
                      child: Row(
                        children: [
                          SvgPicture.asset(logout, height: sizeh * .04),
                          SizedBox(
                            width: sizew * .02,
                          ),
                          Text(
                            LocaleKeys.logout.tr(),
                            style: AppTextStyles.semiBold.copyWith(
                                fontSize: 13.5.sp, color: fontPrimaryColor),
                          ),
                        ],
                      ),
                    )
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

  Widget buildProfileCard(double sizeh, double sizew,
      {required String iconPath,
      required String title,
      required Color containerColor}) {
    return Container(
      margin: EdgeInsets.only(bottom: sizeh * .02),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: sizew * .03, vertical: sizeh * .012),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  color: containerColor,
                ),
                child: SvgPicture.asset(iconPath, height: sizeh * .035),
              ),
              SizedBox(
                width: sizew * .03,
              ),
              Text(
                title,
                style: AppTextStyles.semiBold
                    .copyWith(fontSize: 12.sp, color: primaryColor),
              ),
            ],
          ),
          Icon(
            Icons.arrow_forward_ios_rounded,
            color: primaryColor,
          )
        ],
      ),
    );
  }
}

class FourDashedCirclePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashLength;

  FourDashedCirclePainter({
    required this.color,
    this.strokeWidth = 2,
    this.dashLength = 15,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final double radius = size.width / 2;

    const double totalDashes = 4;
    const double startAngle = -90;
    final double spaceBetweenDashes = 90;

    for (int i = 0; i < totalDashes; i++) {
      final double currentAngle = startAngle + (i * spaceBetweenDashes);
      canvas.drawArc(
        Rect.fromCircle(center: Offset(radius, radius), radius: radius),
        radians(currentAngle),
        radians(dashLength),
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  double radians(double degrees) => degrees * (3.141592653589793 / 180);
}
