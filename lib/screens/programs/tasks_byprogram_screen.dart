import 'package:better_player_plus/better_player_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:subrate/provider/appprovider.dart';
import 'package:subrate/provider/programprovider.dart';
import 'package:subrate/routers/routers.dart';
import 'package:subrate/theme/app_colors.dart';
import 'package:subrate/theme/assets_managet.dart';
import 'package:subrate/theme/failure.dart';
import 'package:subrate/theme/text_style.dart';
import 'package:subrate/translations/locale_keys.g.dart';
import 'package:subrate/widgets/app/button.dart';
import 'package:subrate/widgets/app/text_widget.dart';
import 'package:subrate/widgets/appskeleton/skeleton_container.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class TasksByProgramsDetailsScreen extends StatefulWidget {
  static const String routeName = '/tasks-details-screen';
  const TasksByProgramsDetailsScreen({super.key});

  @override
  State<TasksByProgramsDetailsScreen> createState() =>
      _TasksDetailsScreenState();
}

class _TasksDetailsScreenState extends State<TasksByProgramsDetailsScreen> {
  Future _getTasksByPrograms(String programId) async {
    final programProvider =
        Provider.of<ProgramProvider>(context, listen: false);
    return await programProvider.getTasksByPrograms(programId: programId);
  }

  late Future _fetcheTasksByPrograms;

  var _isInit = true;
  @override
  void didChangeDependencies() {
    if (_isInit) {
      final argumets =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      _fetcheTasksByPrograms =
          _getTasksByPrograms(argumets['programId']).whenComplete(() {
        Future.delayed(const Duration(seconds: 1), () {
          _initializePlayer();
        });
      });

      // homeProvider.getRecentlyProducts(page: 1);
      // homeProvider.getHomeData();
    }
    _isInit = false;
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  String videoUrl =
      //'https://www.youtube.com/watch?v=vCE-Iwh_Uac&ab_channel=KhaderAbbas%2F%D8%AE%D8%B6%D8%B1%D8%B9%D8%A8%D8%A7%D8%B3';
      'https://test-videos.co.uk/vids/bigbuckbunny/mp4/h264/720/Big_Buck_Bunny_720_10s_1MB.mp4';
  BetterPlayerController? _betterPlayerController;
  YoutubePlayerController? _youtubePlayerController;
  bool _isYouTubeLink = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
  }

  bool _isLoading = true;

  /// Check if the URL is a YouTube link
  bool _isYouTube(String url) {
    return url.contains("youtube.com") || url.contains("youtu.be");
  }

