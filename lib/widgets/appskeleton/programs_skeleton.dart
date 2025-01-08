import 'package:flutter/material.dart';

import 'package:subrate/widgets/appskeleton/skeleton_container.dart';

class ProgramsSkeleton extends StatelessWidget {
  const ProgramsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final sizeh = MediaQuery.of(context).size.height;
    final sizew = MediaQuery.of(context).size.width;

    return Container(
      margin: EdgeInsets.symmetric(vertical: sizeh * .005),
      child: GridView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(horizontal: sizew * .02),
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio: 28 / 14,
            mainAxisExtent: sizeh * 0.16),
        itemBuilder: (context, index) {
          return SkeletonContainer(
            height: sizeh * .14,
            width: sizew * .38,
            radius: 5,
          );
        },
        itemCount: 8,
      ),
    );
  }
}
