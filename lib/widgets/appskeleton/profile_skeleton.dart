import 'package:flutter/material.dart';

import 'package:subrate/widgets/appskeleton/skeleton_container.dart';

class ProfileSkeleton extends StatelessWidget {
  const ProfileSkeleton({super.key});

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
          SizedBox(height: sizeh * .03),
          Center(
            child: SkeletonContainer.circle(
              height: sizeh * .085,
              width: sizew * .21,
              radius: 200,
            ),
          ),
          SizedBox(
            height: sizeh * .015,
          ),
          Center(
            child: SkeletonContainer(
              height: sizeh * .02,
              width: sizew * .3,
              radius: 0,
            ),
          ),
          SizedBox(
            height: sizeh * .005,
          ),
          Center(
            child: SkeletonContainer(
              height: sizeh * .02,
              width: sizew * .25,
              radius: 0,
            ),
          ),
          SizedBox(
            height: sizeh * .035,
          ),
          SkeletonContainer(
            height: sizeh * .02,
            width: sizew * .3,
            radius: 0,
          ),
          SizedBox(
            height: sizeh * .025,
          ),
          ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 4,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.symmetric(vertical: sizeh * .01),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SkeletonContainer(
                            height: sizeh * .06,
                            width: sizew * .14,
                            radius: 7,
                          ),
                          SizedBox(
                            width: sizew * .03,
                          ),
                          SkeletonContainer(
                            height: sizeh * .02,
                            width: sizew * .25,
                            radius: 0,
                          ),
                        ],
                      ),
                      SkeletonContainer(
                        height: sizeh * .035,
                        width: sizew * .08,
                        radius: 7,
                      ),
                    ],
                  ),
                );
              })
        ],
      ),
    );
  }
}
