import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class TextWidget extends StatelessWidget {
  final String title;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final double? fontSize;
  final TextOverflow? overflow;
  final Color? color;
  final FontWeight? fontWeight;
  final String? fontFamily;
  final int? maxLines;

  const TextWidget(
    this.title, {
    super.key,
    this.textAlign,
    this.textDirection,
    this.fontSize,
    this.overflow,
    this.fontWeight,
    this.maxLines,
    this.fontFamily,
    this.color = Colors.black,
  });
  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      maxLines: maxLines,
      style: Theme.of(context).textTheme.bodySmall!.copyWith(
            color: color,
            fontWeight: fontWeight,
            fontSize: SizerUtil.deviceType == DeviceType.mobile
                ? fontSize ?? 12.sp
                : fontSize ?? 10.sp,
          ),
      textAlign: textAlign ?? TextAlign.start,
      textDirection: textDirection,
      overflow: overflow ?? TextOverflow.visible,
    );
  }
}
