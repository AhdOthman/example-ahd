import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:subrate/provider/authprovider.dart';
import 'package:subrate/provider/programprovider.dart';
import 'package:subrate/routers/routers.dart';
import 'package:subrate/theme/app_colors.dart';
import 'package:subrate/theme/assets_managet.dart';
import 'package:subrate/theme/failure.dart';
import 'package:subrate/theme/text_style.dart';
import 'package:subrate/theme/ui_helper.dart';
import 'package:subrate/translations/locale_keys.g.dart';
import 'package:subrate/widgets/app/text_widget.dart';
import 'package:subrate/widgets/appskeleton/programs_skeleton.dart';

class ProgramsScreen extends StatefulWidget {
  const ProgramsScreen({super.key});

  @override
  State<ProgramsScreen> createState() => _ProgramsScreenState();
}

class _ProgramsScreenState extends State<ProgramsScreen> {
  List<Color> iconColors = [
    yallewTextColor,
    programIconSecondColor,
    programIconThirdColor,
    programIconForthColor
  ];
  List<Color> boxColors = [
    programFirstWithOpicity,
    programSeconsWithOpicity,
    programThirdWithOpicity,
    programForthWithOpicity
  ];
  Future _getPrograms() async {
    final programProvider =
        Provider.of<ProgramProvider>(context, listen: false);
    return await programProvider.getPrograms();
  }

  @override
  void initState() {
    _fetcheAllData = _getPrograms();

    super.initState();
  }

  late Future _fetcheAllData;

  @override
  Widget build(BuildContext context) {
    final sizeh = MediaQuery.of(context).size.height;
    final sizew = MediaQuery.of(context).size.width;
    final Routers routers = Routers();
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      backgroundColor: innerBackgroundColor,
      body: Container(
        padding: EdgeInsets.symmetric(
            horizontal: sizew * .035, vertical: sizeh * .015),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: sizeh * .06,
              ),
              Text(
                LocaleKeys.programs.tr(),
                style: AppTextStyles.semiBold
                    .copyWith(fontSize: 17.sp, color: primaryColor),
              ),
              SizedBox(
                height: sizeh * .02,
              ),
              authProvider.tenantID == null
                  ? Center(
                      child: Text('Please Select Tenant'),
                    )
                  : FutureBuilder(
                      future: _fetcheAllData,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return ProgramsSkeleton();
                        }
                        if (snapshot.hasError) {
                          return Center(
                            child: authProvider.tenantID == null
                                ? Center(
                                    child: Text('Please Select Tenant'),
                                  )
                                : Text('Error: ${snapshot.error}'),
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
                            return authProvider.tenantID == null
                                ? Center(
                                    child: Text('Please Select Tenant'),
                                  )
                                : Center(
                                    child:
                                        TextWidget(snapshot.data.toString()));
                          }
                          final provider =
                              Provider.of<ProgramProvider>(context);

                          var getProgramsList = provider.programsList;
                          return getProgramsList.isNotEmpty
                              ? Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: sizeh * .005),
                                  child: GridView.builder(
                                    shrinkWrap: true,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: sizew * .02),
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            crossAxisSpacing: 20,
                                            mainAxisSpacing: 20,
                                            childAspectRatio: 28 / 14,
                                            mainAxisExtent: sizeh * 0.16),
                                    itemBuilder: (context, index) {
                                      Color boxColor =
                                          boxColors[index % boxColors.length];
                                      Color iconColor =
                                          iconColors[index % iconColors.length];

                                      return InkWell(
                                        onTap: () {
                                          routers
                                              .navigateToTasksByProgramsScreen(
                                                  context,
                                                  args: {
                                                'programId':
                                                    getProgramsList[index].id
                                              });
                                        },
                                        child: buildProgramCard(
                                          sizew,
                                          sizeh,
                                          iconColor: iconColor,
                                          boxColor: boxColor,
                                          tasksLength: getProgramsList[index]
                                                  .tasks
                                                  ?.length
                                                  .toString() ??
                                              '',
                                          titleProgram:
                                              getProgramsList[index].title ??
                                                  '',
                                        ),
                                      );
                                    },
                                    itemCount: getProgramsList.length,
                                  ),
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
                height: sizeh * .04,
              ),
              //
            ],
          ),
        ),
      ),
    );
  }

  Widget buildProgramCard(double sizew, double sizeh,
      {required Color iconColor,
      required Color boxColor,
      required String titleProgram,
      required String tasksLength}) {
    return Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.2), // Shadow color with transparency
          spreadRadius: 1, // How much the shadow spreads
          blurRadius: 8, // The blur intensity
          offset: Offset(0, 2), // Offset in the x and y direction
        ),
      ], color: Colors.white, borderRadius: BorderRadius.circular(5)),
      padding:
          EdgeInsets.symmetric(horizontal: sizew * .04, vertical: sizeh * .015),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              padding: EdgeInsets.symmetric(
                  horizontal: sizew * .025, vertical: sizeh * .01),
              decoration: BoxDecoration(
                  color: boxColor, borderRadius: BorderRadius.circular(4)),
              child: SvgPicture.asset(
                programCardIcon,
                color: iconColor,
                height: sizeh * .025,
              )),
          SizedBox(
            height: sizeh * .01,
          ),
          Text(titleProgram,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.bold
                  .copyWith(fontSize: 13.sp, color: primaryColor)),
          SizedBox(
            height: sizeh * .02,
          ),
          Row(
            children: [
              SvgPicture.asset(
                taskIcon,
              ),
              SizedBox(
                width: sizew * .02,
              ),
              Text(
                '$tasksLength ${LocaleKeys.tasks.tr()}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.regular
                    .copyWith(fontSize: 10.sp, color: fontPrimaryColor),
              )
            ],
          )
        ],
      ),
    );
  }
}
