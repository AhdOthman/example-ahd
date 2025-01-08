// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:skeleton_text/skeleton_text.dart';

class SkeletonContainer extends StatelessWidget {
  final double width;
  final double height;
  final double? radius;
  final Color? gradientColor;
  final Color? shimmerColor;
  final Color? containerColor;
  SkeletonContainer(
      {Key? key,
      required this.height,
      required this.width,
      this.radius,
      this.containerColor,
      this.gradientColor,
      this.shimmerColor})
      : super(key: key);

  const SkeletonContainer._(
      {Key? key,
      required this.height,
      required this.width,
      this.radius,
      this.containerColor,
      this.gradientColor,
      this.shimmerColor})
      : super(key: key);

  SkeletonContainer.square(
      {Key? key,
      required this.height,
      required this.width,
      this.radius,
      this.containerColor,
      this.gradientColor,
      this.shimmerColor});
  SkeletonContainer.circle(
      {Key? key,
      required this.height,
      required this.width,
      this.radius,
      this.containerColor,
      this.gradientColor,
      this.shimmerColor});
  @override
  Widget build(BuildContext context) {
    return SkeletonAnimation(
        gradientColor: gradientColor ?? const Color.fromARGB(0, 244, 244, 244),
        shimmerColor: shimmerColor ?? Colors.white54,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: containerColor ?? Colors.grey[300],
            borderRadius: BorderRadius.circular(radius ?? 5),
          ),
        ));
  }
}
