import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:subrate/models/app/choicess.dart';
import 'package:subrate/routers/routers.dart';
import 'package:subrate/theme/app_colors.dart';
import 'package:subrate/theme/text_style.dart';
import 'package:subrate/widgets/app/button.dart';
import 'package:subrate/widgets/onboarding/page_slider.dart';

import '../../translations/locale_keys.g.dart';

class SliderWidget extends StatefulWidget {
  const SliderWidget({super.key});

  @override
  State<SliderWidget> createState() => _SliderWidgetState();
}

class _SliderWidgetState extends State<SliderWidget> {
  final _controller = PageController();
  bool isLastPage = false;
  @override
  void dispose() {
    _controller.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  int? indeX;
  @override
  Widget build(BuildContext context) {
    final Routers routers = Routers();

    final sizeh = MediaQuery.of(context).size.height;
    final sizew = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Container(
            padding: EdgeInsets.symmetric(
                horizontal: sizew * .0, vertical: sizeh * .02),
            height: sizeh * .78,
            width: sizew,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: sizeh * .06,
                ),
                // isLastPage
                //     ? SizedBox(
                //         height: sizeh * .05,
                //       )
                //     : InkWell(
                //         onTap: () async {
                //           final prefs = await SharedPreferences.getInstance();
                //           prefs.setBool('showHome', true);
                //           routers.navigateToEnterNumberScreen(context);
                //         },
                //         child: Align(
                //           alignment: Alignment.topRight,
                //           child: SizedBox(
                //             height: sizeh * .035,
                //             child: Text(LocaleKeys.skip.tr(),
                //                 style: TextStyle(
                //                     fontSize: 12.sp,
                //                     fontWeight: FontWeight.w400,
                //                     color: HexColor(primaryColor))),
                //           ),
                //         ),
                //       ),

                SizedBox(
                  height: sizeh * .68,
                  width: sizew,
                  child: PageView.builder(
                    onPageChanged: (index) => setState(() {
                      indeX = index;
                      print(index);
                      isLastPage = index == onBoadrdingChoices.length - 1;
                    }),
                    controller: _controller,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      indeX = index;

                      return PageSlider(
                          path: onBoadrdingChoices[index].choiceImage,
                          title: onBoadrdingChoices[index].name,
                          subTitle: onBoadrdingChoices[index].subTitle ??
                              'Description');
                    },
                    itemCount: onBoadrdingChoices.length,
                  ),
                ),
              ],
            )),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: sizew * .07),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SmoothPageIndicator(
                controller: _controller,
                count: onBoadrdingChoices.length,
                effect: WormEffect(
                    dotWidth: 40,
                    dotHeight: 6,
                    spacing: 10,
                    dotColor: Color(0xFF786FE9).withOpacity(.2),
                    activeDotColor: primaryColor),
                onDotClicked: (index) {
                  _controller.animateToPage(index,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.bounceIn);
                },
              ),
            ],
          ),
        ),
        SizedBox(
          height: sizeh * .1,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: sizew * .07),
          child: SizedBox(
            height: sizeh * .06,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  LocaleKeys.skip.tr(),
                  style: AppTextStyles.semiBold
                      .copyWith(fontSize: 13.sp, color: yallewTextColor),
                ),
                ButtonWidget(
                  radius: 10,
                  width: sizew * .23,
                  height: sizeh * .045,
                  text: '',
                  onPress: isLastPage
                      ? () async {
                          final prefs = await SharedPreferences.getInstance();
                          prefs.setBool('showHome', true);
                          routers.navigateToSigninScreen(context);
                        }
                      : () {
                          _controller.nextPage(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.bounceInOut);
                        },
                  widget: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        isLastPage
                            ? LocaleKeys.start.tr()
                            : LocaleKeys.next.tr(),
                        style: AppTextStyles.semiBold.copyWith(
                          fontSize: 12.sp,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        width: sizew * .02,
                      ),
                      Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                      )
                    ],
                  ),
                ),
                // isLastPage
                //     ? Padding(
                //         padding: EdgeInsets.symmetric(horizontal: sizew * .05),
                //         child: ButtonWidget(
                //           borderColor: HexColor('#1995AD'),
                //           text: LocaleKeys.start.tr(),
                //           buttonColor: Colors.transparent,
                //           onPress: () async {
                //             final prefs = await SharedPreferences.getInstance();
                //             prefs.setBool('showHome', true);
                //             // routers.navigateToEnterNumberScreen(context);
                //           },
                //           width: sizew * .4,
                //           textColor: HexColor('#1995AD'),
                //           fontWeight: FontWeight.w500,
                //         ))
                //     : Padding(
                //         padding: EdgeInsets.symmetric(horizontal: sizew * .05),
                //         child: InkWell(
                //             onTap: () {
                //               _controller.nextPage(
                //                   duration: const Duration(milliseconds: 400),
                //                   curve: Curves.bounceInOut);
                //             },
                //             child: Text(
                //               LocaleKeys.next.tr(),
                //               style: TextStyle(
                //                   fontSize: 14.5.sp,
                //                   color: HexColor('#1995AD'),
                //                   fontWeight: FontWeight.bold),
                //             )),
                //       ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
