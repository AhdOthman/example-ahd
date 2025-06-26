import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:sizer/sizer.dart';
import 'package:subrate/theme/app_colors.dart';
import 'package:subrate/theme/text_style.dart';

class ButtonWidget extends StatelessWidget {
  final String text;
  final Function onPress;
  final double? fontSize;
  final double? width;
  final double? radius;
  final Color? buttonColor;
  final Color? shadowColor;
  final double? height;
  final Color? textColor;
  final Color? borderColor;
  final Widget? widget;
  final FontWeight? fontWeight;
  final double? padding;
  final TextStyle? textStyle;
  final double? borderWidth;
  ButtonWidget(
      {Key? key,
      this.height,
      required this.text,
      required this.onPress,
      this.borderWidth,
      this.textStyle,
      this.padding,
      this.fontWeight,
      this.shadowColor,
      this.radius,
      this.fontSize,
      this.borderColor,
      this.width,
      this.widget,
      this.buttonColor,
      this.textColor})
      : super(key: key);
  final Color color = HexColor('#29ABE2');
  @override
  Widget build(BuildContext context) {
    final sizeh = MediaQuery.of(context).size.height;
    final sizew = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () {
        onPress();
      },
      child: Container(
        height: height ?? sizeh * .06,
        width: width ?? sizew * .9,
        padding: EdgeInsets.only(bottom: padding ?? 0),
        decoration: BoxDecoration(
            color: buttonColor ?? primaryColor,
            boxShadow: [
              BoxShadow(
                color: shadowColor ?? Colors.white.withOpacity(.3),
                blurRadius: 1,
                spreadRadius: 1,
                offset: const Offset(0, 5),
              )
            ],
            border: Border.all(
                color: borderColor ?? Colors.transparent,
                width: borderWidth ?? 2),
            borderRadius: BorderRadius.circular(radius ?? 6)),
        child: Center(
          child: widget ??
              Text(text,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: textStyle ??
                      AppTextStyles.semiBold.copyWith(
                          fontSize: 14.sp, color: HexColor('#1C1E29'))),
        ),
      ),
    );
  }
}
