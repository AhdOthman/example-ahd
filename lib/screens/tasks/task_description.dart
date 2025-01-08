import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:subrate/models/tasks/submit_task_model.dart';
import 'package:subrate/provider/homeprovider.dart';
import 'package:subrate/provider/storageprovider.dart';
import 'package:subrate/provider/taskprovider.dart';
import 'package:subrate/theme/app_colors.dart';
import 'package:subrate/theme/assets_managet.dart';
import 'package:subrate/theme/failure.dart';
import 'package:subrate/theme/text_style.dart';
import 'package:subrate/translations/locale_keys.g.dart';
import 'package:subrate/widgets/app/button.dart';
import 'package:subrate/widgets/app/text_widget.dart';
import 'package:subrate/widgets/appskeleton/taskdetails_skeleton.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../widgets/app/loadingdialog.dart';

class TaskDescriptionScreen extends StatefulWidget {
  static const routeName = 'task-desc-screen';
  const TaskDescriptionScreen({super.key});

  @override
  State<TaskDescriptionScreen> createState() => _TaskDescriptionScreenState();
}

class _TaskDescriptionScreenState extends State<TaskDescriptionScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? _image;
  String? imageResult;
  setImage() async {
    final storageProvider =
        Provider.of<StorageProvider>(context, listen: false);
    final image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      loadingDialog(context);
      storageProvider
          .uploadFile(imageFile: image, context: context)
          .then((value) {
        Navigator.pop(context);
        if (value == true) {
          imageResult == null ? Navigator.pop(context) : null;

          setState(() {
            imageResult = storageProvider.resultLink;
            _image = image;
          });
        }
      });
    }
    print(image);

    print(image);
  }

  Future<void> launchInWebView(Uri url) async {
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  Future _getTaskDetails(String taskID) async {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    return await taskProvider.getTaskDetails(taskID: taskID);
  }

  late Future _fetcheTaskDetails;

  var _isInit = true;
  @override
  void didChangeDependencies() {
    if (_isInit) {
      final argumets =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      _fetcheTaskDetails = _getTaskDetails(argumets['id']);

      // homeProvider.getRecentlyProducts(page: 1);
      // homeProvider.getHomeData();
    }
    _isInit = false;
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  bool isSubmitted = false;
  @override
  Widget build(BuildContext context) {
    final argumets =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final sizeh = MediaQuery.of(context).size.height;
    final sizew = MediaQuery.of(context).size.width;
    final taskProvider = Provider.of<TaskProvider>(
      context,
    );
    final homeProvider = Provider.of<HomeProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: _fetcheTaskDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return TaskdetailsSkeleton();
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
            return Container(
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
                                horizontal: sizew * .01,
                                vertical: sizeh * .005),
                            child:
                                Icon(Icons.arrow_back, color: yallewTextColor),
                          ),
                        ),
                        SizedBox(
                          width: sizew * .02,
                        ),
                        Text(
                          argumets['title'],
                          style: AppTextStyles.semiBold
                              .copyWith(fontSize: 14.sp, color: primaryColor),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: sizeh * .03,
                    ),
                    Text(
                      LocaleKeys.task_description.tr(),
                      style: AppTextStyles.semiBold
                          .copyWith(fontSize: 12.sp, color: primaryColor),
                    ),
                    SizedBox(
                      height: sizeh * .005,
                    ),
                    Text(taskProvider.taskDetailsModel?.task?.description ?? '',
                        style: AppTextStyles.regular
                            .copyWith(fontSize: 11.sp, color: primaryColor)),
                    SizedBox(
                      height: sizeh * .01,
                    ),
                    Text(
                      LocaleKeys.task_details.tr(),
                      style: AppTextStyles.semiBold
                          .copyWith(fontSize: 12.sp, color: primaryColor),
                    ),
                    SizedBox(
                      height: sizeh * .005,
                    ),
                    InkWell(
                      onTap: () {
                        launchUrl(Uri.parse(
                            taskProvider.taskDetailsModel?.task?.link ?? ''));
                      },
                      child: Text(
                          taskProvider.taskDetailsModel?.task?.link ?? '',
                          style: AppTextStyles.regular
                              .copyWith(fontSize: 11.sp, color: primaryColor)),
                    ),
                    SizedBox(
                      height: sizeh * .03,
                    ),
                    Text(
                      LocaleKeys.tasks_steps.tr(),
                      style: AppTextStyles.bold
                          .copyWith(fontSize: 13.sp, color: Colors.black),
                    ),
                    SizedBox(height: sizeh * .015),
                    ListView.builder(
                      itemCount:
                          taskProvider.taskDetailsModel?.task?.steps?.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        return buildTaskCard(
                          sizeh,
                          sizew,
                          index,
                          taskProvider.taskDetailsModel?.task?.steps?.length ??
                              0,
                          stepText: taskProvider.taskDetailsModel?.task
                                  ?.steps?[index].title ??
                              '',
                          stepTitle: taskProvider.taskDetailsModel?.task
                                  ?.steps?[index].title ??
                              '',
                        );
                      },
                    ),
                    SizedBox(
                      height: sizeh * .02,
                    ),
                    imageResult == null
                        ? SizedBox()
                        : Column(
                            children: [
                              Divider(
                                color: const Color(0xFFE3E3E3),
                              ),
                              SizedBox(
                                height: sizeh * .015,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(taskDoneIcon),
                                      SizedBox(
                                        width: sizew * .02,
                                      ),
                                      SizedBox(
                                          width: sizew * .7,
                                          child: Text(imageResult ?? '',
                                              style: AppTextStyles.regular
                                                  .copyWith(
                                                      fontSize: 9.sp,
                                                      color: primaryColor))),
                                    ],
                                  ),
                                  isSubmitted
                                      ? SizedBox()
                                      : InkWell(
                                          onTap: () {
                                            setImage();
                                          },
                                          child: SvgPicture.asset(edit)),
                                ],
                              ),
                              SizedBox(
                                height: sizeh * .025,
                              )
                            ],
                          ),
                    isSubmitted
                        ? SizedBox()
                        : Center(
                            child: ButtonWidget(
                              text: imageResult == null
                                  ? LocaleKeys.submit_task.tr()
                                  : LocaleKeys.task_done.tr(),
                              onPress: imageResult != null
                                  ? () {
                                      loadingDialog(context);
                                      taskProvider
                                          .submitTask(
                                              submitTaskModel: SubmitTaskModel(
                                                  taskSubmissionId:
                                                      argumets['id'],
                                                  attachment: imageResult))
                                          .then((valye) {
                                        Navigator.pop(context);
                                        if (valye == true) {
                                          homeProvider.getTasks();
                                          setState(() {
                                            isSubmitted = true;
                                          });
                                          showDialog(
                                            context: context,
                                            builder: (context) => buildDialog(),
                                          );
                                        }
                                      });
                                    }
                                  : () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => buildDialog(),
                                      );
                                    },
                              buttonColor: Colors.transparent,
                              borderColor: primaryColor,
                              textColor: primaryColor,
                              radius: 5,
                              borderWidth: 1,
                              width: sizew * .5,
                              height: sizeh * .05,
                              textStyle: AppTextStyles.regular.copyWith(
                                fontSize: 13.sp,
                                color: primaryColor,
                              ),
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

  Widget buildTaskCard(double sizeh, double sizew, int index, int length,
      {required String stepTitle, required String stepText}) {
    bool isLastItem = index == length - 1;

    return Container(
      margin: EdgeInsets.only(bottom: isLastItem ? 0 : sizeh * .015),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(stepIcon),
          SizedBox(
            width: sizew * .025,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${LocaleKeys.step.tr()} ${index + 1}',
                  style: AppTextStyles.regular
                      .copyWith(fontSize: 11.sp, color: primaryColor)),
              SizedBox(
                height: sizeh * .002,
              ),
              Text(stepTitle,
                  style: AppTextStyles.bold
                      .copyWith(fontSize: 11.5.sp, color: primaryColor)),
              SizedBox(
                height: sizeh * .002,
              ),
              // Row(
              //   children: [
              //     Text(stepText,
              //         style: AppTextStyles.regular
              //             .copyWith(fontSize: 11.5.sp, color: primaryColor)),
              //     SizedBox(
              //       width: sizew * .045,
              //     ),
              //     InkWell(
              //       onTap: () {
              //         Clipboard.setData(new ClipboardData(text: stepText));
              //       },
              //       child: SvgPicture.asset(
              //         copyIcon,
              //         height: sizeh * .02,
              //       ),
              //     ),
              //   ],
              // ),
            ],
          )
        ],
      ),
    );
  }

  Widget buildDialog() {
    final sizeh = MediaQuery.of(context).size.height;
    final sizew = MediaQuery.of(context).size.width;
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      child: _image != null
          ? Padding(
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
                        LocaleKeys.task_submitted.tr(),
                        style: AppTextStyles.bold
                            .copyWith(fontSize: 12.sp, color: Colors.black),
                      ),
                      SizedBox(height: sizeh * .02),
                      Text(
                        LocaleKeys.points_added.tr(),
                        textAlign: TextAlign.center,
                        style: AppTextStyles.light
                            .copyWith(fontSize: 10.sp, color: primaryColor),
                      ),
                      SizedBox(height: sizeh * .03),
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
              ),
            )
          : Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: sizew * .03, vertical: sizeh * .015),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: sizeh * .02,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Text(
                              LocaleKeys.submit_task.tr(),
                              style: AppTextStyles.semiBold.copyWith(
                                  fontSize: 12.5.sp, color: primaryColor),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: sizeh * .025),
                      Text(
                        LocaleKeys.upload_screenshots.tr(),
                        style: AppTextStyles.regular
                            .copyWith(fontSize: 11.5.sp, color: Colors.black),
                      ),
                      SizedBox(height: sizeh * .02),
                      InkWell(
                        onTap: setImage,
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: sizew * .03),
                          padding: EdgeInsets.symmetric(
                              horizontal: sizew * .03, vertical: sizeh * .015),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: DashedBorder.fromBorderSide(
                                  dashLength: 10,
                                  side: BorderSide(
                                      color: Colors.black, width: 1)),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(documentUpload),
                              SizedBox(width: sizew * .02),
                              Text(
                                LocaleKeys.click_to_upload.tr(),
                                style: AppTextStyles.regular.copyWith(
                                    fontSize: 11.sp, color: Color(0xFFA6A6A6)),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: sizeh * .035),
                      Center(
                        child: ButtonWidget(
                            radius: 5,
                            textStyle: AppTextStyles.regular
                                .copyWith(fontSize: 12.sp, color: Colors.white),
                            height: sizeh * .05,
                            width: sizew * .45,
                            text: LocaleKeys.submit.tr(),
                            onPress: () {
                              Navigator.of(context).pop();
                            }),
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
              ),
            ),
    );
  }
}
