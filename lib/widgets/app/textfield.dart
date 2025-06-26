import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:sizer/sizer.dart';
import 'package:subrate/theme/app_colors.dart';
import 'package:subrate/theme/text_style.dart';

class CustomField extends StatelessWidget {
  final String title;
  final String hintText;
  final TextInputType? keyboardType;
  final double? hintSize;
  final bool? passwordCover;
  final TextStyle? hint;
  final TextStyle? style;
  final bool? isPassword;
  final bool? isPhone;
  final int? didgits;
  final TextStyle? labelStyle;
  final bool isNote;
  final String? Function(String?)? validator;
  final Widget? widget;
  final Widget? prefixIcon;
  final Color? labelColor;
  final Widget? suffixIcon;
  final double? width;
  final Color? disabledBorder;
  final bool? enabled;
  final TextEditingController? controller;
  final void Function(String value)? onChange;
  final String? errorText;
  final bool? isCustomField;
  const CustomField(
      {super.key,
      required this.hintText,
      this.didgits,
      this.isCustomField,
      this.disabledBorder,
      this.labelStyle,
      this.widget,
      this.errorText,
      this.width,
      this.labelColor,
      this.style,
      this.prefixIcon,
      this.isPhone,
      this.hint,
      this.enabled,
      required this.title,
      this.isPassword,
      this.suffixIcon,
      required this.hintSize,
      this.passwordCover = false,
      this.isNote = false,
      this.keyboardType = TextInputType.text,
      required this.controller,
      this.validator,
      this.onChange});

  @override
  Widget build(BuildContext context) {
    final sizeh = MediaQuery.of(context).size.height;
    final sizew = MediaQuery.of(context).size.width;
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          isCustomField == true
              ? Text(
                  title,
                  style: AppTextStyles.medium.copyWith(
                      fontSize: 13.sp,
                      color: HexColor('#2A2D36'),
                      fontFamily: 'Inter'),
                )
              : SizedBox(),
          SizedBox(
            height: isCustomField == true ? sizeh * 0.01 : 0,
          ),
          SizedBox(
            height: sizeh * 0.075,
            width: width ?? sizew,
            child: TextFormField(
              enabled: enabled ?? true,
              controller: controller,
              obscureText: passwordCover ?? false,
              onChanged: onChange,
              keyboardType: keyboardType,
              validator: validator ??
                  (value) {
                    if (value!.isEmpty) {
                      return errorText ?? 'Please enter some text';
                    }
                    if (isPassword == true && value.length < 8) {
                      return 'Password must be 8 characters';
                    }
                    if (isPhone == true && value.length < 8) {
                      return 'Phone must be 8 characters';
                    }
                    return null;
                  },
              minLines: 1,
              maxLines: isNote ? 5 : 1,
              style: style ??
                  AppTextStyles.regular
                      .copyWith(fontSize: 12.sp, color: primaryColor),
              inputFormatters: isPhone == true
                  ? <TextInputFormatter>[
                      LengthLimitingTextInputFormatter(didgits ?? 10),
                      FilteringTextInputFormatter.digitsOnly,
                    ]
                  : [],
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                contentPadding: EdgeInsets.symmetric(
                    horizontal: isCustomField == true ? 16 : 0, vertical: 2),
                labelText: isCustomField == true ? null : hintText,
                suffixIcon: widget == null
                    ? null
                    : SizedBox(
                        height: sizeh * .03,
                        child: widget,
                      ),
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                prefixIcon: prefixIcon == null ? null : prefixIcon,
                prefix: suffixIcon,
                labelStyle: labelStyle ??
                    AppTextStyles.regular.copyWith(
                        fontSize: 12.sp,
                        color: labelColor ?? Color(0xFF757575)),
                enabledBorder: isCustomField == true
                    ? OutlineInputBorder(
                        borderSide:
                            BorderSide(color: HexColor('#E2E8F0'), width: 1),
                      )
                    : UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: disabledBorder ?? Color(0xFFCBD5E1),
                            width: 1),
                      ),
                focusedBorder: isCustomField == true
                    ? OutlineInputBorder(
                        borderSide:
                            BorderSide(color: HexColor('#E2E8F0'), width: 1),
                      )
                    : UnderlineInputBorder(
                        borderSide: BorderSide(color: primaryColor, width: 1),
                      ),
                disabledBorder: isCustomField == true
                    ? OutlineInputBorder(
                        borderSide:
                            BorderSide(color: HexColor('#E2E8F0'), width: 1),
                      )
                    : UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: disabledBorder ?? Color(0xFFCBD5E1),
                            width: 1),
                      ),
                errorBorder: isCustomField == true
                    ? OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 1),
                      )
                    : UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 1),
                      ),
                focusedErrorBorder: isCustomField == true
                    ? OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 1),
                      )
                    : UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 1),
                      ),
                hintText: hintText,
                hintStyle: hint,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
