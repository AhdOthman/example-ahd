import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import 'package:subrate/theme/app_colors.dart';
import 'package:subrate/theme/text_style.dart';

class PageSlider extends StatelessWidget {
  final String path;
  final String title;
  final String subTitle;
  const PageSlider(
      {super.key,
      required this.path,
      required this.title,
      required this.subTitle});

  @override
  Widget build(BuildContext context) {
    final sizeh = MediaQuery.of(context).size.height;
    final sizew = MediaQuery.of(context).size.width;

    return SizedBox(
      width: sizew,
      height: sizeh,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: sizeh * .015,
          ),
          Container(
            height: sizeh * .4,
            color: primaryColor,
            child: path.contains('json')
                ? SizedBox(
                    height: sizeh * .3,
                    child: Lottie.asset(path, height: sizeh * .3))
                : path.contains('png') || path.contains('jpg')
                    ? Image.asset(
                        path,
                        width: sizew,
                        height: sizeh * .25,
                        fit: BoxFit.contain,
                      )
                    : SvgPicture.asset(path, width: sizew, height: sizeh * .22),
          ),
          SizedBox(
            height: sizeh * .04,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: sizew * .07),
            child: Text(title,
                style: AppTextStyles.bold
                    .copyWith(fontSize: 20.sp, color: primaryColor)),
          ),
          SizedBox(
            height: sizeh * .04,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: sizew * .07),
            child: Text(subTitle,
                textAlign: TextAlign.start,
                maxLines: 3,
                style: AppTextStyles.regular
                    .copyWith(fontSize: 10.sp, color: fontPrimaryColor)),
          )
        ],
      ),
    );
  }
}
