import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';
import 'package:subrate/theme/app_colors.dart';
import 'package:subrate/theme/text_style.dart';

class SocialButton extends StatelessWidget {
  final String assetName;
  final String title;
  const SocialButton({super.key, required this.assetName, required this.title});

  @override
  Widget build(BuildContext context) {
    final sizeh = MediaQuery.of(context).size.height;
    final sizew = MediaQuery.of(context).size.width;
    return Container(
        decoration: BoxDecoration(
          color: Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(4),
        ),
        padding: EdgeInsets.symmetric(
            horizontal: sizew * .02, vertical: sizeh * .015),
        child: Row(
          children: [
            SvgPicture.asset(
              assetName,
              height: sizeh * .02,
            ),
            SizedBox(
              width: sizew * .02,
            ),
            Text(
              title,
              style: AppTextStyles.regular
                  .copyWith(fontSize: 11.5.sp, color: fontPrimaryColor),
            )
          ],
        ));
  }
}
