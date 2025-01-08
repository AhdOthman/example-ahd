import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';
import 'package:subrate/theme/app_colors.dart';
import 'package:subrate/theme/text_style.dart';

class BottomBarItem extends StatelessWidget {
  final String iconPath;
  final int selectedIndex;
  final int index;
  final String title;
  final bool? isForProfile;
  const BottomBarItem(
      {super.key,
      required this.iconPath,
      this.isForProfile = false,
      required this.index,
      required this.selectedIndex,
      required this.title});

  @override
  Widget build(BuildContext context) {
    final sizeh = MediaQuery.of(context).size.height;
    final sizew = MediaQuery.of(context).size.width;
    var isTablet = sizew > 600;

    return SizedBox(
      height: isTablet ? sizeh * .08 : sizeh * .06,
      width: sizew * .18,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          selectedIndex == index
              ? Container(
                  margin: EdgeInsets.only(bottom: sizeh * .003),
                  height: sizeh * .007,
                  width: sizew * .04,
                  decoration: const BoxDecoration(
                      color: yallewTextColor, shape: BoxShape.circle
                      // borderRadius: const BorderRadius.only(
                      //     topRight: Radius.circular(20),
                      //     topLeft: Radius.circular(20)),
                      ),
                )
              : Container(),
          isForProfile == true
              ? SvgPicture.asset(
                  iconPath,
                  height: isTablet ? sizeh * .03 : sizeh * .025,
                )
              : SvgPicture.asset(
                  iconPath,
                  height: isTablet ? sizeh * .03 : sizeh * .025,
                  color: selectedIndex == index
                      ? yallewTextColor
                      : Color(0xFFA6A6A6),
                ),
          Text(
            title,
            style: AppTextStyles.regular.copyWith(
                color: selectedIndex == index
                    ? yallewTextColor
                    : Color(0xFFA6A6A6),
                fontSize: 9.5.sp),
          ),
        ],
      ),
    );
  }
}
