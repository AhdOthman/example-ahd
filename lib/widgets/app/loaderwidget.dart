import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class LoaderWidget extends StatelessWidget {
  final Color? backgroundColor;

  const LoaderWidget({super.key, this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    final sizew = MediaQuery.of(context).size.width;
    return Center(
      child: Container(
          color: Colors.transparent,
          height: 45,
          width: 45,
          child: CupertinoActivityIndicator(
            color: HexColor('000000'),
            radius: sizew * .05,
          )

          // LoadingIndicator(
          //   indicatorType: Indicator.,
          //   colors: [backgroundColor ?? Theme.of(context).primaryColor],
          //   strokeWidth: 5,
          // )

          ),
    );
  }
}
