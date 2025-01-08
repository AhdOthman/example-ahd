import 'package:flutter/material.dart';
import 'package:subrate/theme/app_colors.dart';
import 'package:subrate/widgets/onboarding/slider.dart';

class OnBoardingScreen extends StatefulWidget {
  static const routeName = 'onboadring';
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [SliderWidget()],
      ),
    );
  }
}
