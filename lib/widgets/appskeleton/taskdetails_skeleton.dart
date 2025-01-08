import 'package:flutter/material.dart';

import 'package:subrate/widgets/appskeleton/skeleton_container.dart';

class TaskdetailsSkeleton extends StatelessWidget {
  const TaskdetailsSkeleton({super.key});

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
          Row(
            children: [
              SkeletonContainer(
                height: sizeh * .04,
                width: sizew * .1,
                radius: 7,
              ),
              SizedBox(
                width: sizew * .03,
              ),
              SkeletonContainer(
                height: sizeh * .02,
                width: sizew * .3,
                radius: 0,
              ),
            ],
          ),
          SizedBox(
            height: sizeh * .03,
          ),
          SkeletonContainer(
            height: sizeh * .02,
            width: sizew * .35,
            radius: 0,
          ),
          SizedBox(
            height: sizeh * .01,
          ),
          SkeletonContainer(
            height: sizeh * .02,
            width: sizew,
            radius: 0,
          ),
          SizedBox(
            height: sizeh * .005,
          ),
          SkeletonContainer(
            height: sizeh * .02,
            width: sizew,
            radius: 0,
          ),
          SizedBox(
            height: sizeh * .005,
          ),
          SkeletonContainer(
            height: sizeh * .02,
            width: sizew * .5,
            radius: 0,
          ),
          SizedBox(
            height: sizeh * .03,
          ),
          SkeletonContainer(
            height: sizeh * .02,
            width: sizew * .35,
            radius: 0,
          ),
          SizedBox(
            height: sizeh * .01,
          ),
          SkeletonContainer(
            height: sizeh * .02,
            width: sizew,
            radius: 0,
          ),
          SizedBox(
            height: sizeh * .035,
          ),
          SkeletonContainer(
            height: sizeh * .02,
            width: sizew * .35,
            radius: 0,
          ),
          SizedBox(
            height: sizeh * .035,
          ),
          ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 5,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.symmetric(vertical: sizeh * .01),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SkeletonContainer(
                            height: sizeh * .035,
                            width: sizew * .08,
                            radius: 7,
                          ),
                          SizedBox(
                            width: sizew * .03,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SkeletonContainer(
                                height: sizeh * .015,
                                width: sizew * .25,
                                radius: 0,
                              ),
                              SizedBox(
                                height: sizeh * .01,
                              ),
                              SkeletonContainer(
                                height: sizeh * .015,
                                width: sizew * .3,
                                radius: 0,
                              ),
                            ],
                          ),
                        ],
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
