import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:sizer/sizer.dart';
import 'package:subrate/theme/app_colors.dart';
import 'package:subrate/theme/assets_managet.dart';
import 'package:subrate/theme/text_style.dart';

class PaymentMethodCard extends StatelessWidget {
  final Color? color;
  final String name;
  const PaymentMethodCard({super.key, this.color, required this.name});

  @override
  Widget build(BuildContext context) {
    final sizeh = MediaQuery.of(context).size.height;
    final sizew = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.symmetric(vertical: sizeh * .005),
      padding:
          EdgeInsets.symmetric(horizontal: sizew * .02, vertical: sizeh * .015),
      decoration: BoxDecoration(
        color: color ?? HexColor('FCFCFC'),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SvgPicture.asset(bankCard, height: sizeh * .025),
              SizedBox(width: sizew * .02),
              Text(
                name,
                style: AppTextStyles.medium
                    .copyWith(fontSize: 13.sp, color: primaryColor),
              ),
            ],
          ),
          Icon(Icons.arrow_forward_ios, color: primaryColor, size: sizeh * .02)
        ],
      ),
    );
  }
}