  /// Initialize the appropriate player based on the URL type
  void _initializePlayer() {
    final programProvider =
        Provider.of<ProgramProvider>(context, listen: false);
    videoUrl = programProvider.tasksByProgramModel?.link ?? '';
    print(videoUrl);
    try {
      if (_isYouTube(videoUrl)) {
        setState(() {
          _isLoading = false;
        });
        _isYouTubeLink = true;
        _youtubePlayerController = YoutubePlayerController(
          initialVideoId: YoutubePlayer.convertUrlToId(videoUrl) ?? "",
          flags: const YoutubePlayerFlags(
            autoPlay: true,
            mute: false,
          ),
        );
      } else {
        setState(() {
          _isLoading = false;
        });
        _isYouTubeLink = false;
        _betterPlayerController = BetterPlayerController(
          const BetterPlayerConfiguration(
            autoPlay: false,
            looping: false,
          ),
          betterPlayerDataSource: BetterPlayerDataSource(
            BetterPlayerDataSourceType.network,
            videoUrl,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _hasError = true;
      });
    }
  }

  @override
  void dispose() {
    _betterPlayerController?.dispose();
    _youtubePlayerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sizeh = MediaQuery.of(context).size.height;
    final sizew = MediaQuery.of(context).size.width;
    final appProvider = Provider.of<AppProvider>(context);
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
                    LocaleKeys.programs.tr(),
                    style: AppTextStyles.semiBold
                        .copyWith(fontSize: 17.sp, color: primaryColor),
                  ),
                ],
              ),
              SizedBox(
                height: sizeh * .035,
              ),
              _isLoading
                  ? Center(
                      child: SkeletonContainer(
                        radius: 5,
                        width: sizew,
                        height: sizeh * .2,
                      ),
                    )
                  : _hasError
                      ? const Center(
                          child: Text(
                            "Error loading video. Please check the URL.",
                            style: TextStyle(color: Colors.red, fontSize: 18),
                          ),
                        )
                      : _isYouTubeLink
                          ? YoutubePlayer(
                              controller: _youtubePlayerController!,
                              showVideoProgressIndicator: true,
                              onReady: () {
                                print("YouTube Player is ready.");
                              },
                              onEnded: (metaData) {
                                print("YouTube video has ended.");
                              },
                            )
                          : BetterPlayer(
                              controller: _betterPlayerController!,
                            ),
              // Container(
              //   width: sizew,
              //   height: sizeh * .2,
              //   decoration: BoxDecoration(
              //       color: Color(0xFF587EDC),
              //       borderRadius: BorderRadius.circular(5)),
              // ),

              SizedBox(
                height: sizeh * .025,
              ),
              Text(
                LocaleKeys.tasks.tr(),
                style: AppTextStyles.semiBold
                    .copyWith(fontSize: 14.sp, color: primaryColor),
              ),
              SizedBox(
                height: sizeh * .025,
              ),
              FutureBuilder(
                future: _fetcheTasksByPrograms,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                        margin: EdgeInsets.symmetric(vertical: sizeh * .005),
                        child: ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: 3,
                            itemBuilder: (context, index) {
                              return _buildTaskByProgramsSkeleton();
                            }));
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }
                  if (snapshot.hasData) {
                    if (snapshot.data is Failure) {
                      return Center(
                          child: TextWidget(snapshot.data.toString()));
                    }
                    final provider = Provider.of<ProgramProvider>(context);

                    var getProgramsList = provider.tasksByProgramList;
                    return getProgramsList.isNotEmpty
                        ? Container(
                            margin:
                                EdgeInsets.symmetric(vertical: sizeh * .005),
                            child: ListView.builder(
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: getProgramsList.length,
                                itemBuilder: (context, index) {
                                  return buildTaskCard(sizeh, sizew,
                                      index: index,
                                      dateTime:
                                          getProgramsList[index].deadline ?? '',
                                      taskTitle:
                                          getProgramsList[index].title ?? '',
                                      taskDescription:
                                          getProgramsList[index].description ??
                                              '',
                                      points: getProgramsList[index]
                                          .point
                                          .toString(),
                                      date: appProvider.dateFormat.format(
                                          DateTime.parse(
                                              getProgramsList[index].deadline ??
                                                  '')),
                                      taskID: getProgramsList[index]
                                              .submissions?[0]
                                              .id ??
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
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTaskCard(double sizeh, double sizew,
      {required int index,
      required String taskTitle,
      required String taskDescription,
      required String points,
      required String date,
      required String dateTime,
      required String taskID}) {
    final Routers routers = Routers();
    return Container(
      margin: EdgeInsets.only(bottom: sizeh * .015),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: yallewTextColor)),
                    padding: EdgeInsets.all(
                        12), // Padding to control the circle size
                    child: Text(
                      '${index + 1}',
                      style: AppTextStyles.regular
                          .copyWith(fontSize: 12.sp, color: Colors.black),
                    ),
                  ),
                  SizedBox(
                    width: sizew * .025,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: sizew * .4,
                        child: Text(
                          taskTitle,
                          style: AppTextStyles.regular
                              .copyWith(fontSize: 11.sp, color: primaryColor),
                        ),
                      ),
                      SizedBox(height: sizeh * .005),
                      SizedBox(
                        width: sizew * .4,
                        child: Text(
                          taskDescription,
                          style: AppTextStyles.extraLight.copyWith(
                              fontSize: 11.sp, color: fontPrimaryColor),
                        ),
                      )
                    ],
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildIcon(pointsIcon, '$points ${LocaleKeys.points.tr()}',
                      sizew, sizeh),
                  SizedBox(height: sizeh * .005),
                  buildIcon(calendarHome, date, sizew, sizeh),
                ],
              )
            ],
          ),
          SizedBox(
            height: sizeh * .04,
          ),
          DateTime.parse(dateTime).isBefore(DateTime.now())
              ? SizedBox()
              : ButtonWidget(
                  text: LocaleKeys.start.tr(),
                  onPress: () {
                    routers.navigateToTasksDescriptionScreen(context,
                        args: {'title': taskTitle, 'id': taskID});
                  },
                  buttonColor: Colors.transparent,
                  borderColor: primaryColor,
                  textColor: primaryColor,
                  radius: 5,
                  width: sizew * .5,
                  height: sizeh * .055,
                  textStyle: AppTextStyles.regular.copyWith(
                    fontSize: 13.sp,
                    color: primaryColor,
                  ),
                )
        ],
      ),
    );
  }

  Widget buildIcon(String iconPath, String text, double sizew, double sizeh) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SvgPicture.asset(iconPath, height: sizeh * .02, color: yallewTextColor),
        SizedBox(
          width: sizew * .01,
        ),
        Text(
          text,
          style: AppTextStyles.extraLight
              .copyWith(color: primaryColor, fontSize: 9.sp),
        )
      ],
    );
  }

  Widget _buildTaskByProgramsSkeleton() {
    final sizeh = MediaQuery.of(context).size.height;
    final sizew = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.only(bottom: sizeh * .015),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SkeletonContainer.square(
                      height: sizeh * .04, width: sizew * .09, radius: 100),
                  SizedBox(
                    width: sizew * .015,
                  ),
                  Column(
                    children: [
                      SkeletonContainer(
                        height: sizeh * .015,
                        width: sizew * .3,
                        radius: 0,
                      ),
                      SizedBox(
                        height: sizeh * .01,
                      ),
                      SkeletonContainer(
                        height: sizeh * .015,
                        width: sizew * .3,
                        radius: 0,
                      ),
                    ],
                  )
                ],
              ),
              Column(
                children: [
                  Row(
                    children: [
                      SkeletonContainer(
                        height: sizeh * .025,
                        width: sizew * .055,
                        radius: 7,
                      ),
                      SizedBox(
                        width: sizew * .01,
                      ),
                      SkeletonContainer(
                        height: sizeh * .015,
                        width: sizew * .2,
                        radius: 0,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: sizeh * .01,
                  ),
                  Row(
                    children: [
                      SkeletonContainer(
                        height: sizeh * .025,
                        width: sizew * .055,
                        radius: 7,
                      ),
                      SizedBox(
                        width: sizew * .01,
                      ),
                      SkeletonContainer(
                        height: sizeh * .015,
                        width: sizew * .2,
                        radius: 0,
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
          SizedBox(
            height: sizeh * .04,
          ),
          Center(
            child: SkeletonContainer(
              radius: 5,
              width: sizew * .45,
              height: sizeh * .047,
            ),
          )
        ],
      ),
    );
  }
}
