import 'package:flutter/material.dart';

import 'package:subrate/widgets/appskeleton/skeleton_container.dart';

class WalletSkeleton extends StatelessWidget {
  const WalletSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final sizeh = MediaQuery.of(context).size.height;
    final sizew = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: sizew * .035, vertical: sizeh * .015),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: sizeh * .06,
          ),
          SkeletonContainer(
            height: sizeh * .022,
            width: sizew * .3,
            radius: 0,
          ),
          SizedBox(height: sizeh * .025),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SkeletonContainer(
                height: sizeh * .119,
                width: sizew * .45,
                radius: 5,
              ),
              SkeletonContainer(
                height: sizeh * .119,
                width: sizew * .45,
                radius: 5,
              ),
            ],
          ),
          SizedBox(
            height: sizeh * .025,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SkeletonContainer(
                height: sizeh * .02,
                width: sizew * .28,
                radius: 0,
              ),
              SkeletonContainer(
                height: sizeh * .04,
                width: sizew * .3,
                radius: 5,
              ),
            ],
          ),
          SizedBox(
            height: sizeh * .03,
          ),
          ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 4,
              itemBuilder: (context, index) {
                return Container(
                    margin: EdgeInsets.symmetric(vertical: sizeh * .02),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SkeletonContainer(
                              height: sizeh * .02,
                              width: sizew * .3,
                              radius: 0,
                            ),
                            SizedBox(
                              height: sizeh * .015,
                            ),
                            SkeletonContainer(
                              height: sizeh * .02,
                              width: sizew * .45,
                              radius: 0,
                            ),
                          ],
                        ),
                        SkeletonContainer(
                          height: sizeh * .035,
                          width: sizew * .25,
                          radius: 5,
                        ),
                      ],
                    ));
              })
        ],
      ),
    );
  }
}
