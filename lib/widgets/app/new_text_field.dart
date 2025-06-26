import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:sizer/sizer.dart';
import 'package:subrate/theme/app_colors.dart';
import 'package:subrate/theme/text_style.dart';

class NewCustomField extends StatefulWidget {
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
  final Widget? rowWidget;
  const NewCustomField(
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
      this.rowWidget,
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
  State<NewCustomField> createState() => _NewCustomFieldState();
}

class _NewCustomFieldState extends State<NewCustomField> {
  late FocusNode _focusNode;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {}); // Rebuild on focus change
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  Color _getBorderColor() {
    if (_errorText != null) return Colors.red;
    if (_focusNode.hasFocus) return HexColor('#2A2D36'); // Focused color
    if (widget.enabled == false) return HexColor('#E9EAED');
    return HexColor('#E9EAED'); // Normal
  }

  Color _getHintColor() {
    if (_errorText != null) return Colors.red;
    if (_focusNode.hasFocus) return HexColor('#2A2D36');
    if (widget.enabled == false) return HexColor('#E9EAED');
    return HexColor('#8F94A3');
  }

  @override
  Widget build(BuildContext context) {
    final sizeh = MediaQuery.of(context).size.height;
    final sizew = MediaQuery.of(context).size.width;
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.rowWidget == null
              ? Text(
                  widget.title,
                  style: AppTextStyles.semiBold.copyWith(
                      fontSize: 13.sp,
                      color: HexColor('#2A2D36'),
                      fontFamily: 'Inter'),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.title,
                      style: AppTextStyles.medium.copyWith(
                          fontSize: 13.sp,
                          color: HexColor('#2A2D36'),
                          fontFamily: 'Inter'),
                    ),
                    widget.rowWidget!,
                  ],
                ),
          SizedBox(
            height: sizeh * 0.01,
          ),
          SizedBox(
            height:
                _errorText?.isNotEmpty == true ? sizeh * .085 : sizeh * 0.06,
            width: widget.width ?? sizew,
            child: TextFormField(
              enabled: widget.enabled ?? true,
              controller: widget.controller,
              focusNode: _focusNode,
              obscureText: widget.passwordCover ?? false,
              onChanged: (value) {
                if (widget.onChange != null) widget.onChange!(value);
                if (widget.validator != null) {
                  final error = widget.validator!(value);
                  setState(() {
                    _errorText = error;
                  });
                }
              },
              keyboardType: widget.keyboardType,
              validator: (value) {
                final error = widget.validator != null
                    ? widget.validator!(value)
                    : (value == null || value.isEmpty)
                        ? (widget.errorText ?? 'Please enter some text')
                        : (widget.isPassword == true && value.length < 8)
                            ? 'Password must be 8 characters'
                            : (widget.isPhone == true && value.length < 8)
                                ? 'Phone must be 8 characters'
                                : null;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (_errorText != error) {
                    setState(() {
                      _errorText = error;
                    });
                  }
                });
                return error;
              },
              minLines: 1,
              maxLines: widget.isNote ? 5 : 1,
              style: widget.style ??
                  AppTextStyles.regular
                      .copyWith(fontSize: 12.sp, color: primaryColor),
              inputFormatters: widget.isPhone == true
                  ? <TextInputFormatter>[
                      LengthLimitingTextInputFormatter(widget.didgits ?? 10),
                      FilteringTextInputFormatter.digitsOnly,
                    ]
                  : [],
              decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                  suffixIcon: widget.widget == null
                      ? null
                      : SizedBox(
                          height: sizeh * .03,
                          child: widget.widget,
                        ),
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  prefixIcon:
                      widget.prefixIcon == null ? null : widget.prefixIcon,
                  prefix: widget.suffixIcon,
                  labelStyle: widget.labelStyle ??
                      AppTextStyles.regular.copyWith(
                          fontSize: 12.sp, color: HexColor('#E9EAED')),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(
                      color: _getBorderColor(),
                      width: 2,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(
                      color: _getBorderColor(),
                      width: 2,
                    ),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(
                      color: _getBorderColor(),
                      width: 2,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.red, width: 2),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.red, width: 2),
                  ),
                  hintText: widget.hintText,
                  hintStyle: AppTextStyles.regular.copyWith(
                    fontSize: 12.sp,
                    color: _getHintColor(),
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
