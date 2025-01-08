import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:sizer/sizer.dart';

class EmptyWidget extends StatelessWidget {
  final String path;
  final String title;
  EmptyWidget({Key? key, required this.path, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sizew = MediaQuery.of(context).size.width;
    final sizeh = MediaQuery.of(context).size.height;
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            path,
            width: sizew,
            height: sizeh * .2,
          ),
          SizedBox(height: sizeh * .02),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
                color: HexColor('000000')),
          ),
        ],
      ),
    );
  }
}
